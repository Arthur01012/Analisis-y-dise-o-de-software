-- MedicDate: esquema base para la ampliacion multiplataforma
-- Compatible con MariaDB 11.4 / MySQL 8.0.16 o posterior.
-- Es un esquema nuevo e independiente: no elimina tablas ni migra datos existentes.
-- NO es compatible directamente con el cliente WinForms version1: sus consultas usan
-- el esquema innegone_bd_medic y tablas/columnas distintas. No cambiar la conexion
-- del cliente a este esquema sin una migracion probada. La arquitectura objetivo
-- requiere que React, Android y WinForms consuman exclusivamente las APIs Laravel;
-- ningun cliente debe conectarse directamente a MariaDB.
-- Ejecutar solo en una instancia donde se autorice crear medicdate_multiplataforma.

CREATE DATABASE IF NOT EXISTS medicdate_multiplataforma
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE medicdate_multiplataforma;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE persona (
  id_persona BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombres VARCHAR(100) NOT NULL,
  apellido_paterno VARCHAR(80) NOT NULL,
  apellido_materno VARCHAR(80) DEFAULT NULL,
  fecha_nacimiento DATE DEFAULT NULL,
  correo_contacto VARCHAR(254) DEFAULT NULL,
  telefono_principal VARCHAR(25) DEFAULT NULL,
  telefono_secundario VARCHAR(25) DEFAULT NULL,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_persona),
  KEY idx_persona_nombre (apellido_paterno, apellido_materno, nombres),
  KEY idx_persona_correo_contacto (correo_contacto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol (
  id_rol SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(40) NOT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id_rol),
  UNIQUE KEY uq_rol_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permiso (
  id_permiso SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(80) NOT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id_permiso),
  UNIQUE KEY uq_permiso_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol_permiso (
  id_rol SMALLINT UNSIGNED NOT NULL,
  id_permiso SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (id_rol, id_permiso),
  KEY idx_rol_permiso_permiso (id_permiso),
  CONSTRAINT fk_rol_permiso_rol
    FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rol_permiso_permiso
    FOREIGN KEY (id_permiso) REFERENCES permiso (id_permiso)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuario (
  id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_persona BIGINT UNSIGNED NOT NULL,
  correo_acceso VARCHAR(254) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  estado ENUM('activa', 'inactiva', 'bloqueada') NOT NULL DEFAULT 'activa',
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  ultimo_acceso DATETIME DEFAULT NULL,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuario_persona (id_persona),
  UNIQUE KEY uq_usuario_correo_acceso (correo_acceso),
  KEY idx_usuario_estado (estado),
  CONSTRAINT fk_usuario_persona
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuario_rol (
  id_usuario BIGINT UNSIGNED NOT NULL,
  id_rol SMALLINT UNSIGNED NOT NULL,
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_rol),
  KEY idx_usuario_rol_rol (id_rol),
  CONSTRAINT fk_usuario_rol_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_usuario_rol_rol
    FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE paciente (
  id_paciente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_persona BIGINT UNSIGNED NOT NULL,
  alergias TEXT DEFAULT NULL,
  notas_medicas TEXT DEFAULT NULL,
  estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_paciente),
  UNIQUE KEY uq_paciente_persona (id_persona),
  KEY idx_paciente_estado (estado),
  CONSTRAINT fk_paciente_persona
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE empleado (
  id_empleado BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_persona BIGINT UNSIGNED NOT NULL,
  curp CHAR(18) DEFAULT NULL,
  fecha_contratacion DATE DEFAULT NULL,
  estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_empleado),
  UNIQUE KEY uq_empleado_persona (id_persona),
  UNIQUE KEY uq_empleado_curp (curp),
  KEY idx_empleado_estado (estado),
  CONSTRAINT fk_empleado_persona
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE asistente (
  id_empleado BIGINT UNSIGNED NOT NULL,
  turno VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (id_empleado),
  CONSTRAINT fk_asistente_empleado
    FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE doctor (
  id_empleado BIGINT UNSIGNED NOT NULL,
  cedula_profesional VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_empleado),
  UNIQUE KEY uq_doctor_cedula_profesional (cedula_profesional),
  CONSTRAINT fk_doctor_empleado
    FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE especialidad (
  id_especialidad INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT DEFAULT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_especialidad),
  UNIQUE KEY uq_especialidad_nombre (nombre),
  KEY idx_especialidad_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE doctor_especialidad (
  id_empleado BIGINT UNSIGNED NOT NULL,
  id_especialidad INT UNSIGNED NOT NULL,
  PRIMARY KEY (id_empleado, id_especialidad),
  KEY idx_doctor_especialidad_especialidad (id_especialidad),
  CONSTRAINT fk_doctor_especialidad_doctor
    FOREIGN KEY (id_empleado) REFERENCES doctor (id_empleado)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_doctor_especialidad_especialidad
    FOREIGN KEY (id_especialidad) REFERENCES especialidad (id_especialidad)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE consultorio (
  id_consultorio INT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(100) DEFAULT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_consultorio),
  UNIQUE KEY uq_consultorio_codigo (codigo),
  KEY idx_consultorio_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tipo_atencion (
  id_tipo_atencion INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_especialidad INT UNSIGNED DEFAULT NULL,
  nombre VARCHAR(120) NOT NULL,
  descripcion TEXT DEFAULT NULL,
  duracion_minutos SMALLINT UNSIGNED NOT NULL,
  costo_base DECIMAL(10,2) DEFAULT NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'MXN',
  activo TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_tipo_atencion),
  UNIQUE KEY uq_tipo_atencion_nombre_especialidad (nombre, id_especialidad),
  KEY idx_tipo_atencion_especialidad (id_especialidad),
  KEY idx_tipo_atencion_activo (activo),
  CONSTRAINT chk_tipo_atencion_duracion CHECK (duracion_minutos > 0),
  CONSTRAINT chk_tipo_atencion_costo CHECK (costo_base IS NULL OR costo_base >= 0),
  CONSTRAINT fk_tipo_atencion_especialidad
    FOREIGN KEY (id_especialidad) REFERENCES especialidad (id_especialidad)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE horario_atencion (
  id_horario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_empleado BIGINT UNSIGNED NOT NULL,
  id_consultorio INT UNSIGNED DEFAULT NULL,
  dia_semana TINYINT UNSIGNED NOT NULL COMMENT 'ISO-8601: lunes=1 ... domingo=7',
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  intervalo_minutos SMALLINT UNSIGNED NOT NULL DEFAULT 30,
  vigencia_desde DATE NOT NULL,
  vigencia_hasta DATE DEFAULT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_horario),
  KEY idx_horario_doctor_dia (id_empleado, dia_semana, activo),
  KEY idx_horario_consultorio_dia (id_consultorio, dia_semana, activo),
  CONSTRAINT chk_horario_dia CHECK (dia_semana BETWEEN 1 AND 7),
  CONSTRAINT chk_horario_horas CHECK (hora_fin > hora_inicio),
  CONSTRAINT chk_horario_intervalo CHECK (intervalo_minutos > 0),
  CONSTRAINT chk_horario_vigencia CHECK (vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde),
  CONSTRAINT fk_horario_doctor
    FOREIGN KEY (id_empleado) REFERENCES doctor (id_empleado)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_horario_consultorio
    FOREIGN KEY (id_consultorio) REFERENCES consultorio (id_consultorio)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE bloqueo_horario (
  id_bloqueo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_empleado BIGINT UNSIGNED NOT NULL,
  id_consultorio INT UNSIGNED DEFAULT NULL,
  inicio DATETIME NOT NULL,
  fin DATETIME NOT NULL,
  motivo VARCHAR(255) DEFAULT NULL,
  id_usuario_registro BIGINT UNSIGNED NOT NULL,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_bloqueo),
  KEY idx_bloqueo_doctor_intervalo (id_empleado, inicio, fin),
  KEY idx_bloqueo_consultorio_intervalo (id_consultorio, inicio, fin),
  CONSTRAINT chk_bloqueo_intervalo CHECK (fin > inicio),
  CONSTRAINT fk_bloqueo_doctor
    FOREIGN KEY (id_empleado) REFERENCES doctor (id_empleado)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_bloqueo_consultorio
    FOREIGN KEY (id_consultorio) REFERENCES consultorio (id_consultorio)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_bloqueo_usuario
    FOREIGN KEY (id_usuario_registro) REFERENCES usuario (id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cita (
  id_cita BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_paciente BIGINT UNSIGNED NOT NULL,
  id_empleado BIGINT UNSIGNED NOT NULL,
  id_consultorio INT UNSIGNED DEFAULT NULL,
  id_tipo_atencion INT UNSIGNED NOT NULL,
  inicio DATETIME NOT NULL,
  fin DATETIME NOT NULL,
  estado ENUM('pendiente', 'confirmada', 'en_progreso', 'completada', 'cancelada', 'inasistencia')
    NOT NULL DEFAULT 'pendiente',
  motivo VARCHAR(500) DEFAULT NULL,
  notas_internas TEXT DEFAULT NULL,
  costo DECIMAL(10,2) DEFAULT NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'MXN',
  id_usuario_registro BIGINT UNSIGNED NOT NULL,
  id_usuario_cancelacion BIGINT UNSIGNED DEFAULT NULL,
  motivo_cancelacion VARCHAR(500) DEFAULT NULL,
  fecha_cancelacion DATETIME DEFAULT NULL,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_cita),
  KEY idx_cita_doctor_intervalo (id_empleado, inicio, fin),
  KEY idx_cita_consultorio_intervalo (id_consultorio, inicio, fin),
  KEY idx_cita_paciente_inicio (id_paciente, inicio),
  KEY idx_cita_estado_inicio (estado, inicio),
  CONSTRAINT chk_cita_intervalo CHECK (fin > inicio),
  CONSTRAINT chk_cita_costo CHECK (costo IS NULL OR costo >= 0),
  CONSTRAINT chk_cita_cancelacion CHECK (
    (estado = 'cancelada' AND fecha_cancelacion IS NOT NULL)
    OR (estado <> 'cancelada' AND fecha_cancelacion IS NULL)
  ),
  CONSTRAINT fk_cita_paciente
    FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_doctor
    FOREIGN KEY (id_empleado) REFERENCES doctor (id_empleado)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_consultorio
    FOREIGN KEY (id_consultorio) REFERENCES consultorio (id_consultorio)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_tipo_atencion
    FOREIGN KEY (id_tipo_atencion) REFERENCES tipo_atencion (id_tipo_atencion)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_usuario_registro
    FOREIGN KEY (id_usuario_registro) REFERENCES usuario (id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_usuario_cancelacion
    FOREIGN KEY (id_usuario_cancelacion) REFERENCES usuario (id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE historial_cita (
  id_historial BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cita BIGINT UNSIGNED NOT NULL,
  id_usuario BIGINT UNSIGNED DEFAULT NULL,
  estado_anterior ENUM('pendiente', 'confirmada', 'en_progreso', 'completada', 'cancelada', 'inasistencia')
    DEFAULT NULL,
  estado_nuevo ENUM('pendiente', 'confirmada', 'en_progreso', 'completada', 'cancelada', 'inasistencia')
    DEFAULT NULL,
  accion VARCHAR(60) NOT NULL,
  observacion VARCHAR(500) DEFAULT NULL,
  fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_historial),
  KEY idx_historial_cita_fecha (id_cita, fecha_evento),
  KEY idx_historial_usuario_fecha (id_usuario, fecha_evento),
  CONSTRAINT fk_historial_cita
    FOREIGN KEY (id_cita) REFERENCES cita (id_cita)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_historial_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sesion_usuario (
  id_sesion BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT UNSIGNED NOT NULL,
  token_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  plataforma ENUM('web', 'android', 'escritorio') NOT NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_expiracion DATETIME NOT NULL,
  fecha_revocacion DATETIME DEFAULT NULL,
  PRIMARY KEY (id_sesion),
  UNIQUE KEY uq_sesion_token_hash (token_hash),
  KEY idx_sesion_usuario_expiracion (id_usuario, fecha_expiracion),
  CONSTRAINT chk_sesion_expiracion CHECK (fecha_expiracion > fecha_creacion),
  CONSTRAINT fk_sesion_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE token_recuperacion (
  id_token BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT UNSIGNED NOT NULL,
  token_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  proposito ENUM('recuperacion_contrasena', 'verificacion_correo') NOT NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_expiracion DATETIME NOT NULL,
  fecha_consumo DATETIME DEFAULT NULL,
  PRIMARY KEY (id_token),
  UNIQUE KEY uq_token_recuperacion_hash (token_hash),
  KEY idx_token_usuario_proposito (id_usuario, proposito, fecha_expiracion),
  CONSTRAINT chk_token_recuperacion_expiracion CHECK (fecha_expiracion > fecha_creacion),
  CONSTRAINT fk_token_recuperacion_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notificacion (
  id_notificacion BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT UNSIGNED NOT NULL,
  id_cita BIGINT UNSIGNED DEFAULT NULL,
  tipo VARCHAR(60) NOT NULL,
  canal ENUM('interno', 'correo', 'push', 'sms') NOT NULL DEFAULT 'interno',
  estado_envio ENUM('pendiente', 'enviada', 'fallida') NOT NULL DEFAULT 'pendiente',
  titulo VARCHAR(160) NOT NULL,
  mensaje TEXT DEFAULT NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_envio DATETIME DEFAULT NULL,
  fecha_lectura DATETIME DEFAULT NULL,
  codigo_error VARCHAR(80) DEFAULT NULL,
  PRIMARY KEY (id_notificacion),
  KEY idx_notificacion_usuario_lectura (id_usuario, fecha_lectura, fecha_creacion),
  KEY idx_notificacion_estado_fecha (estado_envio, fecha_creacion),
  CONSTRAINT fk_notificacion_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_notificacion_cita
    FOREIGN KEY (id_cita) REFERENCES cita (id_cita)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE contenido_informativo (
  id_contenido BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  slug VARCHAR(160) NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  cuerpo MEDIUMTEXT NOT NULL,
  estado ENUM('borrador', 'publicado', 'archivado') NOT NULL DEFAULT 'borrador',
  id_usuario_autor BIGINT UNSIGNED DEFAULT NULL,
  fecha_publicacion DATETIME DEFAULT NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_contenido),
  UNIQUE KEY uq_contenido_slug (slug),
  KEY idx_contenido_estado_publicacion (estado, fecha_publicacion),
  CONSTRAINT fk_contenido_autor
    FOREIGN KEY (id_usuario_autor) REFERENCES usuario (id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE auditoria (
  id_auditoria BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT UNSIGNED DEFAULT NULL,
  modulo VARCHAR(60) NOT NULL,
  accion VARCHAR(80) NOT NULL,
  entidad VARCHAR(80) DEFAULT NULL,
  id_registro VARCHAR(80) DEFAULT NULL,
  resultado ENUM('correcto', 'rechazado', 'error') NOT NULL,
  observacion VARCHAR(500) DEFAULT NULL,
  fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_auditoria),
  KEY idx_auditoria_usuario_fecha (id_usuario, fecha_evento),
  KEY idx_auditoria_entidad_registro (entidad, id_registro, fecha_evento),
  KEY idx_auditoria_modulo_fecha (modulo, fecha_evento),
  CONSTRAINT fk_auditoria_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO rol (nombre, descripcion) VALUES
  ('administrador', 'Gestion administrativa y configuracion autorizada del sistema'),
  ('asistente', 'Gestion de pacientes y citas desde la aplicacion web'),
  ('medico', 'Consulta de agenda y gestion autorizada de atenciones'),
  ('paciente', 'Consulta y gestion de sus propias citas desde la aplicacion movil')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);
