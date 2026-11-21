-- =====================================================================
-- Sistema Integral de Gestion de Citas Medicas - Centro Medico Sagrado Corazon
-- Esquema Normalizado Multiplataforma (Escritorio, Android, Web, Laravel API)
-- Base de Datos: innegone_bd_medicdate
-- Version: 2.1 (Definitiva y Normalizada en 3FN)
-- Compatible con MariaDB 11.4+ / MySQL 8.0.16+
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `innegone_bd_medicdate`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `innegone_bd_medicdate`;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- =====================================================================
-- 1. IDENTIDAD Y CONTROL DE ACCESO
-- =====================================================================

CREATE TABLE IF NOT EXISTS `persona` (
  `id_persona` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(100) NOT NULL,
  `apellido_paterno` VARCHAR(80) NOT NULL,
  `apellido_materno` VARCHAR(80) DEFAULT NULL,
  `fecha_nacimiento` DATE DEFAULT NULL,
  `correo_contacto` VARCHAR(254) DEFAULT NULL,
  `telefono_principal` VARCHAR(25) DEFAULT NULL,
  `telefono_secundario` VARCHAR(25) DEFAULT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_persona`),
  KEY `idx_persona_nombre` (`apellido_paterno`, `apellido_materno`, `nombres`),
  KEY `idx_persona_correo_contacto` (`correo_contacto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rol` (
  `id_rol` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(40) NOT NULL,
  `descripcion` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `uq_rol_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `permiso` (
  `id_permiso` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(80) NOT NULL,
  `descripcion` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE KEY `uq_permiso_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rol_permiso` (
  `id_rol` SMALLINT UNSIGNED NOT NULL,
  `id_permiso` SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_rol`, `id_permiso`),
  KEY `idx_rol_permiso_permiso` (`id_permiso`),
  CONSTRAINT `fk_rol_permiso_rol`
    FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rol_permiso_permiso`
    FOREIGN KEY (`id_permiso`) REFERENCES `permiso` (`id_permiso`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_persona` BIGINT UNSIGNED NOT NULL,
  `correo_acceso` VARCHAR(254) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `estado` ENUM('activa', 'inactiva', 'bloqueada') NOT NULL DEFAULT 'activa',
  `cambio_password_obligatorio` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ultimo_acceso` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuario_persona` (`id_persona`),
  UNIQUE KEY `uq_usuario_correo_acceso` (`correo_acceso`),
  KEY `idx_usuario_estado` (`estado`),
  CONSTRAINT `fk_usuario_persona`
    FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `usuario_rol` (
  `id_usuario` BIGINT UNSIGNED NOT NULL,
  `id_rol` SMALLINT UNSIGNED NOT NULL,
  `fecha_asignacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`, `id_rol`),
  KEY `idx_usuario_rol_rol` (`id_rol`),
  CONSTRAINT `fk_usuario_rol_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario_rol_rol`
    FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 2. UBICACION GEOGRAFICA Y DOMICILIOS (NORMALIZACION EN 3FN)
-- =====================================================================

CREATE TABLE IF NOT EXISTS `municipio` (
  `id_municipio` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `estado` VARCHAR(50) NOT NULL DEFAULT 'Hidalgo',
  `codigo_postal` VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (`id_municipio`),
  KEY `idx_municipio_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `direccion` (
  `id_direccion` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_persona` BIGINT UNSIGNED NOT NULL,
  `calle` VARCHAR(120) NOT NULL,
  `numero` VARCHAR(30) DEFAULT NULL,
  `colonia` VARCHAR(100) DEFAULT NULL,
  `localidad` VARCHAR(100) DEFAULT NULL,
  `id_municipio` INT UNSIGNED DEFAULT NULL,
  `codigo_postal` VARCHAR(10) DEFAULT NULL,
  `referencia` VARCHAR(255) DEFAULT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_direccion`),
  KEY `idx_direccion_persona` (`id_persona`),
  KEY `idx_direccion_municipio` (`id_municipio`),
  CONSTRAINT `fk_direccion_persona`
    FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_direccion_municipio`
    FOREIGN KEY (`id_municipio`) REFERENCES `municipio` (`id_municipio`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 3. PERFILES DE PACIENTE Y PERSONAL
-- =====================================================================

CREATE TABLE IF NOT EXISTS `paciente` (
  `id_paciente` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_persona` BIGINT UNSIGNED NOT NULL,
  `alergias` TEXT DEFAULT NULL,
  `notas_medicas` TEXT DEFAULT NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `uq_paciente_persona` (`id_persona`),
  KEY `idx_paciente_estado` (`estado`),
  CONSTRAINT `fk_paciente_persona`
    FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `empleado` (
  `id_empleado` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_persona` BIGINT UNSIGNED NOT NULL,
  `curp` CHAR(18) DEFAULT NULL,
  `fecha_contratacion` DATE DEFAULT NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `uq_empleado_persona` (`id_persona`),
  UNIQUE KEY `uq_empleado_curp` (`curp`),
  KEY `idx_empleado_estado` (`estado`),
  CONSTRAINT `fk_empleado_persona`
    FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `asistente` (
  `id_empleado` BIGINT UNSIGNED NOT NULL,
  `turno` VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  CONSTRAINT `fk_asistente_empleado`
    FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `doctor` (
  `id_empleado` BIGINT UNSIGNED NOT NULL,
  `cedula_profesional` VARCHAR(50) NOT NULL,
  `descripcion_publica` TEXT DEFAULT NULL,
  `foto_ruta` VARCHAR(255) DEFAULT NULL,
  `publicado` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `uq_doctor_cedula_profesional` (`cedula_profesional`),
  CONSTRAINT `fk_doctor_empleado`
    FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 4. CATALOGOS CLINICOS Y ATENCION MEDICA (UNIFICADO CON SERVICIOS)
-- =====================================================================

CREATE TABLE IF NOT EXISTS `especialidad` (
  `id_especialidad` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `resumen` VARCHAR(200) DEFAULT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_especialidad`),
  UNIQUE KEY `uq_especialidad_nombre` (`nombre`),
  KEY `idx_especialidad_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `doctor_especialidad` (
  `id_empleado` BIGINT UNSIGNED NOT NULL,
  `id_especialidad` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_empleado`, `id_especialidad`),
  KEY `idx_doctor_especialidad_especialidad` (`id_especialidad`),
  CONSTRAINT `fk_doctor_especialidad_doctor`
    FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_especialidad_especialidad`
    FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `consultorio` (
  `id_consultorio` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(30) NOT NULL,
  `nombre` VARCHAR(100) DEFAULT NULL,
  `descripcion` VARCHAR(255) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_consultorio`),
  UNIQUE KEY `uq_consultorio_codigo` (`codigo`),
  KEY `idx_consultorio_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla unificada de servicios y tipos de atencion (resuelve redundancia con 3FN)
CREATE TABLE IF NOT EXISTS `tipo_atencion` (
  `id_tipo_atencion` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_especialidad` INT UNSIGNED DEFAULT NULL,
  `nombre` VARCHAR(120) NOT NULL,
  `resumen` VARCHAR(200) DEFAULT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `duracion_minutos` SMALLINT UNSIGNED NOT NULL,
  `costo_base` DECIMAL(10,2) DEFAULT NULL,
  `moneda` CHAR(3) NOT NULL DEFAULT 'MXN',
  `orden` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `publicado_web` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_atencion`),
  UNIQUE KEY `uq_tipo_atencion_nombre_especialidad` (`nombre`, `id_especialidad`),
  KEY `idx_tipo_atencion_especialidad` (`id_especialidad`),
  KEY `idx_tipo_atencion_activo` (`activo`),
  KEY `idx_tipo_atencion_web` (`publicado_web`, `orden`),
  CONSTRAINT `chk_tipo_atencion_duracion` CHECK (`duracion_minutos` > 0),
  CONSTRAINT `chk_tipo_atencion_costo` CHECK (`costo_base` IS NULL OR `costo_base` >= 0),
  CONSTRAINT `fk_tipo_atencion_especialidad`
    FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 5. HORARIOS, BLOQUEOS Y CITAS MEDICAS
-- =====================================================================

CREATE TABLE IF NOT EXISTS `horario_atencion` (
  `id_horario` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_empleado` BIGINT UNSIGNED NOT NULL,
  `id_consultorio` INT UNSIGNED DEFAULT NULL,
  `dia_semana` TINYINT UNSIGNED NOT NULL COMMENT 'ISO-8601: lunes=1 ... domingo=7',
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `intervalo_minutos` SMALLINT UNSIGNED NOT NULL DEFAULT 30,
  `vigencia_desde` DATE NOT NULL,
  `vigencia_hasta` DATE DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_horario`),
  KEY `idx_horario_doctor_dia` (`id_empleado`, `dia_semana`, `activo`),
  KEY `idx_horario_consultorio_dia` (`id_consultorio`, `dia_semana`, `activo`),
  CONSTRAINT `chk_horario_dia` CHECK (`dia_semana` BETWEEN 1 AND 7),
  CONSTRAINT `chk_horario_horas` CHECK (`hora_fin` > `hora_inicio`),
  CONSTRAINT `chk_horario_intervalo` CHECK (`intervalo_minutos` > 0),
  CONSTRAINT `chk_horario_vigencia` CHECK (`vigencia_hasta` IS NULL OR `vigencia_hasta` >= `vigencia_desde`),
  CONSTRAINT `fk_horario_doctor`
    FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_horario_consultorio`
    FOREIGN KEY (`id_consultorio`) REFERENCES `consultorio` (`id_consultorio`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `bloqueo_horario` (
  `id_bloqueo` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_empleado` BIGINT UNSIGNED NOT NULL,
  `id_consultorio` INT UNSIGNED DEFAULT NULL,
  `inicio` DATETIME NOT NULL,
  `fin` DATETIME NOT NULL,
  `motivo` VARCHAR(255) DEFAULT NULL,
  `id_usuario_registro` BIGINT UNSIGNED NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bloqueo`),
  KEY `idx_bloqueo_doctor_intervalo` (`id_empleado`, `inicio`, `fin`),
  KEY `idx_bloqueo_consultorio_intervalo` (`id_consultorio`, `inicio`, `fin`),
  CONSTRAINT `chk_bloqueo_intervalo` CHECK (`fin` > `inicio`),
  CONSTRAINT `fk_bloqueo_doctor`
    FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_consultorio`
    FOREIGN KEY (`id_consultorio`) REFERENCES `consultorio` (`id_consultorio`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_usuario`
    FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cita` (
  `id_cita` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_paciente` BIGINT UNSIGNED NOT NULL,
  `id_empleado` BIGINT UNSIGNED NOT NULL,
  `id_consultorio` INT UNSIGNED DEFAULT NULL,
  `id_tipo_atencion` INT UNSIGNED NOT NULL,
  `inicio` DATETIME NOT NULL,
  `fin` DATETIME NOT NULL,
  `estado` ENUM('pendiente', 'confirmada', 'en_progreso', 'completada', 'cancelada', 'inasistencia')
    NOT NULL DEFAULT 'pendiente',
  `canal_registro` ENUM('movil', 'web', 'escritorio') NOT NULL DEFAULT 'movil',
  `motivo` VARCHAR(500) DEFAULT NULL,
  `notas_internas` TEXT DEFAULT NULL,
  `costo` DECIMAL(10,2) DEFAULT NULL,
  `moneda` CHAR(3) NOT NULL DEFAULT 'MXN',
  `id_usuario_registro` BIGINT UNSIGNED NOT NULL,
  `id_usuario_cancelacion` BIGINT UNSIGNED DEFAULT NULL,
  `motivo_cancelacion` VARCHAR(500) DEFAULT NULL,
  `fecha_cancelacion` DATETIME DEFAULT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cita`),
  KEY `idx_cita_doctor_intervalo` (`id_empleado`, `inicio`, `fin`),
  KEY `idx_cita_consultorio_intervalo` (`id_consultorio`, `inicio`, `fin`),
  KEY `idx_cita_paciente_inicio` (`id_paciente`, `inicio`),
  KEY `idx_cita_estado_inicio` (`estado`, `inicio`),
  KEY `idx_cita_canal` (`canal_registro`),
  CONSTRAINT `chk_cita_intervalo` CHECK (`fin` > `inicio`),
  CONSTRAINT `chk_cita_costo` CHECK (`costo` IS NULL OR `costo` >= 0),
  CONSTRAINT `chk_cita_cancelacion` CHECK (
    (`estado` = 'cancelada' AND `fecha_cancelacion` IS NOT NULL)
    OR (`estado` <> 'cancelada' AND `fecha_cancelacion` IS NULL)
  ),
  CONSTRAINT `fk_cita_paciente`
    FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_doctor`
    FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_consultorio`
    FOREIGN KEY (`id_consultorio`) REFERENCES `consultorio` (`id_consultorio`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_tipo_atencion`
    FOREIGN KEY (`id_tipo_atencion`) REFERENCES `tipo_atencion` (`id_tipo_atencion`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_usuario_registro`
    FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_usuario_cancelacion`
    FOREIGN KEY (`id_usuario_cancelacion`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `historial_cita` (
  `id_historial` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_cita` BIGINT UNSIGNED NOT NULL,
  `id_usuario` BIGINT UNSIGNED DEFAULT NULL,
  `estado_anterior` ENUM('pendiente', 'confirmada', 'en_progreso', 'completada', 'cancelada', 'inasistencia')
    DEFAULT NULL,
  `estado_nuevo` ENUM('pendiente', 'confirmada', 'en_progreso', 'completada', 'cancelada', 'inasistencia')
    DEFAULT NULL,
  `accion` VARCHAR(60) NOT NULL,
  `observacion` VARCHAR(500) DEFAULT NULL,
  `fecha_evento` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historial`),
  KEY `idx_historial_cita_fecha` (`id_cita`, `fecha_evento`),
  KEY `idx_historial_usuario_fecha` (`id_usuario`, `fecha_evento`),
  CONSTRAINT `fk_historial_cita`
    FOREIGN KEY (`id_cita`) REFERENCES `cita` (`id_cita`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_historial_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 6. SESIONES, NOTIFICACIONES Y SEGURIDAD (AMBOS MECANISMOS)
-- =====================================================================

CREATE TABLE IF NOT EXISTS `sesion_usuario` (
  `id_sesion` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario` BIGINT UNSIGNED NOT NULL,
  `token_hash` CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `plataforma` ENUM('web', 'android', 'escritorio') NOT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_expiracion` DATETIME NOT NULL,
  `fecha_revocacion` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_sesion`),
  UNIQUE KEY `uq_sesion_token_hash` (`token_hash`),
  KEY `idx_sesion_usuario_expiracion` (`id_usuario`, `fecha_expiracion`),
  CONSTRAINT `chk_sesion_expiracion` CHECK (`fecha_expiracion` > `fecha_creacion`),
  CONSTRAINT `fk_sesion_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `token_recuperacion` (
  `id_token` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario` BIGINT UNSIGNED NOT NULL,
  `token_hash` CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `proposito` ENUM('recuperacion_contrasena', 'verificacion_correo') NOT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_expiracion` DATETIME NOT NULL,
  `fecha_consumo` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_token`),
  UNIQUE KEY `uq_token_recuperacion_hash` (`token_hash`),
  KEY `idx_token_usuario_proposito` (`id_usuario`, `proposito`, `fecha_expiracion`),
  CONSTRAINT `chk_token_recuperacion_expiracion` CHECK (`fecha_expiracion` > `fecha_creacion`),
  CONSTRAINT `fk_token_recuperacion_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pregunta_secreta` (
  `id_pregunta_secreta` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `texto` VARCHAR(150) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_pregunta_secreta`),
  UNIQUE KEY `uq_pregunta_secreta_texto` (`texto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `usuario_pregunta_secreta` (
  `id_usuario` BIGINT UNSIGNED NOT NULL,
  `id_pregunta_secreta` SMALLINT UNSIGNED NOT NULL,
  `respuesta_hash` VARCHAR(255) NOT NULL,
  `intentos_fallidos` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `bloqueado_hasta` DATETIME DEFAULT NULL,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`, `id_pregunta_secreta`),
  KEY `idx_ups_pregunta` (`id_pregunta_secreta`),
  CONSTRAINT `fk_ups_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ups_pregunta`
    FOREIGN KEY (`id_pregunta_secreta`) REFERENCES `pregunta_secreta` (`id_pregunta_secreta`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `notificacion` (
  `id_notificacion` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario` BIGINT UNSIGNED NOT NULL,
  `id_cita` BIGINT UNSIGNED DEFAULT NULL,
  `tipo` VARCHAR(60) NOT NULL,
  `canal` ENUM('interno', 'correo', 'push', 'sms') NOT NULL DEFAULT 'interno',
  `estado_envio` ENUM('pendiente', 'enviada', 'fallida') NOT NULL DEFAULT 'pendiente',
  `titulo` VARCHAR(160) NOT NULL,
  `mensaje` TEXT DEFAULT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_envio` DATETIME DEFAULT NULL,
  `fecha_lectura` DATETIME DEFAULT NULL,
  `codigo_error` VARCHAR(80) DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_notificacion_usuario_lectura` (`id_usuario`, `fecha_lectura`, `fecha_creacion`),
  KEY `idx_notificacion_estado_fecha` (`estado_envio`, `fecha_creacion`),
  CONSTRAINT `fk_notificacion_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_notificacion_cita`
    FOREIGN KEY (`id_cita`) REFERENCES `cita` (`id_cita`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `auditoria` (
  `id_auditoria` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario` BIGINT UNSIGNED DEFAULT NULL,
  `modulo` VARCHAR(60) NOT NULL,
  `accion` VARCHAR(80) NOT NULL,
  `entidad` VARCHAR(80) DEFAULT NULL,
  `id_registro` VARCHAR(80) DEFAULT NULL,
  `resultado` ENUM('correcto', 'rechazado', 'error') NOT NULL,
  `observacion` VARCHAR(500) DEFAULT NULL,
  `fecha_evento` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_usuario_fecha` (`id_usuario`, `fecha_evento`),
  KEY `idx_auditoria_entidad_registro` (`entidad`, `id_registro`, `fecha_evento`),
  KEY `idx_auditoria_modulo_fecha` (`modulo`, `fecha_evento`),
  CONSTRAINT `fk_auditoria_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 7. PORTAL WEB PUBLICO E INSTITUCIONAL
-- =====================================================================

CREATE TABLE IF NOT EXISTS `centro_medico` (
  `id_centro` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `nombre` VARCHAR(150) NOT NULL,
  `direccion` VARCHAR(255) DEFAULT NULL,
  `telefono` VARCHAR(25) DEFAULT NULL,
  `correo` VARCHAR(254) DEFAULT NULL,
  `horario` VARCHAR(255) DEFAULT NULL,
  `mision` TEXT DEFAULT NULL,
  `vision` TEXT DEFAULT NULL,
  `valores` TEXT DEFAULT NULL,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_centro`),
  CONSTRAINT `chk_centro_unico` CHECK (`id_centro` = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `hero_slide` (
  `id_slide` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(60) NOT NULL,
  `texto` VARCHAR(160) NOT NULL,
  `boton_texto` VARCHAR(24) DEFAULT NULL,
  `enlace` VARCHAR(255) DEFAULT NULL,
  `imagen_ruta` VARCHAR(255) DEFAULT NULL,
  `color_fondo` CHAR(7) DEFAULT NULL,
  `orden` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_slide`),
  KEY `idx_hero_orden` (`activo`, `orden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `resena` (
  `id_resena` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_paciente` BIGINT UNSIGNED DEFAULT NULL,
  `nombre_autor` VARCHAR(100) NOT NULL,
  `estrellas` TINYINT UNSIGNED NOT NULL,
  `texto` VARCHAR(500) NOT NULL,
  `publicada` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_resena`),
  KEY `idx_resena_publicada` (`publicada`, `fecha_registro`),
  CONSTRAINT `chk_resena_estrellas` CHECK (`estrellas` BETWEEN 1 AND 5),
  CONSTRAINT `fk_resena_paciente`
    FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pregunta_frecuente` (
  `id_pregunta_frecuente` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pregunta` VARCHAR(200) NOT NULL,
  `respuesta` TEXT NOT NULL,
  `orden` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_pregunta_frecuente`),
  KEY `idx_faq_orden` (`activo`, `orden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `contenido_informativo` (
  `id_contenido` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(160) NOT NULL,
  `tipo` ENUM('consejo', 'noticia', 'aviso') NOT NULL DEFAULT 'consejo',
  `titulo` VARCHAR(200) NOT NULL,
  `resumen` VARCHAR(300) DEFAULT NULL,
  `cuerpo` MEDIUMTEXT NOT NULL,
  `estado` ENUM('borrador', 'publicado', 'archivado') NOT NULL DEFAULT 'borrador',
  `id_usuario_autor` BIGINT UNSIGNED DEFAULT NULL,
  `fecha_publicacion` DATETIME DEFAULT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_contenido`),
  UNIQUE KEY `uq_contenido_slug` (`slug`),
  KEY `idx_contenido_estado_publicacion` (`estado`, `fecha_publicacion`),
  KEY `idx_contenido_tipo_estado` (`tipo`, `estado`, `fecha_publicacion`),
  CONSTRAINT `fk_contenido_autor`
    FOREIGN KEY (`id_usuario_autor`) REFERENCES `usuario` (`id_usuario`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 8. CARGA INICIAL DE CATALOGOS ESTRUCTURALES Y SEMILLAS
-- =====================================================================

INSERT INTO `rol` (`id_rol`, `nombre`, `descripcion`) VALUES
  (1, 'administrador', 'Gestion administrativa y configuracion autorizada del sistema'),
  (2, 'asistente', 'Gestion de pacientes y citas desde la aplicacion web'),
  (3, 'medico', 'Consulta de agenda y gestion autorizada de atenciones'),
  (4, 'paciente', 'Consulta y gestion de sus propias citas desde la aplicacion movil')
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`);

INSERT INTO `centro_medico` (`id_centro`, `nombre`, `direccion`, `telefono`, `correo`, `horario`) VALUES
  (1, 'Centro Medico Sagrado Corazon', 'Av. Juarez No. 12, Pachuca, Hidalgo', '7710000000', 'contacto@centromedicosagradocorazon.com', 'Lunes a Viernes 08:00 - 20:00')
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`);

INSERT INTO `pregunta_secreta` (`id_pregunta_secreta`, `texto`, `activo`) VALUES
  (1, '¿Cual es el nombre de tu primera mascota?', 1),
  (2, '¿En que ciudad nacio tu madre?', 1),
  (3, '¿Cual fue tu escuela primaria?', 1),
  (4, '¿Cual es tu comida favorita?', 1),
  (5, '¿Cual es el nombre de tu mejor amigo de la infancia?', 1),
  (6, '¿Cual fue tu primer trabajo?', 1)
ON DUPLICATE KEY UPDATE `texto` = VALUES(`texto`);

-- 84 Municipios del Estado de Hidalgo (procedentes de la version de escritorio)
INSERT INTO `municipio` (`id_municipio`, `nombre`, `estado`, `codigo_postal`) VALUES
  (1, 'Acatlan', 'Hidalgo', NULL),
  (2, 'Acaxochitlan', 'Hidalgo', NULL),
  (3, 'Actopan', 'Hidalgo', '42300'),
  (4, 'Agua Blanca de Iturbide', 'Hidalgo', NULL),
  (5, 'Ajacuba', 'Hidalgo', '42340'),
  (6, 'Alfajayucan', 'Hidalgo', '42380'),
  (7, 'Almoloya', 'Hidalgo', '43950'),
  (8, 'Apan', 'Hidalgo', '43900'),
  (9, 'Atitalaquia', 'Hidalgo', '42970'),
  (10, 'Atlapexco', 'Hidalgo', '43000'),
  (11, 'Atotonilco el Grande', 'Hidalgo', '43300'),
  (12, 'Atotonilco de Tula', 'Hidalgo', '42980'),
  (13, 'Calnali', 'Hidalgo', '43230'),
  (14, 'Cardonal', 'Hidalgo', '42370'),
  (15, 'Chapantongo', 'Hidalgo', '42920'),
  (16, 'Chapulhuacan', 'Hidalgo', '42290'),
  (17, 'Chilcuautla', 'Hidalgo', '42750'),
  (18, 'Cuautepec de Hinojosa', 'Hidalgo', '43740'),
  (19, 'El Arenal', 'Hidalgo', '42680'),
  (20, 'Eloxochitlan', 'Hidalgo', '43320'),
  (21, 'Emiliano Zapata', 'Hidalgo', '43960'),
  (22, 'Epazoyucan', 'Hidalgo', '43580'),
  (23, 'Francisco I. Madero', 'Hidalgo', '42660'),
  (24, 'Huasca de Ocampo', 'Hidalgo', '43500'),
  (25, 'Huautla', 'Hidalgo', '43050'),
  (26, 'Huazalingo', 'Hidalgo', '43060'),
  (27, 'Huehuetla', 'Hidalgo', '43220'),
  (28, 'Huejutla de Reyes', 'Hidalgo', '43000'),
  (29, 'Huichapan', 'Hidalgo', '42400'),
  (30, 'Ixmiquilpan', 'Hidalgo', '42300'),
  (31, 'Jacala de Ledezma', 'Hidalgo', '42200'),
  (32, 'Jaltocan', 'Hidalgo', '43040'),
  (33, 'Juarez Hidalgo', 'Hidalgo', '43180'),
  (34, 'La Mision', 'Hidalgo', '42260'),
  (35, 'Lolotla', 'Hidalgo', '43140'),
  (36, 'Metepec', 'Hidalgo', '43400'),
  (37, 'Metztitlan', 'Hidalgo', '43350'),
  (38, 'Mineral de la Reforma', 'Hidalgo', '42180'),
  (39, 'Mineral del Chico', 'Hidalgo', '42120'),
  (40, 'Mineral del Monte', 'Hidalgo', '42130'),
  (41, 'Mixquiahuala de Juarez', 'Hidalgo', '42700'),
  (42, 'Molango de Escamilla', 'Hidalgo', '43160'),
  (43, 'Nicolas Flores', 'Hidalgo', '42360'),
  (44, 'Nopala de Villagran', 'Hidalgo', '42470'),
  (45, 'Omitlan de Juarez', 'Hidalgo', '42160'),
  (46, 'Orizatlan', 'Hidalgo', '43020'),
  (47, 'Pachuca de Soto', 'Hidalgo', '42000'),
  (48, 'Pacula', 'Hidalgo', '42230'),
  (49, 'Pisaflores', 'Hidalgo', '42220'),
  (50, 'Progreso de Obregon', 'Hidalgo', '42730'),
  (51, 'San Agustin Metzquititlan', 'Hidalgo', '43370'),
  (52, 'San Agustin Tlaxiaca', 'Hidalgo', '42160'),
  (53, 'San Bartolo Tutotepec', 'Hidalgo', '43420'),
  (54, 'San Felipe Orizatlan', 'Hidalgo', '43030'),
  (55, 'San Salvador', 'Hidalgo', '42640'),
  (56, 'Santiago de Anaya', 'Hidalgo', '42120'),
  (57, 'Singuilucan', 'Hidalgo', '42190'),
  (58, 'Tasquillo', 'Hidalgo', '42360'),
  (59, 'Tecozautla', 'Hidalgo', '42440'),
  (60, 'Tenango de Doria', 'Hidalgo', '42120'),
  (61, 'Tepeapulco', 'Hidalgo', '42120'),
  (62, 'Tepehuacan de Guerrero', 'Hidalgo', '43130'),
  (63, 'Tepeji del Rio de Ocampo', 'Hidalgo', '42850'),
  (64, 'Tepetitlan', 'Hidalgo', '42900'),
  (65, 'Tetepango', 'Hidalgo', '42940'),
  (66, 'Tezontepec de Aldama', 'Hidalgo', '42760'),
  (67, 'Tianguistengo', 'Hidalgo', '43200'),
  (68, 'Tizayuca', 'Hidalgo', '43800'),
  (69, 'Tlahuelilpan', 'Hidalgo', '42780'),
  (70, 'Tlahuiltepa', 'Hidalgo', '43170'),
  (71, 'Tlanalapa', 'Hidalgo', '43970'),
  (72, 'Tlanchinol', 'Hidalgo', '43150'),
  (73, 'Tlaxcoapan', 'Hidalgo', '42960'),
  (74, 'Tolcayuca', 'Hidalgo', '43860'),
  (75, 'Tula de Allende', 'Hidalgo', '42800'),
  (76, 'Tulancingo de Bravo', 'Hidalgo', '43600'),
  (77, 'Villa de Tezontepec', 'Hidalgo', '43980'),
  (78, 'Xochiatipan', 'Hidalgo', '43090'),
  (79, 'Xochicoatlan', 'Hidalgo', '43250'),
  (80, 'Yahualica', 'Hidalgo', '43080'),
  (81, 'Zacualtipan de Angeles', 'Hidalgo', '43260'),
  (82, 'Zapotlan de Juarez', 'Hidalgo', '42140'),
  (83, 'Zempoala', 'Hidalgo', '43830'),
  (84, 'Zimapan', 'Hidalgo', '42330')
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`);
