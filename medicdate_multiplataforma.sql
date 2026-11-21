/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 11.4.13-MariaDB-cll-lve-log : Database - innegone_bd_medicdate
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`innegone_bd_medicdate` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;

USE `innegone_bd_medicdate`;

/*Table structure for table `asistente` */

DROP TABLE IF EXISTS `asistente`;

CREATE TABLE `asistente` (
  `id_empleado` bigint(20) unsigned NOT NULL,
  `turno` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  CONSTRAINT `fk_asistente_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `asistente` */

insert  into `asistente`(`id_empleado`,`turno`) values 
(2,'Matutino');

/*Table structure for table `auditoria` */

DROP TABLE IF EXISTS `auditoria`;

CREATE TABLE `auditoria` (
  `id_auditoria` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint(20) unsigned DEFAULT NULL,
  `modulo` varchar(60) NOT NULL,
  `accion` varchar(80) NOT NULL,
  `entidad` varchar(80) DEFAULT NULL,
  `id_registro` varchar(80) DEFAULT NULL,
  `resultado` enum('correcto','rechazado','error') NOT NULL,
  `observacion` varchar(500) DEFAULT NULL,
  `fecha_evento` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_usuario_fecha` (`id_usuario`,`fecha_evento`),
  KEY `idx_auditoria_entidad_registro` (`entidad`,`id_registro`,`fecha_evento`),
  KEY `idx_auditoria_modulo_fecha` (`modulo`,`fecha_evento`),
  CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `auditoria` */

insert  into `auditoria`(`id_auditoria`,`id_usuario`,`modulo`,`accion`,`entidad`,`id_registro`,`resultado`,`observacion`,`fecha_evento`) values 
(1,2,'citas','prueba_seed','cita','3','correcto','Cita semilla para probar disponibilidad móvil.','2026-11-17 22:14:03'),
(2,3,'citas','reservar','cita','4','correcto','Cita confirmada desde la aplicación.','2026-11-19 13:21:10');

/*Table structure for table `bloqueo_horario` */

DROP TABLE IF EXISTS `bloqueo_horario`;

CREATE TABLE `bloqueo_horario` (
  `id_bloqueo` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` bigint(20) unsigned NOT NULL,
  `id_consultorio` int(10) unsigned DEFAULT NULL,
  `inicio` datetime NOT NULL,
  `fin` datetime NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `id_usuario_registro` bigint(20) unsigned NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_bloqueo`),
  KEY `idx_bloqueo_doctor_intervalo` (`id_empleado`,`inicio`,`fin`),
  KEY `idx_bloqueo_consultorio_intervalo` (`id_consultorio`,`inicio`,`fin`),
  KEY `fk_bloqueo_usuario` (`id_usuario_registro`),
  CONSTRAINT `fk_bloqueo_consultorio` FOREIGN KEY (`id_consultorio`) REFERENCES `consultorio` (`id_consultorio`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_doctor` FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_usuario` FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE,
  CONSTRAINT `chk_bloqueo_intervalo` CHECK (`fin` > `inicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `bloqueo_horario` */

/*Table structure for table `cita` */

DROP TABLE IF EXISTS `cita`;

CREATE TABLE `cita` (
  `id_cita` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` bigint(20) unsigned NOT NULL,
  `id_empleado` bigint(20) unsigned DEFAULT NULL,
  `id_consultorio` int(10) unsigned DEFAULT NULL,
  `id_tipo_atencion` int(10) unsigned NOT NULL,
  `inicio` datetime NOT NULL,
  `fin` datetime NOT NULL,
  `estado` enum('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia') NOT NULL DEFAULT 'pendiente',
  `motivo` varchar(500) DEFAULT NULL,
  `notas_internas` text DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `moneda` char(3) NOT NULL DEFAULT 'MXN',
  `id_usuario_registro` bigint(20) unsigned NOT NULL,
  `id_usuario_cancelacion` bigint(20) unsigned DEFAULT NULL,
  `motivo_cancelacion` varchar(500) DEFAULT NULL,
  `fecha_cancelacion` datetime DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_cita`),
  KEY `idx_cita_doctor_intervalo` (`id_empleado`,`inicio`,`fin`),
  KEY `idx_cita_consultorio_intervalo` (`id_consultorio`,`inicio`,`fin`),
  KEY `idx_cita_paciente_inicio` (`id_paciente`,`inicio`),
  KEY `idx_cita_estado_inicio` (`estado`,`inicio`),
  KEY `fk_cita_tipo_atencion` (`id_tipo_atencion`),
  KEY `fk_cita_usuario_registro` (`id_usuario_registro`),
  KEY `fk_cita_usuario_cancelacion` (`id_usuario_cancelacion`),
  CONSTRAINT `fk_cita_consultorio` FOREIGN KEY (`id_consultorio`) REFERENCES `consultorio` (`id_consultorio`) ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_doctor` FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`) ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_tipo_atencion` FOREIGN KEY (`id_tipo_atencion`) REFERENCES `tipo_atencion` (`id_tipo_atencion`) ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_usuario_cancelacion` FOREIGN KEY (`id_usuario_cancelacion`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_usuario_registro` FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE,
  CONSTRAINT `chk_cita_intervalo` CHECK (`fin` > `inicio`),
  CONSTRAINT `chk_cita_costo` CHECK (`costo` is null or `costo` >= 0),
  CONSTRAINT `chk_cita_cancelacion` CHECK (`estado` = 'cancelada' and `fecha_cancelacion` is not null or `estado` <> 'cancelada' and `fecha_cancelacion` is null)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cita` */

insert  into `cita`(`id_cita`,`id_paciente`,`id_empleado`,`id_consultorio`,`id_tipo_atencion`,`inicio`,`fin`,`estado`,`motivo`,`notas_internas`,`costo`,`moneda`,`id_usuario_registro`,`id_usuario_cancelacion`,`motivo_cancelacion`,`fecha_cancelacion`,`fecha_registro`,`fecha_actualizacion`) values 
(1,1,1,1,1,'2026-11-17 23:00:00','2026-11-17 23:30:00','pendiente','Cita de prueba',NULL,0.00,'MXN',2,NULL,NULL,NULL,'2026-11-17 11:59:57','2026-11-17 11:59:57'),
(3,1,1,1,1,'2026-11-18 09:00:00','2026-11-18 09:30:00','pendiente','Cita de prueba',NULL,0.00,'MXN',2,NULL,NULL,NULL,'2026-11-17 22:14:03','2026-11-17 22:14:03'),
(4,1,1,1,1,'2026-11-20 09:00:00','2026-11-20 09:30:00','confirmada',NULL,NULL,0.00,'MXN',3,NULL,NULL,NULL,'2026-11-19 13:21:10','2026-11-19 13:21:10');

/*Table structure for table `consultorio` */

DROP TABLE IF EXISTS `consultorio`;

CREATE TABLE `consultorio` (
  `id_consultorio` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_consultorio`),
  UNIQUE KEY `uq_consultorio_codigo` (`codigo`),
  KEY `idx_consultorio_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `consultorio` */

insert  into `consultorio`(`id_consultorio`,`codigo`,`nombre`,`descripcion`,`activo`) values 
(1,'CONS-PRUEBA-01','Consultorio de prueba','Consultorio para datos de prueba',1);

/*Table structure for table `contenido_informativo` */

DROP TABLE IF EXISTS `contenido_informativo`;

CREATE TABLE `contenido_informativo` (
  `id_contenido` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(160) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `cuerpo` mediumtext NOT NULL,
  `estado` enum('borrador','publicado','archivado') NOT NULL DEFAULT 'borrador',
  `id_usuario_autor` bigint(20) unsigned DEFAULT NULL,
  `fecha_publicacion` datetime DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_contenido`),
  UNIQUE KEY `uq_contenido_slug` (`slug`),
  KEY `idx_contenido_estado_publicacion` (`estado`,`fecha_publicacion`),
  KEY `fk_contenido_autor` (`id_usuario_autor`),
  CONSTRAINT `fk_contenido_autor` FOREIGN KEY (`id_usuario_autor`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `contenido_informativo` */

/*Table structure for table `doctor` */

DROP TABLE IF EXISTS `doctor`;

CREATE TABLE `doctor` (
  `id_empleado` bigint(20) unsigned NOT NULL,
  `cedula_profesional` varchar(50) NOT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `uq_doctor_cedula_profesional` (`cedula_profesional`),
  CONSTRAINT `fk_doctor_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `doctor` */

insert  into `doctor`(`id_empleado`,`cedula_profesional`) values 
(1,'CED-PRUEBA-JMR-2026');

/*Table structure for table `doctor_especialidad` */

DROP TABLE IF EXISTS `doctor_especialidad`;

CREATE TABLE `doctor_especialidad` (
  `id_empleado` bigint(20) unsigned NOT NULL,
  `id_especialidad` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_empleado`,`id_especialidad`),
  KEY `idx_doctor_especialidad_especialidad` (`id_especialidad`),
  CONSTRAINT `fk_doctor_especialidad_doctor` FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`) ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_especialidad_especialidad` FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `doctor_especialidad` */

insert  into `doctor_especialidad`(`id_empleado`,`id_especialidad`) values 
(1,1);

/*Table structure for table `empleado` */

DROP TABLE IF EXISTS `empleado`;

CREATE TABLE `empleado` (
  `id_empleado` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` bigint(20) unsigned NOT NULL,
  `curp` char(18) DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL,
  `estado` enum('activo','inactivo') NOT NULL DEFAULT 'activo',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `uq_empleado_persona` (`id_persona`),
  UNIQUE KEY `uq_empleado_curp` (`curp`),
  KEY `idx_empleado_estado` (`estado`),
  CONSTRAINT `fk_empleado_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `empleado` */

insert  into `empleado`(`id_empleado`,`id_persona`,`curp`,`fecha_contratacion`,`estado`,`fecha_registro`) values 
(1,1,NULL,'2026-11-17','activo','2026-11-17 11:59:49'),
(2,2,NULL,'2026-11-17','activo','2026-11-17 11:59:49');

/*Table structure for table `especialidad` */

DROP TABLE IF EXISTS `especialidad`;

CREATE TABLE `especialidad` (
  `id_especialidad` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_especialidad`),
  UNIQUE KEY `uq_especialidad_nombre` (`nombre`),
  KEY `idx_especialidad_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `especialidad` */

insert  into `especialidad`(`id_especialidad`,`nombre`,`descripcion`,`activo`) values 
(1,'Medicina General - Prueba','Especialidad para datos de prueba',1);

/*Table structure for table `historial_cita` */

DROP TABLE IF EXISTS `historial_cita`;

CREATE TABLE `historial_cita` (
  `id_historial` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_cita` bigint(20) unsigned NOT NULL,
  `id_usuario` bigint(20) unsigned DEFAULT NULL,
  `estado_anterior` enum('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia') DEFAULT NULL,
  `estado_nuevo` enum('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia') DEFAULT NULL,
  `accion` varchar(60) NOT NULL,
  `observacion` varchar(500) DEFAULT NULL,
  `fecha_evento` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_historial`),
  KEY `idx_historial_cita_fecha` (`id_cita`,`fecha_evento`),
  KEY `idx_historial_usuario_fecha` (`id_usuario`,`fecha_evento`),
  CONSTRAINT `fk_historial_cita` FOREIGN KEY (`id_cita`) REFERENCES `cita` (`id_cita`) ON UPDATE CASCADE,
  CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `historial_cita` */

insert  into `historial_cita`(`id_historial`,`id_cita`,`id_usuario`,`estado_anterior`,`estado_nuevo`,`accion`,`observacion`,`fecha_evento`) values 
(1,1,2,NULL,'pendiente','creacion','Registro de cita de prueba','2026-11-17 11:59:58'),
(3,3,2,NULL,'pendiente','creacion','Registro de cita de prueba','2026-11-17 22:14:03'),
(4,4,3,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-19 13:21:10');

/*Table structure for table `horario_atencion` */

DROP TABLE IF EXISTS `horario_atencion`;

CREATE TABLE `horario_atencion` (
  `id_horario` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` bigint(20) unsigned NOT NULL,
  `id_consultorio` int(10) unsigned DEFAULT NULL,
  `dia_semana` tinyint(3) unsigned NOT NULL COMMENT 'ISO-8601: lunes=1 ... domingo=7',
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `intervalo_minutos` smallint(5) unsigned NOT NULL DEFAULT 30,
  `vigencia_desde` date NOT NULL,
  `vigencia_hasta` date DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_horario`),
  KEY `idx_horario_doctor_dia` (`id_empleado`,`dia_semana`,`activo`),
  KEY `idx_horario_consultorio_dia` (`id_consultorio`,`dia_semana`,`activo`),
  CONSTRAINT `fk_horario_consultorio` FOREIGN KEY (`id_consultorio`) REFERENCES `consultorio` (`id_consultorio`) ON UPDATE CASCADE,
  CONSTRAINT `fk_horario_doctor` FOREIGN KEY (`id_empleado`) REFERENCES `doctor` (`id_empleado`) ON UPDATE CASCADE,
  CONSTRAINT `chk_horario_dia` CHECK (`dia_semana` between 1 and 7),
  CONSTRAINT `chk_horario_horas` CHECK (`hora_fin` > `hora_inicio`),
  CONSTRAINT `chk_horario_intervalo` CHECK (`intervalo_minutos` > 0),
  CONSTRAINT `chk_horario_vigencia` CHECK (`vigencia_hasta` is null or `vigencia_hasta` >= `vigencia_desde`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `horario_atencion` */

insert  into `horario_atencion`(`id_horario`,`id_empleado`,`id_consultorio`,`dia_semana`,`hora_inicio`,`hora_fin`,`intervalo_minutos`,`vigencia_desde`,`vigencia_hasta`,`activo`) values 
(8,1,1,1,'09:00:00','17:00:00',30,'2026-11-17',NULL,1),
(9,1,1,2,'09:00:00','17:00:00',30,'2026-11-17',NULL,1),
(10,1,1,3,'09:00:00','17:00:00',30,'2026-11-17',NULL,1),
(11,1,1,4,'09:00:00','17:00:00',30,'2026-11-17',NULL,1),
(12,1,1,5,'09:00:00','17:00:00',30,'2026-11-17',NULL,1);

/*Table structure for table `notificacion` */

DROP TABLE IF EXISTS `notificacion`;

CREATE TABLE `notificacion` (
  `id_notificacion` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint(20) unsigned NOT NULL,
  `id_cita` bigint(20) unsigned DEFAULT NULL,
  `tipo` varchar(60) NOT NULL,
  `canal` enum('interno','correo','push','sms') NOT NULL DEFAULT 'interno',
  `estado_envio` enum('pendiente','enviada','fallida') NOT NULL DEFAULT 'pendiente',
  `titulo` varchar(160) NOT NULL,
  `mensaje` text DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_envio` datetime DEFAULT NULL,
  `fecha_lectura` datetime DEFAULT NULL,
  `codigo_error` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_notificacion_usuario_lectura` (`id_usuario`,`fecha_lectura`,`fecha_creacion`),
  KEY `idx_notificacion_estado_fecha` (`estado_envio`,`fecha_creacion`),
  KEY `fk_notificacion_cita` (`id_cita`),
  CONSTRAINT `fk_notificacion_cita` FOREIGN KEY (`id_cita`) REFERENCES `cita` (`id_cita`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notificacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `notificacion` */

insert  into `notificacion`(`id_notificacion`,`id_usuario`,`id_cita`,`tipo`,`canal`,`estado_envio`,`titulo`,`mensaje`,`fecha_creacion`,`fecha_envio`,`fecha_lectura`,`codigo_error`) values 
(2,2,3,'cita_confirmada','interno','pendiente','Cita de prueba','Cita de prueba para verificar horarios y confirmación.','2026-11-17 22:14:03',NULL,NULL,NULL),
(3,3,4,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de prueba con Jose Manuel Rodriguez quedó confirmada para 2026-11-20 a las 09:00 en Consultorio de prueba.','2026-11-19 13:21:10',NULL,NULL,NULL);

/*Table structure for table `paciente` */

DROP TABLE IF EXISTS `paciente`;

CREATE TABLE `paciente` (
  `id_paciente` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` bigint(20) unsigned NOT NULL,
  `alergias` text DEFAULT NULL,
  `notas_medicas` text DEFAULT NULL,
  `estado` enum('activo','inactivo') NOT NULL DEFAULT 'activo',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `uq_paciente_persona` (`id_persona`),
  KEY `idx_paciente_estado` (`estado`),
  CONSTRAINT `fk_paciente_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `paciente` */

insert  into `paciente`(`id_paciente`,`id_persona`,`alergias`,`notas_medicas`,`estado`,`fecha_registro`) values 
(1,3,NULL,NULL,'activo','2026-11-17 11:59:50'),
(2,4,NULL,NULL,'activo','2026-11-17 11:59:59'),
(3,5,NULL,NULL,'activo','2026-11-18 12:22:15'),
(4,6,NULL,NULL,'activo','2026-11-18 13:32:23'),
(5,7,NULL,NULL,'activo','2026-11-18 13:35:06'),
(6,8,NULL,NULL,'activo','2026-11-19 13:31:36');

/*Table structure for table `permiso` */

DROP TABLE IF EXISTS `permiso`;

CREATE TABLE `permiso` (
  `id_permiso` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(80) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE KEY `uq_permiso_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `permiso` */

/*Table structure for table `persona` */

DROP TABLE IF EXISTS `persona`;

CREATE TABLE `persona` (
  `id_persona` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) NOT NULL,
  `apellido_paterno` varchar(80) NOT NULL,
  `apellido_materno` varchar(80) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `correo_contacto` varchar(254) DEFAULT NULL,
  `telefono_principal` varchar(25) DEFAULT NULL,
  `telefono_secundario` varchar(25) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_persona`),
  KEY `idx_persona_nombre` (`apellido_paterno`,`apellido_materno`,`nombres`),
  KEY `idx_persona_correo_contacto` (`correo_contacto`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `persona` */

insert  into `persona`(`id_persona`,`nombres`,`apellido_paterno`,`apellido_materno`,`fecha_nacimiento`,`correo_contacto`,`telefono_principal`,`telefono_secundario`,`fecha_registro`,`fecha_actualizacion`) values 
(1,'Jose Manuel','Rodriguez',NULL,NULL,'jose.rodriguez.doc@example.test','5550000001',NULL,'2026-11-17 11:59:48','2026-11-17 11:59:48'),
(2,'Luna Aurora','Reyes',NULL,NULL,'luna.reyes.asistente@example.test','5550000002',NULL,'2026-11-17 11:59:48','2026-11-17 11:59:48'),
(3,'Paciente','de Prueba',NULL,NULL,'paciente.prueba@example.test','5550000003',NULL,'2026-11-17 11:59:49','2026-11-17 11:59:49'),
(4,'Ronaldo','Hernandez','Hernandez',NULL,'ronaldo@gmail.com','7711008968',NULL,'2026-11-17 11:59:57','2026-11-17 11:59:57'),
(5,'Juan','Perez','Lopez',NULL,'paciente.prueba@ejemplo.com','5512345678',NULL,'2026-11-18 12:22:15','2026-11-18 12:22:15'),
(6,'Juan','Pérez','García',NULL,'paciente@ejemplo.com','5512345678',NULL,'2026-11-18 13:32:23','2026-11-18 13:32:23'),
(7,'Gerardo','Hernandez','Hernandez',NULL,'gera@gmail.com','7712270032',NULL,'2026-11-18 13:35:05','2026-11-18 13:35:05'),
(8,'Monserrath','hernandez','Hernandez',NULL,'Monse@ejemplo.com','5512345748',NULL,'2026-11-19 13:31:36','2026-11-19 13:31:36');

/*Table structure for table `rol` */

DROP TABLE IF EXISTS `rol`;

CREATE TABLE `rol` (
  `id_rol` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `uq_rol_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `rol` */

insert  into `rol`(`id_rol`,`nombre`,`descripcion`) values 
(1,'administrador','Gestion administrativa y configuracion autorizada del sistema'),
(2,'asistente','Gestion de pacientes y citas desde la aplicacion web'),
(3,'medico','Consulta de agenda y gestion autorizada de atenciones'),
(4,'paciente','Consulta y gestion de sus propias citas desde la aplicacion movil');

/*Table structure for table `rol_permiso` */

DROP TABLE IF EXISTS `rol_permiso`;

CREATE TABLE `rol_permiso` (
  `id_rol` smallint(5) unsigned NOT NULL,
  `id_permiso` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id_rol`,`id_permiso`),
  KEY `idx_rol_permiso_permiso` (`id_permiso`),
  CONSTRAINT `fk_rol_permiso_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permiso` (`id_permiso`) ON UPDATE CASCADE,
  CONSTRAINT `fk_rol_permiso_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `rol_permiso` */

/*Table structure for table `sesion_usuario` */

DROP TABLE IF EXISTS `sesion_usuario`;

CREATE TABLE `sesion_usuario` (
  `id_sesion` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint(20) unsigned NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `plataforma` enum('web','android','escritorio') NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` datetime NOT NULL,
  `fecha_revocacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_sesion`),
  UNIQUE KEY `uq_sesion_token_hash` (`token_hash`),
  KEY `idx_sesion_usuario_expiracion` (`id_usuario`,`fecha_expiracion`),
  CONSTRAINT `fk_sesion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE,
  CONSTRAINT `chk_sesion_expiracion` CHECK (`fecha_expiracion` > `fecha_creacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `sesion_usuario` */

/*Table structure for table `tipo_atencion` */

DROP TABLE IF EXISTS `tipo_atencion`;

CREATE TABLE `tipo_atencion` (
  `id_tipo_atencion` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_especialidad` int(10) unsigned DEFAULT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `duracion_minutos` smallint(5) unsigned NOT NULL,
  `costo_base` decimal(10,2) DEFAULT NULL,
  `moneda` char(3) NOT NULL DEFAULT 'MXN',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_tipo_atencion`),
  UNIQUE KEY `uq_tipo_atencion_nombre_especialidad` (`nombre`,`id_especialidad`),
  KEY `idx_tipo_atencion_especialidad` (`id_especialidad`),
  KEY `idx_tipo_atencion_activo` (`activo`),
  CONSTRAINT `fk_tipo_atencion_especialidad` FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`) ON UPDATE CASCADE,
  CONSTRAINT `chk_tipo_atencion_duracion` CHECK (`duracion_minutos` > 0),
  CONSTRAINT `chk_tipo_atencion_costo` CHECK (`costo_base` is null or `costo_base` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tipo_atencion` */

insert  into `tipo_atencion`(`id_tipo_atencion`,`id_especialidad`,`nombre`,`descripcion`,`duracion_minutos`,`costo_base`,`moneda`,`activo`) values 
(1,1,'Consulta de prueba','Atencion para datos de prueba',30,0.00,'MXN',1);

/*Table structure for table `token_recuperacion` */

DROP TABLE IF EXISTS `token_recuperacion`;

CREATE TABLE `token_recuperacion` (
  `id_token` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint(20) unsigned NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `proposito` enum('recuperacion_contrasena','verificacion_correo') NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` datetime NOT NULL,
  `fecha_consumo` datetime DEFAULT NULL,
  PRIMARY KEY (`id_token`),
  UNIQUE KEY `uq_token_recuperacion_hash` (`token_hash`),
  KEY `idx_token_usuario_proposito` (`id_usuario`,`proposito`,`fecha_expiracion`),
  CONSTRAINT `fk_token_recuperacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE,
  CONSTRAINT `chk_token_recuperacion_expiracion` CHECK (`fecha_expiracion` > `fecha_creacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `token_recuperacion` */

/*Table structure for table `usuario` */

DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
  `id_usuario` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` bigint(20) unsigned NOT NULL,
  `correo_acceso` varchar(254) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `estado` enum('activa','inactiva','bloqueada') NOT NULL DEFAULT 'activa',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ultimo_acceso` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuario_persona` (`id_persona`),
  UNIQUE KEY `uq_usuario_correo_acceso` (`correo_acceso`),
  KEY `idx_usuario_estado` (`estado`),
  CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `usuario` */

insert  into `usuario`(`id_usuario`,`id_persona`,`correo_acceso`,`password_hash`,`estado`,`fecha_registro`,`fecha_actualizacion`,`ultimo_acceso`) values 
(1,1,'jose.rodriguez.doc@example.test','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa','2026-11-17 11:59:51','2026-11-17 11:59:51',NULL),
(2,2,'luna.reyes.asistente@example.test','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa','2026-11-17 11:59:51','2026-11-17 11:59:51',NULL),
(3,3,'paciente.prueba@example.test','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa','2026-11-17 11:59:51','2026-11-18 12:20:37',NULL),
(4,4,'ronaldo@gmail.com','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa','2026-11-17 11:59:59','2026-11-20 12:09:19','2026-11-20 12:09:19'),
(5,5,'paciente.prueba@ejemplo.com','$2y$12$SJ5CPLMAqcMBa0TGrf7s3uS3PE2mxPnaa0n2xSvRV4E9U0/VKaX.y','activa','2026-11-18 12:22:15','2026-11-18 12:22:44','2026-11-18 12:22:44'),
(6,6,'paciente@ejemplo.com','$2y$12$AGM3zU3GT2ZUzDivoaEq4OKLAw7WB8zt/39Rs/EOu3W5CYRc6.Vra','activa','2026-11-18 13:32:23','2026-11-18 13:32:23',NULL),
(7,7,'gera@gmail.com','$2y$12$XcDmd/nRemkiydgEgE.3QuQqZyyUAztqXlLiWTeGCr.b8lWHcKF2O','activa','2026-11-18 13:35:06','2026-11-19 13:16:16','2026-11-19 13:16:16'),
(8,8,'Monse@ejemplo.com','$2y$12$foNkShi/mK9hsdMGCXjVNuaKgXRiR8LkHxeU0dmdbW1GXYcTulhFK','activa','2026-11-19 13:31:36','2026-11-20 00:06:52','2026-11-20 00:06:52');

/*Table structure for table `usuario_rol` */

DROP TABLE IF EXISTS `usuario_rol`;

CREATE TABLE `usuario_rol` (
  `id_usuario` bigint(20) unsigned NOT NULL,
  `id_rol` smallint(5) unsigned NOT NULL,
  `fecha_asignacion` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`,`id_rol`),
  KEY `idx_usuario_rol_rol` (`id_rol`),
  CONSTRAINT `fk_usuario_rol_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario_rol_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `usuario_rol` */

insert  into `usuario_rol`(`id_usuario`,`id_rol`,`fecha_asignacion`) values 
(1,3,'2026-11-17 11:59:51'),
(2,2,'2026-11-17 11:59:51'),
(3,4,'2026-11-17 11:59:51'),
(4,4,'2026-11-17 11:59:59'),
(5,4,'2026-11-18 12:22:15'),
(6,4,'2026-11-18 13:32:23'),
(7,4,'2026-11-18 13:35:06'),
(8,4,'2026-11-19 13:31:36');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
