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
(4,'Matutino');

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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `auditoria` */

insert  into `auditoria`(`id_auditoria`,`id_usuario`,`modulo`,`accion`,`entidad`,`id_registro`,`resultado`,`observacion`,`fecha_evento`) values 
(1,1,'sistema','carga_semilla_funcional','varias','seed_v2.1','correcto','Inserción inicial de datos de prueba funcionales para pacientes y trabajadores.','2026-11-21 00:38:52'),
(2,9,'citas','reservar','cita','5','correcto','Cita confirmada desde la aplicación.','2026-11-21 23:04:32'),
(3,9,'citas','reservar','cita','6','correcto','Cita confirmada desde la aplicación.','2026-11-21 23:17:49'),
(4,9,'citas','reservar','cita','7','correcto','Cita confirmada desde la aplicación.','2026-11-21 23:18:22'),
(5,9,'citas','reservar','cita','8','correcto','Cita confirmada desde la aplicación.','2026-11-21 23:27:35'),
(6,9,'citas','reservar','cita','9','correcto','Cita confirmada desde la aplicación.','2026-11-21 23:40:06'),
(7,9,'citas','reservar','cita','10','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:04:57'),
(8,9,'citas','reservar','cita','11','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:21:18'),
(9,9,'citas','reservar','cita','12','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:21:53'),
(10,9,'citas','reservar','cita','13','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:29:22'),
(11,9,'citas','reservar','cita','14','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:33:34'),
(12,9,'citas','reservar','cita','15','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:59:00'),
(13,9,'citas','reservar','cita','16','correcto','Cita confirmada desde la aplicación.','2026-11-22 00:59:11'),
(14,2,'mi_agenda','actualizar_notas','cita','7','correcto','El médico actualizó las notas internas de la consulta.','2026-11-22 16:17:36'),
(15,2,'mi_agenda','actualizar_notas','cita','7','correcto','El médico actualizó las notas internas de la consulta.','2026-11-22 16:17:56'),
(16,2,'mi_agenda','marcar_atendida','cita','7','correcto','Cita marcada como atendida por el médico con notas clínicas.','2026-11-23 09:11:43'),
(17,9,'citas','reservar','cita','17','correcto','Cita confirmada desde la aplicación.','2026-11-24 12:05:23'),
(18,9,'citas','reservar','cita','18','correcto','Cita confirmada desde la aplicación.','2026-11-24 12:05:34'),
(19,9,'citas','reservar','cita','19','correcto','Cita confirmada desde la aplicación.','2026-11-24 12:07:22'),
(20,9,'citas','reservar','cita','20','correcto','Cita confirmada desde la aplicación.','2026-11-24 12:13:58'),
(21,9,'citas','reservar','cita','21','correcto','Cita confirmada desde la aplicación.','2026-11-24 21:15:28'),
(22,9,'citas','reservar','cita','22','correcto','Cita confirmada desde la aplicación.','2026-11-24 21:15:47'),
(23,5,'citas','reservar','cita','23','correcto','Cita confirmada desde la aplicación.','2026-11-25 11:24:04');

/*Table structure for table `aviso_legal` */

DROP TABLE IF EXISTS `aviso_legal`;

CREATE TABLE `aviso_legal` (
  `id_aviso` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `texto` text NOT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_aviso`),
  CONSTRAINT `chk_aviso_unico` CHECK (`id_aviso` = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `aviso_legal` */

insert  into `aviso_legal`(`id_aviso`,`texto`,`fecha_actualizacion`) values 
(1,'El Centro Médico Sagrado Corazón es responsable del tratamiento de tus datos personales.\r\n\r\nDatos que recabamos: nombre, correo, teléfono y los datos de salud necesarios para tu atención y\r\ntus citas.\r\n\r\nFinalidades: gestionar tus citas, integrar tu expediente y comunicarnos contigo sobre tu atención.\r\n\r\nDerechos ARCO: puedes acceder, rectificar, cancelar u oponerte al uso de tus datos acudiendo al\r\ncentro o llamando al 771 729 3074.\r\n\r\nCambios al aviso: cualquier modificación se publicará en esta página.','2026-11-22 17:48:52');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `bloqueo_horario` */

insert  into `bloqueo_horario`(`id_bloqueo`,`id_empleado`,`id_consultorio`,`inicio`,`fin`,`motivo`,`id_usuario_registro`,`fecha_registro`) values 
(1,2,1,'2026-12-05 13:00:00','2026-12-05 15:00:00','Capacitación médica continua',1,'2026-11-21 00:38:51');

/*Table structure for table `centro_medico` */

DROP TABLE IF EXISTS `centro_medico`;

CREATE TABLE `centro_medico` (
  `id_centro` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `nombre` varchar(150) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(25) DEFAULT NULL,
  `correo` varchar(254) DEFAULT NULL,
  `horario` varchar(255) DEFAULT NULL,
  `mision` text DEFAULT NULL,
  `vision` text DEFAULT NULL,
  `valores` text DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_centro`),
  CONSTRAINT `chk_centro_unico` CHECK (`id_centro` = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `centro_medico` */

insert  into `centro_medico`(`id_centro`,`nombre`,`direccion`,`telefono`,`correo`,`horario`,`mision`,`vision`,`valores`,`fecha_actualizacion`) values 
(1,'Centro Medico Sagrado Corazon','Av. Juarez No. 12, Pachuca, Hidalgo','7710000000','contacto@centromedicosagradocorazon.com','Lunes a Viernes 08:00 - 20:00',NULL,NULL,NULL,'2026-11-21 00:23:39');

/*Table structure for table `cita` */

DROP TABLE IF EXISTS `cita`;

CREATE TABLE `cita` (
  `id_cita` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` bigint(20) unsigned NOT NULL,
  `id_empleado` bigint(20) unsigned NOT NULL,
  `id_consultorio` int(10) unsigned DEFAULT NULL,
  `id_tipo_atencion` int(10) unsigned NOT NULL,
  `inicio` datetime NOT NULL,
  `fin` datetime NOT NULL,
  `estado` enum('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia') NOT NULL DEFAULT 'pendiente',
  `canal_registro` enum('movil','web','escritorio') NOT NULL DEFAULT 'movil',
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
  KEY `idx_cita_canal` (`canal_registro`),
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cita` */

insert  into `cita`(`id_cita`,`id_paciente`,`id_empleado`,`id_consultorio`,`id_tipo_atencion`,`inicio`,`fin`,`estado`,`canal_registro`,`motivo`,`notas_internas`,`costo`,`moneda`,`id_usuario_registro`,`id_usuario_cancelacion`,`motivo_cancelacion`,`fecha_cancelacion`,`fecha_registro`,`fecha_actualizacion`) values 
(1,1,2,1,1,'2026-11-23 09:30:00','2026-11-23 10:00:00','confirmada','movil','Dolor lumbar leve y revisión de análisis',NULL,350.00,'MXN',5,NULL,NULL,NULL,'2026-11-21 00:38:51','2026-11-21 00:38:51'),
(2,2,3,2,3,'2026-11-25 10:45:00','2026-11-25 11:30:00','confirmada','web','Chequeo cardiológico anual preventivo',NULL,750.00,'MXN',4,NULL,NULL,NULL,'2026-11-21 00:38:52','2026-11-21 00:38:52'),
(3,3,2,1,1,'2026-11-14 11:00:00','2026-11-14 11:30:00','completada','escritorio','Revisión de vías respiratorias',NULL,350.00,'MXN',1,NULL,NULL,NULL,'2026-11-21 00:38:52','2026-11-21 00:38:52'),
(4,2,2,1,2,'2026-11-23 14:00:00','2026-11-23 14:45:00','confirmada','movil','Cita reservada desde test API',NULL,350.00,'MXN',6,NULL,NULL,NULL,'2026-11-21 00:45:10','2026-11-21 00:45:10'),
(5,5,2,1,2,'2026-12-01 13:00:00','2026-12-01 13:45:00','confirmada','movil',NULL,NULL,500.00,'MXN',9,NULL,NULL,NULL,'2026-11-21 23:04:32','2026-11-21 23:04:32'),
(6,5,2,1,1,'2027-02-16 12:30:00','2027-02-16 13:00:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-21 23:17:49','2026-11-21 23:17:49'),
(7,5,2,1,1,'2026-11-23 09:00:00','2026-11-23 09:30:00','completada','movil',NULL,'joseeee',350.00,'MXN',9,NULL,NULL,NULL,'2026-11-21 23:18:22','2026-11-23 09:11:43'),
(8,5,2,1,1,'2026-11-23 10:00:00','2026-11-23 10:30:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-21 23:27:35','2026-11-21 23:27:35'),
(9,5,2,1,1,'2026-11-23 15:30:00','2026-11-23 16:00:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-21 23:40:06','2026-11-21 23:40:06'),
(10,5,2,1,1,'2026-11-23 10:30:00','2026-11-23 11:00:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:04:57','2026-11-22 00:04:57'),
(11,5,3,2,1,'2026-11-25 16:30:00','2026-11-25 17:00:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:21:18','2026-11-22 00:21:18'),
(12,5,2,1,2,'2026-11-23 16:30:00','2026-11-23 17:00:00','confirmada','movil',NULL,NULL,500.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:21:53','2026-11-22 00:21:53'),
(13,5,2,1,2,'2026-11-23 16:00:00','2026-11-23 16:30:00','confirmada','movil',NULL,NULL,500.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:29:22','2026-11-22 00:29:22'),
(14,5,2,1,1,'2026-11-23 11:00:00','2026-11-23 11:30:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:33:34','2026-11-22 00:33:34'),
(15,5,2,1,1,'2026-11-23 15:00:00','2026-11-23 15:30:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:59:00','2026-11-22 00:59:00'),
(16,5,2,1,2,'2026-11-23 13:30:00','2026-11-23 14:00:00','confirmada','movil',NULL,NULL,500.00,'MXN',9,NULL,NULL,NULL,'2026-11-22 00:59:11','2026-11-22 00:59:11'),
(17,5,3,2,1,'2026-11-25 17:30:00','2026-11-25 18:00:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-24 12:05:23','2026-11-24 12:05:23'),
(18,5,2,1,1,'2026-11-25 09:00:00','2026-11-25 09:30:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-24 12:05:34','2026-11-24 12:05:34'),
(19,5,3,2,2,'2026-11-25 10:00:00','2026-11-25 10:30:00','confirmada','movil',NULL,NULL,500.00,'MXN',9,NULL,NULL,NULL,'2026-11-24 12:07:22','2026-11-24 12:07:22'),
(20,5,3,2,2,'2026-11-25 11:30:00','2026-11-25 12:00:00','confirmada','movil',NULL,NULL,500.00,'MXN',9,NULL,NULL,NULL,'2026-11-24 12:13:57','2026-11-24 12:13:57'),
(21,5,2,1,1,'2026-11-25 09:30:00','2026-11-25 10:00:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-24 21:15:28','2026-11-24 21:15:28'),
(22,5,2,1,1,'2026-11-25 16:00:00','2026-11-25 16:30:00','confirmada','movil',NULL,NULL,350.00,'MXN',9,NULL,NULL,NULL,'2026-11-24 21:15:47','2026-11-24 21:15:47'),
(23,1,2,1,1,'2026-11-26 09:00:00','2026-11-26 09:30:00','confirmada','movil',NULL,NULL,350.00,'MXN',5,NULL,NULL,NULL,'2026-11-25 11:24:04','2026-11-25 11:24:04');

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
(1,'CONS-101','Consultorio 101 - Medicina Familiar','Planta Baja, equipado para atención primaria.',1),
(2,'CONS-102','Consultorio 102 - Cardiología','Primer Piso, incluye electrocardiógrafo digital.',1),
(3,'CONS-103','Consultorio 103 - Pediatría','Planta Baja, área ambientada para infantes.',1),
(4,'CONS-104','Consultorio 104 - Dermatología','Primer Piso, instrumental dermatológico completo.',1);

/*Table structure for table `contenido_informativo` */

DROP TABLE IF EXISTS `contenido_informativo`;

CREATE TABLE `contenido_informativo` (
  `id_contenido` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(160) NOT NULL,
  `tipo` enum('consejo','noticia','aviso') NOT NULL DEFAULT 'consejo',
  `titulo` varchar(200) NOT NULL,
  `resumen` varchar(300) DEFAULT NULL,
  `cuerpo` mediumtext NOT NULL,
  `estado` enum('borrador','publicado','archivado') NOT NULL DEFAULT 'borrador',
  `id_usuario_autor` bigint(20) unsigned DEFAULT NULL,
  `fecha_publicacion` datetime DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_contenido`),
  UNIQUE KEY `uq_contenido_slug` (`slug`),
  KEY `idx_contenido_estado_publicacion` (`estado`,`fecha_publicacion`),
  KEY `idx_contenido_tipo_estado` (`tipo`,`estado`,`fecha_publicacion`),
  KEY `fk_contenido_autor` (`id_usuario_autor`),
  CONSTRAINT `fk_contenido_autor` FOREIGN KEY (`id_usuario_autor`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `contenido_informativo` */

insert  into `contenido_informativo`(`id_contenido`,`slug`,`tipo`,`titulo`,`resumen`,`cuerpo`,`estado`,`id_usuario_autor`,`fecha_publicacion`,`fecha_creacion`,`fecha_actualizacion`) values 
(1,'importancia-del-chequeo-medico-anual','consejo','La Importancia del Chequeo Médico Anual','Prevenir enfermedades crónicas mediante estudios periódicos de rutina.','El chequeo médico preventivo anual permite detectar oportunamente factores de riesgo como hipertensión arterial, diabetes mellitus y dislipidemias antes de que manifiesten complicaciones severas...','publicado',2,'2026-11-21 00:39:00','2026-11-21 00:38:52','2026-11-21 00:38:52'),
(2,'salud-cardiovascular-habitos-saludables','consejo','Hábitos para una Vida y Corazón Saludables','Recomendaciones clave de los cardiólogos para mantener un corazón fuerte.','Mantener una alimentación balanceada baja en sodio, realizar al menos 30 minutos de caminata diaria y evitar el tabaquismo son pilares fundamentales para la salud cardiovascular...','publicado',3,'2026-11-21 00:39:00','2026-11-21 00:38:52','2026-11-21 00:38:52'),
(3,'jornada-vacunacion-centro-sagrado-corazon','aviso','Próxima Jornada de Salud y Vacunación','Fechas y requisitos para la campaña de inmunización de temporada.','El Centro Médico Sagrado Corazón invita a la comunidad a participar en la jornada de salud infantil y preventiva durante este mes...','publicado',1,'2026-11-21 00:39:00','2026-11-21 00:38:52','2026-11-21 00:38:52'),
(4,'','consejo','',NULL,'','borrador',NULL,NULL,'2026-11-22 16:55:34','2026-11-22 16:55:34');

/*Table structure for table `direccion` */

DROP TABLE IF EXISTS `direccion`;

CREATE TABLE `direccion` (
  `id_direccion` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` bigint(20) unsigned NOT NULL,
  `calle` varchar(120) NOT NULL,
  `numero` varchar(30) DEFAULT NULL,
  `colonia` varchar(100) DEFAULT NULL,
  `localidad` varchar(100) DEFAULT NULL,
  `id_municipio` int(10) unsigned DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_direccion`),
  KEY `idx_direccion_persona` (`id_persona`),
  KEY `idx_direccion_municipio` (`id_municipio`),
  CONSTRAINT `fk_direccion_municipio` FOREIGN KEY (`id_municipio`) REFERENCES `municipio` (`id_municipio`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_direccion_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `direccion` */

insert  into `direccion`(`id_direccion`,`id_persona`,`calle`,`numero`,`colonia`,`localidad`,`id_municipio`,`codigo_postal`,`referencia`,`fecha_registro`,`fecha_actualizacion`) values 
(1,1,'Av. Revolución','105','Periodistas','Pachuca',47,'42060','Frente al parque Hidalgo','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(2,2,'Calle Benito Juárez','45','Centro','Pachuca',47,'42000','A media cuadra del Reloj','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(3,3,'Blvd. Colosio','1200','El Palmar','Pachuca',47,'42088','Torre Médica A','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(4,4,'Calle Hidalgo','23','La Joya','Mineral de la Reforma',38,'42180','Casa verde','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(5,5,'Calle 5 de Mayo','78','Centro','Tulancingo',76,'43600','Entre Morelos y Zaragoza','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(6,6,'Av. Nacional','12','San Miguel','Actopan',3,'42300','Junto a farmacia','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(7,7,'Calle Morelos','34','El Carmen','Tula de Allende',75,'42800','Frente a escuela primaria','2026-11-21 00:38:50','2026-11-21 00:38:50');

/*Table structure for table `doctor` */

DROP TABLE IF EXISTS `doctor`;

CREATE TABLE `doctor` (
  `id_empleado` bigint(20) unsigned NOT NULL,
  `cedula_profesional` varchar(50) NOT NULL,
  `descripcion_publica` text DEFAULT NULL,
  `foto_ruta` varchar(255) DEFAULT NULL,
  `publicado` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `uq_doctor_cedula_profesional` (`cedula_profesional`),
  CONSTRAINT `fk_doctor_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `doctor` */

insert  into `doctor`(`id_empleado`,`cedula_profesional`,`descripcion_publica`,`foto_ruta`,`publicado`) values 
(2,'CED-PRUEBA-JMR-2026','Médico General y Familiar con 12 años de trayectoria en medicina preventiva y salud comunitaria.','uploads/doctores/doc_rodriguez.jpg',1),
(3,'CED-PRUEBA-SFR-2026','Especialista en Cardiología Clínica egresada del Instituto Nacional de Cardiología.','uploads/doctores/doc_flores.jpg',1);

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
(2,1),
(3,2);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `empleado` */

insert  into `empleado`(`id_empleado`,`id_persona`,`curp`,`fecha_contratacion`,`estado`,`fecha_registro`) values 
(1,1,'VEMC850412HDFRRL01','2024-01-15','activo','2026-11-21 00:38:51'),
(2,2,'ROLJ800514HDFRPN02','2024-02-01','activo','2026-11-21 00:38:51'),
(3,3,'FLRS871025MDFRPN10','2024-03-01','activo','2026-11-21 00:38:51'),
(4,4,'REML950418MDFRPN11','2024-04-01','activo','2026-11-21 00:38:51');

/*Table structure for table `especialidad` */

DROP TABLE IF EXISTS `especialidad`;

CREATE TABLE `especialidad` (
  `id_especialidad` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `resumen` varchar(200) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_especialidad`),
  UNIQUE KEY `uq_especialidad_nombre` (`nombre`),
  KEY `idx_especialidad_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `especialidad` */

insert  into `especialidad`(`id_especialidad`,`nombre`,`resumen`,`descripcion`,`activo`) values 
(1,'Medicina General','Atención primaria, chequeos de salud y medicina familiar preventiva.','Especialidad dedicada al cuidado integral del paciente en todas las etapas.',1),
(2,'Cardiología','Evaluación, diagnóstico y control de patologías cardíacas e hipertensión.','Tratamiento avanzado de arritmias, insuficiencia cardíaca y riesgo cardiovascular.',1),
(3,'Pediatría','Cuidado integral y monitoreo del desarrollo infantil y del adolescente.','Control de niño sano, vacunación y seguimiento pediátrico.',1),
(4,'Dermatología','Diagnóstico y tratamiento de afecciones de piel, cabello y uñas.','Atención especializada de dermatitis, acné y control de lunares.',1),
(5,'wwww',NULL,'www222 | aaaaaa',0);

/*Table structure for table `hero_slide` */

DROP TABLE IF EXISTS `hero_slide`;

CREATE TABLE `hero_slide` (
  `id_slide` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(60) NOT NULL,
  `texto` varchar(160) NOT NULL,
  `boton_texto` varchar(24) DEFAULT NULL,
  `enlace` varchar(255) DEFAULT NULL,
  `imagen_ruta` varchar(255) DEFAULT NULL,
  `color_fondo` char(7) DEFAULT NULL,
  `orden` smallint(5) unsigned NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_slide`),
  KEY `idx_hero_orden` (`activo`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `hero_slide` */

insert  into `hero_slide`(`id_slide`,`titulo`,`texto`,`boton_texto`,`enlace`,`imagen_ruta`,`color_fondo`,`orden`,`activo`) values 
(1,'holaa','Atención médica integral con tecnología avanzada y especialistas certificados.','Agendar hola','/citas','img/hero/hero_1795629747.png','#2f2c63',1,1),
(2,'Agenda Médica en Línea','Programa tu cita desde tu teléfono móvil o computadora en minutos.','Ver Horarios','/horarios','img/hero/hero_1795602362.png','#155724',2,1),
(3,'Cardiología de Alta Precisión','Estudios preventivos de salud cardiovascular a tu alcance.','Conocer Más','/servicios','img/hero3.jpg','#721c24',3,1);

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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `historial_cita` */

insert  into `historial_cita`(`id_historial`,`id_cita`,`id_usuario`,`estado_anterior`,`estado_nuevo`,`accion`,`observacion`,`fecha_evento`) values 
(1,1,5,NULL,'confirmada','creacion','Cita registrada vía movil.','2026-11-21 00:38:51'),
(2,2,4,NULL,'confirmada','creacion','Cita registrada vía web.','2026-11-21 00:38:52'),
(3,3,1,NULL,'completada','creacion','Cita registrada vía escritorio.','2026-11-21 00:38:52'),
(4,4,6,NULL,'confirmada','creacion','Cita confirmada desde test automatizado de API.','2026-11-21 00:45:10'),
(5,5,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-21 23:04:32'),
(6,6,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-21 23:17:49'),
(7,7,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-21 23:18:22'),
(8,8,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-21 23:27:35'),
(9,9,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-21 23:40:06'),
(10,10,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:04:57'),
(11,11,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:21:18'),
(12,12,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:21:53'),
(13,13,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:29:22'),
(14,14,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:33:34'),
(15,15,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:59:00'),
(16,16,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-22 00:59:11'),
(17,7,2,'confirmada','confirmada','actualizar_notas','El médico actualizó las notas internas de la consulta.','2026-11-22 16:17:36'),
(18,7,2,'confirmada','confirmada','actualizar_notas','El médico actualizó las notas internas de la consulta.','2026-11-22 16:17:56'),
(19,7,2,'confirmada','completada','marcar_atendida','Cita marcada como atendida por el médico con notas clínicas.','2026-11-23 09:11:43'),
(20,17,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-24 12:05:23'),
(21,18,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-24 12:05:34'),
(22,19,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-24 12:07:22'),
(23,20,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-24 12:13:58'),
(24,21,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-24 21:15:28'),
(25,22,9,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-24 21:15:47'),
(26,23,5,NULL,'confirmada','creacion','Cita confirmada desde la aplicación.','2026-11-25 11:24:04');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `horario_atencion` */

insert  into `horario_atencion`(`id_horario`,`id_empleado`,`id_consultorio`,`dia_semana`,`hora_inicio`,`hora_fin`,`intervalo_minutos`,`vigencia_desde`,`vigencia_hasta`,`activo`) values 
(1,2,1,1,'09:00:00','17:00:00',30,'2026-11-21',NULL,1),
(2,2,1,2,'09:00:00','17:00:00',30,'2026-11-21',NULL,1),
(3,2,1,3,'09:00:00','17:00:00',30,'2026-11-21',NULL,1),
(4,2,1,4,'09:00:00','17:00:00',30,'2026-11-21',NULL,1),
(5,2,1,5,'09:00:00','17:00:00',30,'2026-11-21',NULL,1),
(6,3,2,1,'10:00:00','18:00:00',45,'2026-11-21',NULL,1),
(7,3,2,3,'10:00:00','18:00:00',45,'2026-11-21',NULL,1),
(8,3,2,5,'10:00:00','18:00:00',45,'2026-11-21',NULL,1);

/*Table structure for table `municipio` */

DROP TABLE IF EXISTS `municipio`;

CREATE TABLE `municipio` (
  `id_municipio` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `estado` varchar(50) NOT NULL DEFAULT 'Hidalgo',
  `codigo_postal` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_municipio`),
  KEY `idx_municipio_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `municipio` */

insert  into `municipio`(`id_municipio`,`nombre`,`estado`,`codigo_postal`) values 
(1,'Acatlan','Hidalgo',NULL),
(2,'Acaxochitlan','Hidalgo',NULL),
(3,'Actopan','Hidalgo','42300'),
(4,'Agua Blanca de Iturbide','Hidalgo',NULL),
(5,'Ajacuba','Hidalgo','42340'),
(6,'Alfajayucan','Hidalgo','42380'),
(7,'Almoloya','Hidalgo','43950'),
(8,'Apan','Hidalgo','43900'),
(9,'Atitalaquia','Hidalgo','42970'),
(10,'Atlapexco','Hidalgo','43000'),
(11,'Atotonilco el Grande','Hidalgo','43300'),
(12,'Atotonilco de Tula','Hidalgo','42980'),
(13,'Calnali','Hidalgo','43230'),
(14,'Cardonal','Hidalgo','42370'),
(15,'Chapantongo','Hidalgo','42920'),
(16,'Chapulhuacan','Hidalgo','42290'),
(17,'Chilcuautla','Hidalgo','42750'),
(18,'Cuautepec de Hinojosa','Hidalgo','43740'),
(19,'El Arenal','Hidalgo','42680'),
(20,'Eloxochitlan','Hidalgo','43320'),
(21,'Emiliano Zapata','Hidalgo','43960'),
(22,'Epazoyucan','Hidalgo','43580'),
(23,'Francisco I. Madero','Hidalgo','42660'),
(24,'Huasca de Ocampo','Hidalgo','43500'),
(25,'Huautla','Hidalgo','43050'),
(26,'Huazalingo','Hidalgo','43060'),
(27,'Huehuetla','Hidalgo','43220'),
(28,'Huejutla de Reyes','Hidalgo','43000'),
(29,'Huichapan','Hidalgo','42400'),
(30,'Ixmiquilpan','Hidalgo','42300'),
(31,'Jacala de Ledezma','Hidalgo','42200'),
(32,'Jaltocan','Hidalgo','43040'),
(33,'Juarez Hidalgo','Hidalgo','43180'),
(34,'La Mision','Hidalgo','42260'),
(35,'Lolotla','Hidalgo','43140'),
(36,'Metepec','Hidalgo','43400'),
(37,'Metztitlan','Hidalgo','43350'),
(38,'Mineral de la Reforma','Hidalgo','42180'),
(39,'Mineral del Chico','Hidalgo','42120'),
(40,'Mineral del Monte','Hidalgo','42130'),
(41,'Mixquiahuala de Juarez','Hidalgo','42700'),
(42,'Molango de Escamilla','Hidalgo','43160'),
(43,'Nicolas Flores','Hidalgo','42360'),
(44,'Nopala de Villagran','Hidalgo','42470'),
(45,'Omitlan de Juarez','Hidalgo','42160'),
(46,'Orizatlan','Hidalgo','43020'),
(47,'Pachuca de Soto','Hidalgo','42000'),
(48,'Pacula','Hidalgo','42230'),
(49,'Pisaflores','Hidalgo','42220'),
(50,'Progreso de Obregon','Hidalgo','42730'),
(51,'San Agustin Metzquititlan','Hidalgo','43370'),
(52,'San Agustin Tlaxiaca','Hidalgo','42160'),
(53,'San Bartolo Tutotepec','Hidalgo','43420'),
(54,'San Felipe Orizatlan','Hidalgo','43030'),
(55,'San Salvador','Hidalgo','42640'),
(56,'Santiago de Anaya','Hidalgo','42120'),
(57,'Singuilucan','Hidalgo','42190'),
(58,'Tasquillo','Hidalgo','42360'),
(59,'Tecozautla','Hidalgo','42440'),
(60,'Tenango de Doria','Hidalgo','42120'),
(61,'Tepeapulco','Hidalgo','42120'),
(62,'Tepehuacan de Guerrero','Hidalgo','43130'),
(63,'Tepeji del Rio de Ocampo','Hidalgo','42850'),
(64,'Tepetitlan','Hidalgo','42900'),
(65,'Tetepango','Hidalgo','42940'),
(66,'Tezontepec de Aldama','Hidalgo','42760'),
(67,'Tianguistengo','Hidalgo','43200'),
(68,'Tizayuca','Hidalgo','43800'),
(69,'Tlahuelilpan','Hidalgo','42780'),
(70,'Tlahuiltepa','Hidalgo','43170'),
(71,'Tlanalapa','Hidalgo','43970'),
(72,'Tlanchinol','Hidalgo','43150'),
(73,'Tlaxcoapan','Hidalgo','42960'),
(74,'Tolcayuca','Hidalgo','43860'),
(75,'Tula de Allende','Hidalgo','42800'),
(76,'Tulancingo de Bravo','Hidalgo','43600'),
(77,'Villa de Tezontepec','Hidalgo','43980'),
(78,'Xochiatipan','Hidalgo','43090'),
(79,'Xochicoatlan','Hidalgo','43250'),
(80,'Yahualica','Hidalgo','43080'),
(81,'Zacualtipan de Angeles','Hidalgo','43260'),
(82,'Zapotlan de Juarez','Hidalgo','42140'),
(83,'Zempoala','Hidalgo','43830'),
(84,'Zimapan','Hidalgo','42330');

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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `notificacion` */

insert  into `notificacion`(`id_notificacion`,`id_usuario`,`id_cita`,`tipo`,`canal`,`estado_envio`,`titulo`,`mensaje`,`fecha_creacion`,`fecha_envio`,`fecha_lectura`,`codigo_error`) values 
(1,5,1,'cita_confirmada','interno','enviada','Cita médica registrada','Tu cita quedó programada para el 2026-11-23 09:30:00 en el consultorio asignado.','2026-11-21 00:38:52',NULL,NULL,NULL),
(2,6,2,'cita_confirmada','interno','enviada','Cita médica registrada','Tu cita quedó programada para el 2026-11-25 10:45:00 en el consultorio asignado.','2026-11-21 00:38:52',NULL,NULL,NULL),
(3,7,3,'cita_confirmada','interno','enviada','Cita médica registrada','Tu cita quedó programada para el 2026-11-14 11:00:00 en el consultorio asignado.','2026-11-21 00:38:52',NULL,NULL,NULL),
(4,6,4,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita quedó confirmada para el próximo lunes.','2026-11-21 00:45:10',NULL,NULL,NULL),
(5,9,5,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Chequeo Preventivo Anual con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-12-01 a las 13:00 en Consultorio 101 - Medicina Familiar.','2026-11-21 23:04:32',NULL,NULL,NULL),
(6,9,6,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2027-02-16 a las 12:30 en Consultorio 101 - Medicina Familiar.','2026-11-21 23:17:49',NULL,NULL,NULL),
(7,9,7,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 09:00 en Consultorio 101 - Medicina Familiar.','2026-11-21 23:18:22',NULL,NULL,NULL),
(8,9,8,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 10:00 en Consultorio 101 - Medicina Familiar.','2026-11-21 23:27:35',NULL,NULL,NULL),
(9,9,9,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 15:30 en Consultorio 101 - Medicina Familiar.','2026-11-21 23:40:06',NULL,NULL,NULL),
(10,9,10,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 10:30 en Consultorio 101 - Medicina Familiar.','2026-11-22 00:04:57',NULL,NULL,NULL),
(11,9,11,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Sofia Flores Reyes quedó confirmada para 2026-11-25 a las 16:30 en Consultorio 102 - Cardiología.','2026-11-22 00:21:18',NULL,NULL,NULL),
(12,9,12,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Chequeo Preventivo Anual con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 16:30 en Consultorio 101 - Medicina Familiar.','2026-11-22 00:21:53',NULL,NULL,NULL),
(13,9,13,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Chequeo Preventivo Anual con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 16:00 en Consultorio 101 - Medicina Familiar.','2026-11-22 00:29:22',NULL,NULL,NULL),
(14,9,14,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 11:00 en Consultorio 101 - Medicina Familiar.','2026-11-22 00:33:34',NULL,NULL,NULL),
(15,9,15,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 15:00 en Consultorio 101 - Medicina Familiar.','2026-11-22 00:59:00',NULL,NULL,NULL),
(16,9,16,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Chequeo Preventivo Anual con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-23 a las 13:30 en Consultorio 101 - Medicina Familiar.','2026-11-22 00:59:11',NULL,NULL,NULL),
(17,9,17,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Sofia Flores Reyes quedó confirmada para 2026-11-25 a las 17:30 en Consultorio 102 - Cardiología.','2026-11-24 12:05:23',NULL,NULL,NULL),
(18,9,18,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-25 a las 09:00 en Consultorio 101 - Medicina Familiar.','2026-11-24 12:05:34',NULL,NULL,NULL),
(19,9,19,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Chequeo Preventivo Anual con Sofia Flores Reyes quedó confirmada para 2026-11-25 a las 10:00 en Consultorio 102 - Cardiología.','2026-11-24 12:07:22',NULL,NULL,NULL),
(20,9,20,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Chequeo Preventivo Anual con Sofia Flores Reyes quedó confirmada para 2026-11-25 a las 11:30 en Consultorio 102 - Cardiología.','2026-11-24 12:13:58',NULL,NULL,NULL),
(21,9,21,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-25 a las 09:30 en Consultorio 101 - Medicina Familiar.','2026-11-24 21:15:28',NULL,NULL,NULL),
(22,9,22,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-25 a las 16:00 en Consultorio 101 - Medicina Familiar.','2026-11-24 21:15:47',NULL,NULL,NULL),
(23,5,23,'cita_confirmada','interno','pendiente','Cita confirmada','Tu cita de Consulta de Medicina General con Jose Manuel Rodriguez Lopez quedó confirmada para 2026-11-26 a las 09:00 en Consultorio 101 - Medicina Familiar.','2026-11-25 11:24:04',NULL,NULL,NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `paciente` */

insert  into `paciente`(`id_paciente`,`id_persona`,`alergias`,`notas_medicas`,`estado`,`fecha_registro`) values 
(1,5,'Ninguna conocida.','Chequeo periódico de rutina.','activo','2026-11-21 00:38:51'),
(2,6,'Alérgica a penicilina y sulfas.','Monitoreo de presión arterial y perfil lipídico.','activo','2026-11-21 00:38:51'),
(3,7,'Alergia estacional a polen y polvo.','Control asmático leve bajo inhalador.','activo','2026-11-21 00:38:51'),
(4,8,NULL,NULL,'activo','2026-11-21 00:45:10'),
(5,9,NULL,NULL,'activo','2026-11-21 22:14:50'),
(6,10,NULL,NULL,'activo','2026-11-23 19:49:46'),
(7,11,NULL,NULL,'activo','2026-11-24 00:33:13'),
(8,12,NULL,NULL,'activo','2026-11-24 00:38:52');

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `persona` */

insert  into `persona`(`id_persona`,`nombres`,`apellido_paterno`,`apellido_materno`,`fecha_nacimiento`,`correo_contacto`,`telefono_principal`,`telefono_secundario`,`fecha_registro`,`fecha_actualizacion`) values 
(1,'Carlos','Vega','Mendoza','1985-04-12','carlos.vega.admin@medicdate.com','7711000001','7711000002','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(2,'Jose Manuel','Rodriguez','Lopez','1980-05-14','jose.rodriguez.doc@example.test','5550000001',NULL,'2026-11-21 00:38:50','2026-11-21 00:38:50'),
(3,'Sofia','Flores','Reyes','1987-10-25','sofia.flores.doc@medicdate.com','5550000002',NULL,'2026-11-21 00:38:50','2026-11-21 00:38:50'),
(4,'Luna Aurora','Reyes','Morales','1995-04-18','luna.reyes.asistente@example.test','5550000003',NULL,'2026-11-21 00:38:50','2026-11-21 00:38:50'),
(5,'Ronaldo','Hernandez','Hernandez','1998-07-21','ronaldo@gmail.com','7711009868',NULL,'2026-11-21 00:38:50','2026-11-24 01:02:41'),
(6,'Maria','Lopez','Martinez','1992-06-15','maria.lopez@example.com','5512345602','5522345602','2026-11-21 00:38:50','2026-11-21 00:38:50'),
(7,'Juan','Perez','Garcia','1985-03-10','juan.perez@example.com','5512345678',NULL,'2026-11-21 00:38:50','2026-11-21 00:38:50'),
(8,'Valeria','Montes','Serrano',NULL,'nuevo.paciente.test@medicdate.com','7719998877',NULL,'2026-11-21 00:45:10','2026-11-21 00:45:10'),
(9,'Arturo','Reyes','Rodríguez',NULL,'arthur.sanavia@outlook.com','7713404798',NULL,'2026-11-21 22:14:49','2026-11-21 22:14:49'),
(10,'Monserrat','Hdez','Hdez',NULL,'Monse@ejemplo.com','7712346471',NULL,'2026-11-23 19:49:46','2026-11-23 19:49:46'),
(11,'Jose Juan','Cruz','Hernandez',NULL,'juan@gmail.com','7711223344',NULL,'2026-11-24 00:33:13','2026-11-24 00:33:13'),
(12,'Juan','Perez',NULL,NULL,'juancho@gmail.com','7712457869',NULL,'2026-11-24 00:38:51','2026-11-24 00:38:51');

/*Table structure for table `pregunta_frecuente` */

DROP TABLE IF EXISTS `pregunta_frecuente`;

CREATE TABLE `pregunta_frecuente` (
  `id_pregunta_frecuente` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pregunta` varchar(200) NOT NULL,
  `respuesta` text NOT NULL,
  `orden` smallint(5) unsigned NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_pregunta_frecuente`),
  KEY `idx_faq_orden` (`activo`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `pregunta_frecuente` */

insert  into `pregunta_frecuente`(`id_pregunta_frecuente`,`pregunta`,`respuesta`,`orden`,`activo`) values 
(1,'¿Cómo agendar una cita médica?','Puedes solicitar tu cita directamente desde nuestra aplicación móvil Android o en el portal web seleccionando la especialidad, médico y horario disponible.',1,1),
(2,'¿Con cuánta anticipación debo llegar a mi cita?','Recomendamos presentarse 15 minutos antes de la hora acordada en recepción para toma de signos vitales.',2,1),
(3,'¿Puedo cancelar o reprogramar una cita?','Sí, puedes cancelar o reprogramar con al menos 24 horas de anticipación desde tu panel de usuario.',3,1),
(4,'¿Cuáles son los métodos de pago aceptados?','Aceptamos pago en efectivo, tarjeta de débito/crédito y transferencias electrónicas en el centro médico.',4,1);

/*Table structure for table `pregunta_secreta` */

DROP TABLE IF EXISTS `pregunta_secreta`;

CREATE TABLE `pregunta_secreta` (
  `id_pregunta_secreta` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `texto` varchar(150) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_pregunta_secreta`),
  UNIQUE KEY `uq_pregunta_secreta_texto` (`texto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `pregunta_secreta` */

insert  into `pregunta_secreta`(`id_pregunta_secreta`,`texto`,`activo`) values 
(1,'¿Cual es el nombre de tu primera mascota?',1),
(2,'¿En que ciudad nacio tu madre?',1),
(3,'¿Cual fue tu escuela primaria?',1),
(4,'¿Cual es tu comida favorita?',1),
(5,'¿Cual es el nombre de tu mejor amigo de la infancia?',1),
(6,'¿Cual fue tu primer trabajo?',1);

/*Table structure for table `resena` */

DROP TABLE IF EXISTS `resena`;

CREATE TABLE `resena` (
  `id_resena` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` bigint(20) unsigned DEFAULT NULL,
  `nombre_autor` varchar(100) NOT NULL,
  `estrellas` tinyint(3) unsigned NOT NULL,
  `texto` varchar(500) NOT NULL,
  `publicada` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_resena`),
  KEY `idx_resena_publicada` (`publicada`,`fecha_registro`),
  KEY `fk_resena_paciente` (`id_paciente`),
  CONSTRAINT `fk_resena_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_resena_estrellas` CHECK (`estrellas` between 1 and 5)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `resena` */

insert  into `resena`(`id_resena`,`id_paciente`,`nombre_autor`,`estrellas`,`texto`,`publicada`,`fecha_registro`) values 
(1,1,'Ronaldo Hernández',5,'Excelente atención por parte del Dr. Rodríguez. Muy puntual y diagnóstico preciso.',1,'2026-11-21 00:38:52'),
(2,2,'María López',5,'Las instalaciones del Centro Sagrado Corazón son impecables y la atención de la Dra. Flores fue excepcional.',1,'2026-11-21 00:38:52'),
(3,NULL,'Mariana Sánchez (Familiar)',5,'Atendieron a mi abuelito con mucha calidez y paciencia. Muy recomendados.',1,'2026-11-21 00:38:52');

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
  `resumen` varchar(200) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `duracion_minutos` smallint(5) unsigned NOT NULL,
  `costo_base` decimal(10,2) DEFAULT NULL,
  `moneda` char(3) NOT NULL DEFAULT 'MXN',
  `orden` smallint(5) unsigned NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `publicado_web` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_tipo_atencion`),
  UNIQUE KEY `uq_tipo_atencion_nombre_especialidad` (`nombre`,`id_especialidad`),
  KEY `idx_tipo_atencion_especialidad` (`id_especialidad`),
  KEY `idx_tipo_atencion_activo` (`activo`),
  KEY `idx_tipo_atencion_web` (`publicado_web`,`orden`),
  CONSTRAINT `fk_tipo_atencion_especialidad` FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`) ON UPDATE CASCADE,
  CONSTRAINT `chk_tipo_atencion_duracion` CHECK (`duracion_minutos` > 0),
  CONSTRAINT `chk_tipo_atencion_costo` CHECK (`costo_base` is null or `costo_base` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tipo_atencion` */

insert  into `tipo_atencion`(`id_tipo_atencion`,`id_especialidad`,`nombre`,`resumen`,`descripcion`,`duracion_minutos`,`costo_base`,`moneda`,`orden`,`activo`,`publicado_web`,`fecha_actualizacion`) values 
(1,1,'Consulta de Medicina General','Evaluación clínica integral y diagnóstico de primer contacto.','Consulta de valoración médica general y prescripción de tratamiento.',30,350.00,'MXN',1,1,1,'2026-11-21 00:38:49'),
(2,1,'Chequeo Preventivo Anual','Revisión médica completa y tamizaje preventivo anual.','Examen físico detallado, toma de signos y solicitud de analíticas preventivas.',45,500.00,'MXN',2,1,1,'2026-11-21 00:38:49'),
(3,2,'Consulta Cardiológica con ECG','Valoración especializada con electrocardiograma en reposo.','Consulta con especialista cardiólogo, incluye reporte de ECG e interpretación.',45,750.00,'MXN',3,1,1,'2026-11-21 00:38:49'),
(4,2,'Control de Hipertensión','Seguimiento periódico y ajuste farmacológico de presión arterial.','Monitoreo de cifras tensionales y evaluación de apego al tratamiento.',30,600.00,'MXN',4,1,1,'2026-11-21 00:38:49'),
(5,3,'Control de Niño Sano','Monitoreo de percentiles de crecimiento y desarrollo pediátrico.','Evaluación integral de peso, talla, hitos del desarrollo y vacunación.',30,450.00,'MXN',5,1,1,'2026-11-21 00:38:49'),
(6,4,'Consulta Dermatológica','Evaluación clínica de patologías de piel, pelo y uñas.','Revisión especializada de lesiones cutáneas y tratamiento personalizado.',30,650.00,'MXN',6,1,1,'2026-11-21 00:38:49');

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
  `cambio_password_obligatorio` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ultimo_acceso` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuario_persona` (`id_persona`),
  UNIQUE KEY `uq_usuario_correo_acceso` (`correo_acceso`),
  KEY `idx_usuario_estado` (`estado`),
  CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `usuario` */

insert  into `usuario`(`id_usuario`,`id_persona`,`correo_acceso`,`password_hash`,`estado`,`cambio_password_obligatorio`,`fecha_registro`,`fecha_actualizacion`,`ultimo_acceso`) values 
(1,1,'carlos.vega.admin@medicdate.com','$2y$10$dSLetkjHcThiki//0kCIU.e0biMtIID6SwJ18ktgYKsCX9DRWDb.S','activa',0,'2026-11-21 00:38:50','2026-11-25 12:40:33','2026-11-25 12:40:33'),
(2,2,'jose.rodriguez.doc@example.test','$2y$10$dSLetkjHcThiki//0kCIU.e0biMtIID6SwJ18ktgYKsCX9DRWDb.S','activa',0,'2026-11-21 00:38:50','2026-11-25 12:00:17',NULL),
(3,3,'sofia.flores.doc@medicdate.com','$2y$10$dSLetkjHcThiki//0kCIU.e0biMtIID6SwJ18ktgYKsCX9DRWDb.S','activa',0,'2026-11-21 00:38:50','2026-11-25 12:31:44','2026-11-25 12:31:44'),
(4,4,'luna.reyes.asistente@example.test','$2y$10$dSLetkjHcThiki//0kCIU.e0biMtIID6SwJ18ktgYKsCX9DRWDb.S','activa',0,'2026-11-21 00:38:50','2026-11-25 12:27:35','2026-11-25 12:27:35'),
(5,5,'ronaldo@gmail.com','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa',0,'2026-11-21 00:38:50','2026-11-25 11:28:04','2026-11-25 11:28:04'),
(6,6,'maria.lopez@example.com','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa',0,'2026-11-21 00:38:50','2026-11-21 00:38:50',NULL),
(7,7,'juan.perez@example.com','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa',0,'2026-11-21 00:38:50','2026-11-21 00:38:50',NULL),
(8,8,'nuevo.paciente.test@medicdate.com','$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y','activa',0,'2026-11-21 00:45:10','2026-11-21 00:45:10',NULL),
(9,9,'arthur.sanavia@outlook.com','$2y$12$KOBzC6v0hGskXGWgDmcu/uTvj.6Z3nBhU76rV7QxOBwLwW5sgvrGu','activa',0,'2026-11-21 22:14:50','2026-11-25 18:40:10','2026-11-25 18:40:10'),
(10,10,'Monse@ejemplo.com','$2y$12$3LbkByeBacBTkaq8/5Dkne3C3C4FJoHJBxspQCXsXmZyWxIQse0NK','activa',0,'2026-11-23 19:49:46','2026-11-23 19:49:52','2026-11-23 19:49:52'),
(11,11,'juan@gmail.com','$2y$12$vZjtxJHycQftgHoCOBis5.icsovw4PkkGq72ZgKnjpDKSJ2.sJHxO','activa',0,'2026-11-24 00:33:13','2026-11-24 00:33:59','2026-11-24 00:33:59'),
(12,12,'juancho@gmail.com','$2y$12$iC5TuBZMgM3niRWpK1gYU.ZdClIHJZINYNeZPr8gwfIWCKtxFip86','activa',0,'2026-11-24 00:38:51','2026-11-24 01:06:52','2026-11-24 01:06:52');

/*Table structure for table `usuario_pregunta_secreta` */

DROP TABLE IF EXISTS `usuario_pregunta_secreta`;

CREATE TABLE `usuario_pregunta_secreta` (
  `id_usuario` bigint(20) unsigned NOT NULL,
  `id_pregunta_secreta` smallint(5) unsigned NOT NULL,
  `respuesta_hash` varchar(255) NOT NULL,
  `intentos_fallidos` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `bloqueado_hasta` datetime DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`,`id_pregunta_secreta`),
  KEY `idx_ups_pregunta` (`id_pregunta_secreta`),
  CONSTRAINT `fk_ups_pregunta` FOREIGN KEY (`id_pregunta_secreta`) REFERENCES `pregunta_secreta` (`id_pregunta_secreta`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ups_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `usuario_pregunta_secreta` */

insert  into `usuario_pregunta_secreta`(`id_usuario`,`id_pregunta_secreta`,`respuesta_hash`,`intentos_fallidos`,`bloqueado_hasta`,`fecha_actualizacion`) values 
(1,1,'2ff362faea73ddbc8df81690ab5e79337c024089c9de70b861da9d5bc7ef8c99',0,NULL,'2026-11-21 00:38:51'),
(2,1,'2ff362faea73ddbc8df81690ab5e79337c024089c9de70b861da9d5bc7ef8c99',0,NULL,'2026-11-21 00:38:51'),
(4,1,'2ff362faea73ddbc8df81690ab5e79337c024089c9de70b861da9d5bc7ef8c99',0,NULL,'2026-11-21 00:38:51'),
(5,1,'2ff362faea73ddbc8df81690ab5e79337c024089c9de70b861da9d5bc7ef8c99',0,NULL,'2026-11-21 00:38:51'),
(6,1,'2ff362faea73ddbc8df81690ab5e79337c024089c9de70b861da9d5bc7ef8c99',0,NULL,'2026-11-21 00:38:51'),
(11,2,'$2y$12$hjIVVQ84WeCVohsEA1JIcexCp4qxeUE1Q8i4/z.oW6KJce5WuKRcW',0,NULL,'2026-11-24 00:33:13'),
(12,2,'$2y$12$G4Oyz42GZ4Kp4frbM790DeLEVxAZq/9osuRKnljBsSxST4RuhKYui',0,NULL,'2026-11-24 00:38:52');

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
(1,1,'2026-11-21 00:38:51'),
(2,3,'2026-11-21 00:38:51'),
(3,3,'2026-11-21 00:38:51'),
(4,2,'2026-11-21 00:38:51'),
(5,4,'2026-11-21 00:38:51'),
(6,4,'2026-11-21 00:38:51'),
(7,4,'2026-11-21 00:38:51'),
(8,4,'2026-11-21 00:45:10'),
(9,4,'2026-11-21 22:14:50'),
(10,4,'2026-11-23 19:49:46'),
(11,4,'2026-11-24 00:33:13'),
(12,4,'2026-11-24 00:38:51');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
