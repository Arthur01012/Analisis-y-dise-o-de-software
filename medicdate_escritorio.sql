/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 11.4.13-MariaDB-cll-lve-log : Database - innegone_bd_medic
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`innegone_bd_medic` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;

USE `innegone_bd_medic`;

/*Table structure for table `administrador` */

DROP TABLE IF EXISTS `administrador`;

CREATE TABLE `administrador` (
  `id_empleado` int(11) NOT NULL,
  `nivel_acceso` int(11) DEFAULT 1,
  PRIMARY KEY (`id_empleado`),
  CONSTRAINT `administrador_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `administrador` */

/*Table structure for table `asistente` */

DROP TABLE IF EXISTS `asistente`;

CREATE TABLE `asistente` (
  `id_empleado` int(11) NOT NULL,
  `turno` varchar(30) NOT NULL,
  PRIMARY KEY (`id_empleado`),
  CONSTRAINT `asistente_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `asistente` */

insert  into `asistente`(`id_empleado`,`turno`) values 
(32,'Matutino'),
(33,'Vespertino'),
(34,'Matutino'),
(35,'Nocturno'),
(36,'Matutino'),
(37,'Vespertino'),
(38,'Mixto'),
(39,'Nocturno'),
(40,'Matutino'),
(41,'Vespertino'),
(44,'Nocturno'),
(45,'Vespertino');

/*Table structure for table `categorias` */

DROP TABLE IF EXISTS `categorias`;

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `categorias` */

/*Table structure for table `cita` */

DROP TABLE IF EXISTS `cita`;

CREATE TABLE `cita` (
  `id_cita` int(11) NOT NULL AUTO_INCREMENT,
  `id_paciente` int(11) NOT NULL,
  `id_doctor` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `duracion` int(11) DEFAULT 30,
  `motivo` text DEFAULT NULL,
  `estado` enum('Pendiente','Confirmada','En Progreso','Completada','Cancelada') DEFAULT 'Pendiente',
  `costo` decimal(10,2) DEFAULT NULL,
  `notas_internas` text DEFAULT NULL,
  `id_registrado_por` int(11) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_cita`),
  KEY `id_doctor` (`id_doctor`),
  KEY `id_registrado_por` (`id_registrado_por`),
  KEY `idx_cita_fecha_doctor` (`fecha`,`id_doctor`),
  KEY `idx_cita_estado` (`estado`),
  KEY `idx_cita_paciente` (`id_paciente`),
  CONSTRAINT `cita_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON UPDATE CASCADE,
  CONSTRAINT `cita_ibfk_2` FOREIGN KEY (`id_doctor`) REFERENCES `doctor` (`id_empleado`) ON UPDATE CASCADE,
  CONSTRAINT `cita_ibfk_3` FOREIGN KEY (`id_registrado_por`) REFERENCES `empleado` (`id_empleado`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `cita` */

insert  into `cita`(`id_cita`,`id_paciente`,`id_doctor`,`fecha`,`hora`,`duracion`,`motivo`,`estado`,`costo`,`notas_internas`,`id_registrado_por`,`fecha_registro`,`fecha_actualizacion`) values 
(11,8,22,'2026-07-17','11:00:00',30,'Dolor de cabeza','Pendiente',400.00,NULL,32,'2026-07-22 07:35:08','2026-08-03 11:19:26'),
(12,9,23,'2026-07-23','10:30:00',45,'Consulta de rutina y control de alergias','Cancelada',500.00,NULL,34,'2026-07-22 07:35:08','2026-07-31 10:58:15'),
(13,10,24,'2026-07-24','08:15:00',30,'Revisión de hipertensión','Completada',350.00,'Presión arterial controlada',33,'2026-07-22 07:35:08','2026-07-22 07:35:08'),
(14,11,25,'2026-07-24','11:45:00',30,'Dolor pélvico','Confirmada',600.00,NULL,37,'2026-07-22 07:35:08','2026-07-22 07:35:08'),
(15,12,26,'2026-07-25','09:30:00',30,'Control de diabetes','Pendiente',450.00,NULL,35,'2026-07-22 07:35:08','2026-07-22 07:35:08'),
(16,13,27,'2026-07-25','12:00:00',30,'Erupción cutánea y alergia','Confirmada',520.00,'Posible dermatitis',38,'2026-07-22 07:35:08','2026-07-22 07:35:08'),
(17,14,27,'2026-08-06','08:00:00',30,'Chequeo de la vista','Pendiente',350.00,NULL,36,'2026-07-22 07:35:08','2026-08-03 07:46:48'),
(18,15,29,'2026-07-26','11:00:00',45,'Control de asma','Completada',480.00,'Paciente estable',41,'2026-07-22 07:35:08','2026-07-22 07:35:08'),
(19,16,30,'2026-07-27','09:15:00',30,'Dolor en el pecho','Confirmada',600.00,'Se derivará a cardiología',39,'2026-07-22 07:35:08','2026-07-22 07:35:08'),
(20,17,31,'2026-07-27','10:45:00',30,'Consulta ginecológica anual','Confirmada',550.00,NULL,40,'2026-07-22 07:35:08','2026-07-31 10:54:49'),
(22,54,27,'2026-08-06','08:30:00',30,'Revision mensual por quemaduras hace 2 meses','Pendiente',200.00,NULL,32,'2026-08-01 17:10:31','2026-08-03 07:47:27'),
(23,47,18,'2026-08-04','11:00:00',30,'revision general','Pendiente',200.00,NULL,32,'2026-08-01 19:33:08','2026-08-03 07:46:09'),
(24,45,31,'2026-08-06','08:30:00',30,'chequeo mensual','Pendiente',NULL,NULL,32,'2026-08-01 19:52:30','2026-08-03 08:01:02'),
(25,8,23,'2026-08-03','13:30:00',30,'seguimiento','Completada',600.00,'Tras los problemas mostrados con anterioridad se puede ver que el paciente mustra una mejoria con respecto a citas anteriores, se espera su mejoria en citas posteriores, se agendara una nueva cita el jueves 6 de agosto',32,'2026-08-02 18:44:55','2026-08-03 07:36:58'),
(26,56,26,'2026-08-02','08:00:00',30,'revision mensual','Cancelada',700.00,NULL,32,'2026-08-02 18:56:35','2026-08-03 07:45:01'),
(27,56,26,'2026-08-02','08:30:00',30,'revision','Cancelada',202.00,NULL,32,'2026-08-02 19:06:26','2026-08-02 19:06:47'),
(28,56,18,'2026-08-02','00:00:00',30,'asj','Cancelada',50.00,NULL,32,'2026-08-02 19:07:11','2026-08-02 19:07:43'),
(29,61,31,'2026-08-02','08:00:00',30,'s','Cancelada',NULL,NULL,32,'2026-08-02 19:22:41','2026-08-02 19:22:50'),
(32,44,31,'2026-08-13','08:00:00',30,'consulta','Pendiente',450.00,NULL,NULL,'2026-08-03 01:43:10','2026-08-03 01:43:10'),
(33,44,31,'2026-08-28','08:00:00',30,'Consulta','Pendiente',500.00,NULL,NULL,'2026-08-03 01:51:02','2026-08-03 01:51:02'),
(34,77,18,'2026-08-13','11:00:00',30,'Consulta','Pendiente',460.00,NULL,NULL,'2026-08-03 01:52:37','2026-08-03 01:52:37'),
(35,78,28,'2026-08-04','08:00:00',30,'revision','Pendiente',400.00,NULL,32,'2026-08-03 07:25:49','2026-08-03 07:25:49'),
(36,75,28,'2026-08-03','08:00:00',30,'examen ','Completada',500.00,'La paciente muestra perdida visual con respecto a citas anteriores',32,'2026-08-03 07:30:12','2026-08-03 07:32:09'),
(37,8,22,'2026-08-17','11:00:00',30,'Dolor de cabeza y fiebre','Pendiente',200.00,NULL,32,'2026-08-03 10:48:33','2026-08-03 10:48:33'),
(38,62,18,'2026-08-04','11:30:00',30,'Dolor de cabeza','Pendiente',200.00,NULL,32,'2026-08-04 08:40:20','2026-08-04 08:40:20'),
(39,10,18,'2026-08-04','12:00:00',30,'Gripa y tos','Pendiente',200.00,NULL,32,'2026-08-04 08:41:37','2026-08-04 08:41:37'),
(40,75,18,'2026-08-04','12:30:00',30,'seguimiento','Pendiente',200.00,NULL,32,'2026-08-04 08:42:34','2026-08-04 08:42:34'),
(41,68,18,'2026-08-04','13:00:00',30,'Vomito','Pendiente',200.00,NULL,32,'2026-08-04 08:45:47','2026-08-04 08:45:47'),
(42,44,18,'2026-08-04','13:30:00',30,'Consulta','Pendiente',500.00,NULL,32,'2026-08-04 09:30:14','2026-08-04 09:30:14'),
(43,59,18,'2026-08-04','14:00:00',30,'Consulta','Pendiente',250.00,NULL,32,'2026-08-04 09:31:52','2026-08-04 09:31:52');

/*Table structure for table `doctor` */

DROP TABLE IF EXISTS `doctor`;

CREATE TABLE `doctor` (
  `id_empleado` int(11) NOT NULL,
  `cedula_profesional` varchar(50) NOT NULL,
  `especialidad_principal` int(11) DEFAULT NULL,
  `consultorio` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `cedula_profesional` (`cedula_profesional`),
  KEY `especialidad_principal` (`especialidad_principal`),
  KEY `idx_doctor_cedula` (`cedula_profesional`),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `doctor_ibfk_2` FOREIGN KEY (`especialidad_principal`) REFERENCES `especialidad` (`id_especialidad`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `doctor` */

insert  into `doctor`(`id_empleado`,`cedula_profesional`,`especialidad_principal`,`consultorio`) values 
(17,'CED12345678',1,'075'),
(18,'CED123456789',1,'100'),
(19,'CED12345665',1,'102'),
(20,'CED47383628',7,'01'),
(21,'CED123456781',2,'03'),
(22,'CED123456001',1,'101'),
(23,'CED123456002',2,'102'),
(24,'CED123456003',3,'103'),
(25,'CED123456004',4,'104'),
(26,'CED123456005',5,'105'),
(27,'CED123456006',6,'106'),
(28,'CED123456007',7,'107'),
(29,'CED123456008',8,'108'),
(30,'CED123456009',2,'109'),
(31,'CED123456010',3,'110'),
(42,'CED123456011',2,'041'),
(47,'ced',1,'777'),
(48,'23435432345432',2,'dsfdbfg');

/*Table structure for table `doctor_especialidad` */

DROP TABLE IF EXISTS `doctor_especialidad`;

CREATE TABLE `doctor_especialidad` (
  `id_doctor` int(11) NOT NULL,
  `id_especialidad` int(11) NOT NULL,
  PRIMARY KEY (`id_doctor`,`id_especialidad`),
  KEY `id_especialidad` (`id_especialidad`),
  CONSTRAINT `doctor_especialidad_ibfk_1` FOREIGN KEY (`id_doctor`) REFERENCES `doctor` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `doctor_especialidad_ibfk_2` FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `doctor_especialidad` */

insert  into `doctor_especialidad`(`id_doctor`,`id_especialidad`) values 
(17,1),
(17,2);

/*Table structure for table `empleado` */

DROP TABLE IF EXISTS `empleado`;

CREATE TABLE `empleado` (
  `id_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido_paterno` varchar(50) NOT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `curp` varchar(18) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `telefono_principal` varchar(20) DEFAULT NULL,
  `telefono_secundario` varchar(20) DEFAULT NULL,
  `tipo_empleado` enum('administrador','asistente','doctor') NOT NULL,
  `fecha_contratacion` date NOT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `estado` tinyint(1) DEFAULT 1,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `curp` (`curp`),
  UNIQUE KEY `id_usuario` (`id_usuario`),
  KEY `idx_empleado_tipo` (`tipo_empleado`),
  CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `empleado` */

insert  into `empleado`(`id_empleado`,`nombre`,`apellido_paterno`,`apellido_materno`,`fecha_nacimiento`,`curp`,`email`,`telefono_principal`,`telefono_secundario`,`tipo_empleado`,`fecha_contratacion`,`fecha_registro`,`estado`,`id_usuario`) values 
(17,'jose','Martínez','López','1980-05-14','MALJ800515HDFRPN03','Lopez.@medicdate.com','5559876543',NULL,'doctor','2026-07-20','2026-07-20 18:02:19',0,17),
(18,'Josefa','Fernández','López','2000-11-21','FELM850315MDFRPR09','josefa.fernandez@medicdate.com','5512345678','5512345675','doctor','2026-07-20','2026-07-20 19:55:26',1,18),
(19,'Damian','Sanchez','Romero','2000-03-14','RERR070313HHGYDDA2','Damian@medicdate.com','7744885566',NULL,'doctor','2026-07-29','2026-07-21 07:37:31',0,20),
(20,'Ronaldo','Hernández','Hernández','2008-07-21','JHFH567890HGFDSA98','rony@gmail.com','7711882211','6611772211','doctor','2026-07-21','2026-07-21 13:41:47',0,21),
(21,'Francisco','Hernández','Hernández','2008-07-21','FRHH876432JHGFYG98','frank@gmail.com','3322778811','8833882288','doctor','2026-07-21','2026-07-21 13:46:31',0,22),
(22,'Carlos','López','Mendoza','1985-03-15','GODE561231HDFRRL02','carlos.lopez@medicdate.com','5512345601',NULL,'doctor','2026-01-10','2026-07-22 07:31:38',1,23),
(23,'Ana','García','Pérez','1978-07-22','GAPA780722MDFRPN02','ana.garcia@medicdate.com','5512345602',NULL,'doctor','2026-01-15','2026-07-22 07:31:38',1,24),
(24,'Luis','Rodríguez','Sánchez','1990-11-05','ROSL901105HDFRPN05','luis.rodriguez@medicdate.com','5512345603','5522345603','doctor','2026-02-01','2026-07-22 07:31:38',1,25),
(25,'María','Martínez','Fernández','1982-09-30','MAFM820930MDFRPN02','maria.martinez@medicdate.com','5512345604',NULL,'doctor','2026-02-15','2026-07-22 07:31:38',1,26),
(26,'José','Hernández','Torres','1975-12-12','HETJ751212HDFRPN05','jose.hernandez@medicdate.com','5512345605','5522345605','doctor','2026-03-01','2026-07-22 07:31:38',1,27),
(27,'Laura','González','Ramírez','1988-05-20','GARL880520MDFRPN06','laura.gonzalez@medicdate.com','5512345606',NULL,'doctor','2026-03-15','2026-07-22 07:31:38',1,28),
(28,'Pedro','Pérez','Gómez','1983-08-14','PEGP830814HDFRPN07','pedro.perez@medicdate.com','5512345607','5522345607','doctor','2026-04-01','2026-07-22 07:31:38',1,29),
(29,'Marta','Sánchez','Díaz','1992-02-28','SADM920228MDFRPN08','marta.sanchez@medicdate.com',NULL,NULL,'doctor','2026-04-15','2026-07-22 07:31:38',0,30),
(30,'Raúl','Ramírez','Cruz','1980-06-10','RACR800610HDFRPN09','raul.ramirez@medicdate.com','5512345609','5522345609','doctor','2026-05-01','2026-07-22 07:31:38',1,31),
(31,'Sofía','Flores','Reyes','1987-10-25','FLRS871025MDFRPN10','sofia.flores@medicdate.com','5512345610',NULL,'doctor','2026-07-29','2026-07-22 07:31:38',1,32),
(32,'Elena','Luna','Vega','1995-04-18','LUVE950418MDFRPN11','elena.luna@medicdate.com','5512345611','8512475698','asistente','2026-01-10','2026-07-22 07:31:38',1,33),
(33,'David','Díaz','Ortiz','1993-07-07','DIOD930707HDFRPN12','david.diaz@medicdate.com','5512345612','5522345612','asistente','2026-01-20','2026-07-22 07:31:38',1,34),
(34,'Carmen','Ortiz','Mendoza','1990-11-01','ORMC901101MDFRPN13','carmen.ortiz@medicdate.com','5512345613','5589743214','asistente','2026-02-05','2026-07-22 07:31:38',1,35),
(35,'Roberto','Mendoza','Cruz','1988-09-12',NULL,'roberto.mendoza@medicdate.com','5512345614',NULL,'asistente','2026-02-20','2026-07-22 07:31:38',1,36),
(36,'Patricia','Cruz','Reyes','1991-03-25','CRRP910325MDFRPN15','patricia.cruz@medicdate.com','5512345615',NULL,'asistente','2026-03-01','2026-07-22 07:31:38',1,37),
(37,'Javier','Reyes','Morales','1986-12-05','RERJ861205HDFRPN16','javier.reyes@medicdate.com','5512345616','5522345616','asistente','2026-03-15','2026-07-22 07:31:38',1,38),
(38,'Silvia','Morales','Romero','1992-06-30','MORS920630MDFRPN17','silvia.morales@medicdate.com','5512345617',NULL,'asistente','2026-04-01','2026-07-22 07:31:38',1,39),
(39,'Alberto','Romero','Torres','1987-08-19','RORA870819HDFRPN18','alberto.romero@medicdate.com','5512345618','5522345618','asistente','2026-04-15','2026-07-22 07:31:38',0,40),
(40,'Lucía','Torres','Gutiérrez','1993-02-14','TOGL930214MDFRPN19','lucia.torres@medicdate.com','5512345619',NULL,'asistente','2026-05-01','2026-07-22 07:31:38',0,41),
(41,'Manuel','Gutiérrez','Luna','1989-10-10','GULM891010HDFRPN20','manuel.gutierrez@medicdate.com','5512345620','5522345620','asistente','2026-05-15','2026-07-22 07:31:38',1,42),
(42,'Cesar','saens','Pelcastre','1994-06-30','COSS901105HDFRPN03','Saens@medicdate.com','4565644645',NULL,'doctor','2026-07-29','2026-07-22 07:56:15',0,43),
(44,'Rony','Hdez','Hdez','2007-10-27',NULL,'ronaldo@gmail.com','3751110994',NULL,'asistente','2026-07-23','2026-07-22 21:30:37',1,45),
(45,'Fabiola','Mendez','Cruz','2008-06-17',NULL,'fabi@gmail.com','7892594563',NULL,'asistente','2026-07-23','2026-07-22 21:41:33',1,46),
(47,'art','art','art','2008-07-28','MALJ800515HDFRPN02','rt@medicdate.com',NULL,NULL,'doctor','2026-07-29','2026-07-28 12:55:16',0,48),
(48,'pablo','juarez','juarez','2008-07-31','GACM800101HDFRNN09','juarez12@gmail.com','3243454543','8732688321','doctor','2026-07-31','2026-07-31 11:24:00',0,49);

/*Table structure for table `especialidad` */

DROP TABLE IF EXISTS `especialidad`;

CREATE TABLE `especialidad` (
  `id_especialidad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_especialidad` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_especialidad`),
  UNIQUE KEY `nombre_especialidad` (`nombre_especialidad`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `especialidad` */

insert  into `especialidad`(`id_especialidad`,`nombre_especialidad`,`descripcion`) values 
(1,'Medicina General','Atención primaria y diagnóstico general'),
(2,'Cardiología','Especialidad del corazón y sistema circulatorio'),
(3,'Pediatría','Atención médica para niños y adolescentes'),
(4,'Ginecología','Salud de la mujer y sistema reproductor'),
(5,'Ortopedia','Sistema músculo-esquelético y lesiones'),
(6,'Dermatología','Piel y enfermedades cutáneas'),
(7,'Oftalmología','Salud ocular y visión'),
(8,'Neurología','Sistema nervioso y trastornos cerebrales'),
(9,'Urologia','Atencion del sistema urinario');

/*Table structure for table `horario` */

DROP TABLE IF EXISTS `horario`;

CREATE TABLE `horario` (
  `id_horario` int(11) NOT NULL AUTO_INCREMENT,
  `id_doctor` int(11) NOT NULL,
  `dia_semana` varchar(20) NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `intervalo_atencion` int(11) DEFAULT 30,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id_horario`),
  KEY `idx_horario_doctor_dia` (`id_doctor`,`dia_semana`),
  CONSTRAINT `horario_ibfk_1` FOREIGN KEY (`id_doctor`) REFERENCES `doctor` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `horario` */

insert  into `horario`(`id_horario`,`id_doctor`,`dia_semana`,`hora_inicio`,`hora_fin`,`intervalo_atencion`,`activo`) values 
(77,18,'Lunes','11:00:00','15:00:00',30,1),
(78,31,'Lunes','08:00:00','12:00:00',30,1),
(79,31,'Martes','08:00:00','12:00:00',30,1),
(80,31,'Miércoles','08:00:00','12:00:00',30,1),
(81,31,'Jueves','08:00:00','12:00:00',30,1),
(82,31,'Viernes','08:00:00','12:00:00',30,0),
(83,31,'Sábado','08:00:00','12:00:00',30,1),
(84,31,'Domingo','08:00:00','12:00:00',30,1),
(85,18,'Martes','11:00:00','15:00:00',30,1),
(86,18,'Miércoles','11:00:00','15:00:00',30,1),
(87,18,'Jueves','11:00:00','15:00:00',30,1),
(88,18,'Viernes','11:00:00','15:00:00',30,1),
(89,18,'Sábado','11:00:00','15:00:00',30,1),
(90,18,'Domingo','11:00:00','15:00:00',30,1),
(91,23,'Lunes','08:00:00','14:00:00',30,1),
(92,23,'Martes','08:00:00','14:00:00',30,1),
(93,23,'Miércoles','08:00:00','14:00:00',30,1),
(94,27,'Jueves','08:00:00','12:00:00',30,1),
(95,27,'Viernes','08:00:00','12:00:00',30,1),
(96,26,'Sábado','08:00:00','12:00:00',30,1),
(97,26,'Domingo','08:00:00','12:00:00',30,1),
(98,22,'Viernes','08:00:00','20:00:00',30,1),
(99,22,'Sábado','08:00:00','20:00:00',30,1),
(100,22,'Domingo','08:00:00','20:00:00',30,1),
(101,25,'Lunes','08:00:00','19:00:00',30,1),
(102,25,'Martes','08:00:00','19:00:00',30,1),
(103,25,'Miércoles','08:00:00','19:00:00',30,1),
(104,25,'Jueves','08:00:00','19:00:00',30,1),
(105,28,'Lunes','08:00:00','12:00:00',30,1),
(106,28,'Martes','08:00:00','12:00:00',30,1),
(107,28,'Sábado','08:00:00','12:00:00',30,1),
(108,24,'Lunes','08:00:00','12:00:00',30,1),
(109,24,'Martes','08:00:00','12:00:00',30,1),
(110,24,'Miércoles','08:00:00','12:00:00',30,1),
(111,24,'Jueves','08:00:00','12:00:00',30,1),
(112,24,'Viernes','08:00:00','12:00:00',30,1),
(113,22,'Lunes','08:00:00','22:00:00',30,1),
(114,22,'Martes','08:00:00','22:00:00',30,1),
(115,22,'Miércoles','08:00:00','22:00:00',30,1),
(116,22,'Jueves','08:00:00','22:00:00',30,1),
(117,26,'Martes','08:00:00','09:00:00',30,1);

/*Table structure for table `imagenes_producto` */

DROP TABLE IF EXISTS `imagenes_producto`;

CREATE TABLE `imagenes_producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_id` int(11) NOT NULL,
  `url_imagen` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_imagenes_productos` (`producto_id`),
  CONSTRAINT `fk_imagenes_productos` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `imagenes_producto` */

/*Table structure for table `municipio` */

DROP TABLE IF EXISTS `municipio`;

CREATE TABLE `municipio` (
  `id_municipio` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_municipio`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `municipio` */

insert  into `municipio`(`id_municipio`,`nombre`,`estado`,`codigo_postal`) values 
(1,'Acatlán','Hidalgo',NULL),
(2,'Acaxochitlán','Hidalgo',NULL),
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
(16,'Chapulhuacán','Hidalgo','42290'),
(17,'Chilcuautla','Hidalgo','42750'),
(18,'Cuautepec de Hinojosa','Hidalgo','43740'),
(19,'El Arenal','Hidalgo','42680'),
(20,'Eloxochitlán','Hidalgo','43320'),
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
(32,'Jaltocán','Hidalgo','43040'),
(33,'Juárez Hidalgo','Hidalgo','43180'),
(34,'La Misión','Hidalgo','42260'),
(35,'Lolotla','Hidalgo','43140'),
(36,'Metepec','Hidalgo','43400'),
(37,'Metztitlán','Hidalgo','43350'),
(38,'Mineral de la Reforma','Hidalgo','42180'),
(39,'Mineral del Chico','Hidalgo','42120'),
(40,'Mineral del Monte','Hidalgo','42130'),
(41,'Mixquiahuala de Juárez','Hidalgo','42700'),
(42,'Molango de Escamilla','Hidalgo','43160'),
(43,'Nicolás Flores','Hidalgo','42360'),
(44,'Nopala de Villagrán','Hidalgo','42470'),
(45,'Omitlán de Juárez','Hidalgo','42160'),
(46,'Orizatlán','Hidalgo','43020'),
(47,'Pachuca de Soto','Hidalgo','42000'),
(48,'Pacula','Hidalgo','42230'),
(49,'Pisaflores','Hidalgo','42220'),
(50,'Progreso de Obregón','Hidalgo','42730'),
(51,'San Agustín Metzquititlán','Hidalgo','43370'),
(52,'San Agustín Tlaxiaca','Hidalgo','42160'),
(53,'San Bartolo Tutotepec','Hidalgo','43420'),
(54,'San Felipe Orizatlán','Hidalgo','43030'),
(55,'San Salvador','Hidalgo','42640'),
(56,'Santiago de Anaya','Hidalgo','42120'),
(57,'Singuilucan','Hidalgo','42190'),
(58,'Tasquillo','Hidalgo','42360'),
(59,'Tecozautla','Hidalgo','42440'),
(60,'Tenango de Doria','Hidalgo','42120'),
(61,'Tepeapulco','Hidalgo','42120'),
(62,'Tepehuacán de Guerrero','Hidalgo','43130'),
(63,'Tepeji del Río de Ocampo','Hidalgo','42850'),
(64,'Tepetitlán','Hidalgo','42900'),
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
(79,'Xochicoatlán','Hidalgo','43250'),
(80,'Yahualica','Hidalgo','43080'),
(81,'Zacualtipán de Ángeles','Hidalgo','43260'),
(82,'Zapotlán de Juárez','Hidalgo','42140'),
(83,'Zempoala','Hidalgo','43830'),
(84,'Zimapán','Hidalgo','42330');

/*Table structure for table `paciente` */

DROP TABLE IF EXISTS `paciente`;

CREATE TABLE `paciente` (
  `id_paciente` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido_paterno` varchar(50) NOT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `telefono_principal` varchar(20) DEFAULT NULL,
  `telefono_secundario` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `calle` varchar(100) DEFAULT NULL,
  `colonia` varchar(100) DEFAULT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `localidad` varchar(100) DEFAULT NULL,
  `id_municipio` int(11) DEFAULT NULL,
  `alergias` text DEFAULT NULL,
  `notas_medicas` text DEFAULT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_paciente`),
  KEY `id_municipio` (`id_municipio`),
  KEY `idx_paciente_nombre` (`nombre`,`apellido_paterno`),
  CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_municipio`) REFERENCES `municipio` (`id_municipio`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `paciente` */

insert  into `paciente`(`id_paciente`,`nombre`,`apellido_paterno`,`apellido_materno`,`fecha_nacimiento`,`telefono_principal`,`telefono_secundario`,`email`,`calle`,`colonia`,`numero`,`localidad`,`id_municipio`,`alergias`,`notas_medicas`,`fecha_registro`) values 
(8,'Fernando','Gómez','Lara','1990-02-10','5511223301',NULL,'fer.gomez@mail.com','Av. Juárez','Centro','12','Pachuca',47,'Ninguna',NULL,'2026-07-22 07:35:08'),
(9,'Gabriela','Ruiz','Ponce','1985-06-25','5511223302','5522334402','gabriela.ruiz@mail.com','Calle Hidalgo','La Joya','45','Tula',75,'Penicilina','Alérgica a penicilina','2026-07-22 07:35:08'),
(10,'Ricardo','Mora','Castro','1978-11-05','5511223303',NULL,'ricardo.mora@mail.com','Boulevard Independencia','San Miguel','78','Ixmiquilpan',30,'Ninguna','Hipertensión controlada','2026-07-22 07:35:08'),
(11,'Diana','Rivas','Solís','1995-09-15','5511223304','5522334404','diana.rivas@mail.com','Calle Morelos','El Carmen','32','Actopan',3,'Polen',NULL,'2026-07-22 07:35:08'),
(12,'Héctor','Vargas','Méndez','1980-12-20','5511223305',NULL,'hector.vargas@mail.com','Av. Revolución','Los Reyes','56','Huichapan',29,'Ninguna','Diabetes tipo 2','2026-07-22 07:35:08'),
(13,'Leticia guadalupe','Cervantes','Salazar','1992-04-30','554323648736','5522334406','leticia.guadalupe@mail.com','Calle Ignacio Zaragoza','El Mirador','90','Tepeji',63,'Látex','','2026-07-22 07:35:08'),
(14,'Arturo vega','hernandez','hernandez','1988-08-30','5567876423','','arturo.castillo@mail.com','Calle Benito Juárez','La Luz','22','Pachuca',47,'Ninguna','','2026-07-22 07:35:08'),
(15,'Renata','Ochoa','Acosta','1993-07-07','5511223308','5522334408','renata.ochoa@mail.com','Calle 16 de Septiembre','San Pedro','67','Tizayuca',68,'Ninguna','Asma leve','2026-07-22 07:35:08'),
(16,'Edgar','Paredes','Camacho','1983-03-12','5511223309',NULL,'edgar.paredes@mail.com','Calle Miguel Hidalgo','El Rosario','14','Tulancingo',76,'Ninguna','Alergia al polvo','2026-07-22 07:35:08'),
(17,'Claudia','Soto','García','1991-12-01','5511223310','5522334410','claudia.soto@mail.com','Calle 5 de Mayo','San José','9','Tolcayuca',74,'Ninguna',NULL,'2026-07-22 07:35:08'),
(18,'Juan','Pérez','Gómez','1985-03-15','5512345601',NULL,'juan.perez@mail.com','Calle 1','Centro','101','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(19,'María','López','Martínez','1990-07-22','5512345602','5522345602','maria.lopez@mail.com','Calle 2','La Joya','102','Tula',75,'Penicilina','Alérgica a penicilina','2026-07-22 13:02:17'),
(20,'Carlos','Ramírez','García','1982-11-05','5512345603',NULL,'carlos.ramirez@mail.com','Calle 3','San Miguel','103','Ixmiquilpan',30,NULL,'Hipertensión','2026-07-22 13:02:17'),
(21,'Ana','González','Fernández','1995-09-15','5512345604','5522345604','ana.gonzalez@mail.com','Calle 4','El Carmen','104','Actopan',3,'Polen',NULL,'2026-07-22 13:02:17'),
(22,'Luis','Martínez','Rodríguez','1988-12-20','5512345605',NULL,'luis.martinez@mail.com','Calle 5','Los Reyes','105','Huichapan',29,NULL,'Diabetes tipo 2','2026-07-22 13:02:17'),
(23,'Laura','Sánchez','Ruiz','1992-04-18','5512345606','5522345606','laura.sanchez@mail.com','Calle 6','El Mirador','106','Tepeji',63,'Látex',NULL,'2026-07-22 13:02:17'),
(24,'Pedro','Fernández','López','1980-08-30','5512345607',NULL,'pedro.fernandez@mail.com','Calle 7','La Luz','107','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(25,'Marta','García','Martínez','1993-07-07','5512345608','5522345608','marta.garcia@mail.com','Calle 8','San Pedro','108','Tizayuca',68,NULL,'Asma leve','2026-07-22 13:02:17'),
(26,'Raúl','Rodríguez','Gómez','1983-03-12','5512345609',NULL,'raul.rodriguez@mail.com','Calle 9','El Rosario','109','Tulancingo',76,NULL,NULL,'2026-07-22 13:02:17'),
(27,'Sofía','López','Fernández','1991-12-01','5512345610','5522345610','sofia.lopez@mail.com','Calle 10','San José','110','Tolcayuca',74,NULL,NULL,'2026-07-22 13:02:17'),
(28,'mario jose','Gómez','Ramírez','1987-02-10','5512345611','','david.gomez@mail.com','Calle 14','Centro','123','Pachuca',47,'ninguna','','2026-07-22 13:02:17'),
(29,'Elena','Martín','García','1994-06-25','5512345612','5522345612','elena.martin@mail.com','Calle 12','La Joya','112','Tula',75,NULL,NULL,'2026-07-22 13:02:17'),
(30,'Javier','Ruiz','López','1989-10-14','5512345613',NULL,'javier.ruiz@mail.com','Calle 13','San Miguel','113','Ixmiquilpan',30,NULL,NULL,'2026-07-22 13:02:17'),
(31,'Carmen','Fernández','Martínez','1996-01-18','5512345614','5522345614','carmen.fernandez@mail.com','Calle 14','El Carmen','114','Actopan',3,NULL,NULL,'2026-07-22 13:02:17'),
(32,'Manuel','García','Rodríguez','1985-05-22','5512345615',NULL,'manuel.garcia@mail.com','Calle 15','Los Reyes','115','Huichapan',29,NULL,NULL,'2026-07-22 13:02:17'),
(33,'Isabel','López','Sánchez','1990-09-08','5512345616','5522345616','isabel.lopez@mail.com','Calle 16','El Mirador','116','Tepeji',63,NULL,NULL,'2026-07-22 13:02:17'),
(34,'Antonio','Martínez','Gómez','1983-11-22','5512345617',NULL,'antonio.martinez@mail.com','Calle 17','La Luz','117','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(35,'Patricia','Sánchez','López','1995-04-12','5512345618','5522345618','patricia.sanchez@mail.com','Calle 18','San Pedro','118','Tizayuca',68,NULL,NULL,'2026-07-22 13:02:17'),
(36,'Francisco','Gómez','Martín','1982-08-01','5512345619',NULL,'francisco.gomez@mail.com','Calle 19','El Rosario','119','Tulancingo',76,NULL,NULL,'2026-07-22 13:02:17'),
(37,'Rosa','Fernández','Ruiz','1993-02-19','5512345620','5522345620','rosa.fernandez@mail.com','Calle 20','San José','120','Tolcayuca',74,NULL,NULL,'2026-07-22 13:02:17'),
(38,'José','Ramírez','García','1986-07-05','5512345621',NULL,'jose.ramirez@mail.com','Calle 21','Centro','121','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(39,'Dolores','Martín','López','1991-11-16','5512345622','5522345622','dolores.martin@mail.com','Calle 22','La Joya','122','Tula',75,NULL,NULL,'2026-07-22 13:02:17'),
(40,'Ángel','Ruiz','García','1988-03-27','5512345623',NULL,'angel.ruiz@mail.com','Calle 23','San Miguel','123','Ixmiquilpan',30,NULL,NULL,'2026-07-22 13:02:17'),
(41,'Mercedes','Sánchez','Fernández','1992-12-06','5512345624','5522345624','mercedes.sanchez@mail.com','Calle 24','El Carmen','124','Actopan',3,NULL,NULL,'2026-07-22 13:02:17'),
(42,'Rafael','García','Martínez','1981-04-30','5512345625',NULL,'rafael.garcia@mail.com','Calle 25','Los Reyes','125','Huichapan',29,NULL,NULL,'2026-07-22 13:02:17'),
(43,'Esther','López','Gómez','1997-10-24','5512345626','5522345626','esther.lopez@mail.com','Calle 26','El Mirador','126','Tepeji',63,NULL,NULL,'2026-07-22 13:02:17'),
(44,'Juan Carlos','Martínez','Ruiz','1984-05-19','5512345627',NULL,'juancarlos.martinez@mail.com','Calle 27','La Luz','127','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(45,'Ana María','López','Martín','1998-08-03','5512345628','5522345628','anamaria.lopez@mail.com','Calle 28','San Pedro','128','Tizayuca',68,NULL,NULL,'2026-07-22 13:02:17'),
(46,'Miguel','García','Sánchez','1980-01-12','5512345629',NULL,'miguel.garcia@mail.com','Calle 29','El Rosario','129','Tulancingo',76,NULL,NULL,'2026-07-22 13:02:17'),
(47,'Lucía','Fernández','Gómez','1993-06-09','5512345630','5522345630','lucia.fernandez@mail.com','Calle 30','San José','130','Tolcayuca',74,NULL,NULL,'2026-07-22 13:02:17'),
(48,'Tomás','Sánchez','López','1987-09-02','5512345631',NULL,'tomas.sanchez@mail.com','Calle 31','Centro','131','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(49,'Margarita','Ruiz','García','1996-11-29','5512345632','5522345632','margarita.ruiz@mail.com','Calle 32','La Joya','132','Tula',75,NULL,NULL,'2026-07-22 13:02:17'),
(50,'Vicente','Martín','Martínez','1989-02-14','5512345633',NULL,'vicente.martin@mail.com','Calle 33','San Miguel','133','Ixmiquilpan',30,NULL,NULL,'2026-07-22 13:02:17'),
(51,'Rocío','García','Ruiz','1992-07-20','5512345634','5522345634','rocio.garcia@mail.com','Calle 34','El Carmen','134','Actopan',3,NULL,NULL,'2026-07-22 13:02:17'),
(52,'Pedro Pablo','López','Sánchez','1984-12-05','5512345635',NULL,'pedropablo.lopez@mail.com','Calle 35','Los Reyes','135','Huichapan',29,NULL,NULL,'2026-07-22 13:02:17'),
(53,'María Isabel','Fernández','Gómez','1995-03-18','5512345636','5522345636','mariaisabel.fernandez@mail.com','Calle 36','El Mirador','136','Tepeji',63,NULL,NULL,'2026-07-22 13:02:17'),
(54,'Jesús','Sánchez','López','1983-08-08','5512345637',NULL,'jesus.sanchez@mail.com','Calle 37','La Luz','137','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(55,'Cristina','Gómez','Martín','1991-04-15','5512345638','5522345638','cristina.gomez@mail.com','Calle 38','San Pedro','138','Tizayuca',68,NULL,NULL,'2026-07-22 13:02:17'),
(56,'Alejandro','Ruiz','García','1986-10-25','5512345639',NULL,'alejandro.ruiz@mail.com','Calle 39','El Rosario','139','Tulancingo',76,NULL,NULL,'2026-07-22 13:02:17'),
(57,'Eva','Martínez','Fernández','1993-12-13','5512345640','5522345640','eva.martinez@mail.com','Calle 40','San José','140','Tolcayuca',74,NULL,NULL,'2026-07-22 13:02:17'),
(58,'Rubén','López','Ruiz','1988-06-21','5512345641',NULL,'ruben.lopez@mail.com','Calle 41','Centro','141','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(59,'Paloma','García','Sánchez','1992-09-07','5512345642','5522345642','paloma.garcia@mail.com','Calle 42','La Joya','142','Tula',75,NULL,NULL,'2026-07-22 13:02:17'),
(60,'Sergio','Martín','López','1981-01-30','5512345643',NULL,'sergio.martin@mail.com','Calle 43','San Miguel','143','Ixmiquilpan',30,NULL,NULL,'2026-07-22 13:02:17'),
(61,'Alicia','Sánchez','Gómez','1995-05-11','5512345644','5522345644','alicia.sanchez@mail.com','Calle 44','El Carmen','144','Actopan',3,NULL,NULL,'2026-07-22 13:02:17'),
(62,'David Alejandro','Ruiz','Martínez','1987-11-19','5512345645',NULL,'davidalejandro.ruiz@mail.com','Calle 45','Los Reyes','145','Huichapan',29,NULL,NULL,'2026-07-22 13:02:17'),
(63,'María José','López','Fernández','1994-06-08','5512345646','5522345646','mariajose.lopez@mail.com','Calle 46','El Mirador','146','Tepeji',63,NULL,NULL,'2026-07-22 13:02:17'),
(64,'José Antonio','García','Martín','1982-02-17','5512345647',NULL,'joseantonio.garcia@mail.com','Calle 47','La Luz','147','Pachuca',47,NULL,NULL,'2026-07-22 13:02:17'),
(65,'Silvia','Martínez','Ruiz','1996-08-30','5512345648','5522345648','silvia.martinez@mail.com','Calle 48','San Pedro','148','Tizayuca',68,NULL,NULL,'2026-07-22 13:02:17'),
(66,'Gerardo','Gómez','López','1989-03-04','5512345649',NULL,'gerardo.gomez@mail.com','Calle 49','El Rosario','149','Tulancingo',76,NULL,NULL,'2026-07-22 13:02:17'),
(67,'Lidia','Fernández','Ruiz','1993-10-16','5512345650','5522345650','lidia.fernandez@mail.com','Calle 50','San José','15','Tolcayuca',74,'Ninguna','Ninguna','2026-07-22 13:02:17'),
(68,'carlos','Perez','hernandez','2019-06-11','5121222211',NULL,'casrlo78@gmail.com','sn','sn','09','huejutla',23,'ninguna','ok','2026-07-31 11:28:51'),
(69,'juan','hdez','martinez','2026-07-31','7711145524','7744455511','juan12@gmail.com','sn','sn','5','la cruz de zocuiteco',15,'sin alergias','Ok','2026-07-31 12:25:49'),
(70,'juan','perez','hernandez','2026-07-31','7723456742','7766928392','juan15625@gmail.com','sn','sn','74','huejutla',23,'ninguna','ninguna','2026-07-31 12:30:59'),
(74,'ronaldo','hernandez','hernandez','2005-12-15','3751110994','','rony@gmail.com','san pablo','san pablo','5','san pablo',23,'ninguna','ninguna','2026-08-02 21:02:29'),
(75,'Alejandra','Ruiz','García','1986-10-24','5577987347','','alejandro.ruiz@mail.com','Calle 39','El Rosario','139','Tulancingo',76,'ninguna','','2026-08-02 23:24:33'),
(76,'luis','Fernández','perez','1993-06-09','5512345630','5522345630','lucia.fernandez@mail.com','Calle 30','San José','240','Tolcayuca',76,'ninguna','','2026-08-02 23:26:21'),
(77,'juan','hernandez','hernandez','1988-08-25','5511223307','','arturo.castillo@mail.com','Calle Benito Juárez','La cruz','14','Pachuca',47,'Ninguna','','2026-08-02 23:29:51'),
(78,'José Antoni','Ramírez','hernandez','1986-07-17','8853795243','','jose.ramirez@mail.com','Calle 21','Centro','77','Pachuca',47,'ninguna','','2026-08-02 23:32:21'),
(79,'Eva maaria','Martínez','Hernández','1993-12-13','5512345875','5522345640','eva.martinez@mail.com','Calle 40','San José','140','Tolcayuca',74,'ninguna','','2026-08-02 23:34:44');

/*Table structure for table `productos` */

DROP TABLE IF EXISTS `productos`;

CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `url_imagen_principal` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_productos_categorias` (`categoria_id`),
  CONSTRAINT `fk_productos_categorias` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `productos` */

/*Table structure for table `rol` */

DROP TABLE IF EXISTS `rol`;

CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `rol` */

insert  into `rol`(`id_rol`,`nombre`,`descripcion`) values 
(1,'Administrador','Acceso total al sistema'),
(2,'Asistente','Gestión de citas y pacientes'),
(3,'Doctor','Consulta de agenda y pacientes');

/*Table structure for table `tbl_alumnos` */

DROP TABLE IF EXISTS `tbl_alumnos`;

CREATE TABLE `tbl_alumnos` (
  `matricula` varchar(30) NOT NULL,
  `correo` varchar(150) NOT NULL,
  PRIMARY KEY (`matricula`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tbl_alumnos` */

/*Table structure for table `tbl_carrera` */

DROP TABLE IF EXISTS `tbl_carrera`;

CREATE TABLE `tbl_carrera` (
  `idCarrera` int(11) NOT NULL AUTO_INCREMENT,
  `nombreCarrera` varchar(150) NOT NULL,
  PRIMARY KEY (`idCarrera`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tbl_carrera` */

insert  into `tbl_carrera`(`idCarrera`,`nombreCarrera`) values 
(1,'NEGOCIOS Y MERCADOTECNIA'),
(2,'INGENIERÍA MECÁNICA'),
(3,'GASTRONOMÍA'),
(4,'ADMINISTRACIÓN'),
(5,'CONTADURÍA'),
(6,'INGENIERÍA EN TECNOLOGÍAS DE LA INFORMACIÓN E INNOVACIÓN DIGITAL'),
(7,'INGENIERÍA CIVIL'),
(8,'INGENIERÍA EN AGROBIOTECNOLOGÍA'),
(9,'INGENIERÍA EN ALIMENTOS'),
(10,'INGENIERÍA MECATRÓNICA');

/*Table structure for table `tbl_curso` */

DROP TABLE IF EXISTS `tbl_curso`;

CREATE TABLE `tbl_curso` (
  `codigo_curso` varchar(30) NOT NULL,
  `titulo_curso` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `espacio` varchar(100) DEFAULT NULL,
  `total_horas` int(11) DEFAULT NULL,
  `dias_atencion` varchar(100) DEFAULT NULL,
  `horas_atencion` varchar(100) DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `ruta_img_grid` varchar(255) DEFAULT NULL,
  `ruta_img_bg` varchar(255) DEFAULT NULL,
  `idCarrera` int(11) NOT NULL,
  PRIMARY KEY (`codigo_curso`),
  KEY `fk_curso_carrera` (`idCarrera`),
  CONSTRAINT `fk_curso_carrera` FOREIGN KEY (`idCarrera`) REFERENCES `tbl_carrera` (`idCarrera`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tbl_curso` */

insert  into `tbl_curso`(`codigo_curso`,`titulo_curso`,`descripcion`,`espacio`,`total_horas`,`dias_atencion`,`horas_atencion`,`capacidad`,`ruta_img_grid`,`ruta_img_bg`,`idCarrera`) values 
('ADM101','GESTIÓN DE TALENTO HUMANO','Estrategias de reclutamiento, selección y desarrollo organizacional.','Edificio B, Salón 301',40,'Lunes y Miércoles','10:00 - 12:00 hrs',50,'img/rrhh_grid.jpg','img/rrhh_bg.jpg',4),
('AGR101','BIOTECNOLOGÍA VEGETAL','Mejoramiento genético de cultivos y técnicas de cultivo in vitro.','Laboratorio de Agrobiología',60,'Viernes','08:00 - 14:00 hrs',25,'img/agro_grid.jpg','img/agro_bg.jpg',8),
('ALI101','INOCUIDAD ALIMENTARIA','Normativas de higiene, HACCP y control de calidad en la industria alimentaria.','Laboratorio de Alimentos',40,'Martes y Jueves','11:00 - 13:00 hrs',30,'img/alimentos_grid.jpg','img/alimentos_bg.jpg',9),
('CIV101','RESISTENCIA DE MATERIALES','Análisis de esfuerzos y deformaciones en estructuras.','Laboratorio de Materiales',80,'Lunes a Jueves','09:00 - 11:00 hrs',35,'img/civil_grid.jpg','img/civil_bg.jpg',7),
('CON101','CONTABILIDAD FINANCIERA','Registro y análisis de operaciones financieras bajo normativas vigentes.','Edificio B, Salón 205',60,'Martes y Jueves','14:00 - 16:00 hrs',45,'img/conta_grid.jpg','img/conta_bg.jpg',5),
('GAS101','COCINA MEXICANA TRADICIONAL','Preparación de platillos típicos, técnicas culinarias y uso de ingredientes autóctonos.','Cocina Principal',60,'Martes y Jueves','08:00 - 12:00 hrs',25,'img/cocinamex_grid.jpg','img/cocinamex_bg.jpg',3),
('GAS102','PANADERÍA Y REPOSTERÍA','Elaboración de masas, panes artesanales y postres finos.','Cocina de Repostería',40,'Sábado','09:00 - 13:00 hrs',20,'img/pan_grid.jpg','img/pan_bg.jpg',3),
('IST102','PROGRAMACIÓN AVANZADA','La programación estructurada microservicios de programas, crece por programación estándar, mediante el desarrollo de una aplicación informática.','Edificio C, Salón C-101',80,'Lunes, Miércoles, Viernes','10:00 - 12:00 hrs',50,'img/programacion_grid.jpg','img/programacion_bg.jpg',6),
('IST201','BASES DE DATOS II','Diseño e implementación de bases de datos relacionales y no relacionales, optimización de consultas y gestión de transacciones.','Edificio C, Salón A-102',64,'Martes y Jueves','08:00 - 10:00 hrs',50,'img/bd_grid.jpg','img/bd_bg.jpg',6),
('IST204','REDES DE COMPUTADORAS','Configuración de infraestructura de red, protocolos TCP/IP, enrutamiento y seguridad informática perimetral.','Edificio C, Salón A-102',64,'Viernes','10:00 - 14:00 hrs',50,'img/redes_grid.jpg','img/redes_bg.jpg',6),
('IST305','INTELIGENCIA ARTIFICIAL','Fundamentos de machine learning, redes neuronales y procesamiento de lenguaje natural aplicados a la solución de problemas reales.','Edificio C, Salón B-201',80,'Lunes y Miércoles','14:00 - 16:00 hrs',40,'img/ia_grid.jpg','img/ia_bg.jpg',6),
('MCT101','ROBÓTICA INDUSTRIAL','Programación de brazos robóticos y automatización de procesos.','Laboratorio de Mecatrónica',80,'Lunes, Miércoles y Viernes','15:00 - 17:00 hrs',30,'img/robotica_grid.jpg','img/robotica_bg.jpg',10),
('MEC101','TERMODINÁMICA','Estudio de la energía, calor y trabajo en sistemas mecánicos.','Taller Mecánico, Salón T-1',80,'Lunes a Jueves','07:00 - 09:00 hrs',30,'img/termo_grid.jpg','img/termo_bg.jpg',2),
('MEC102','MECÁNICA DE FLUIDOS','Comportamiento de líquidos y gases en reposo y movimiento.','Taller Mecánico, Salón T-2',64,'Viernes','08:00 - 14:00 hrs',30,'img/fluidos_grid.jpg','img/fluidos_bg.jpg',2),
('MER101','MARKETING DIGITAL','Estrategias de posicionamiento en redes sociales, SEO y campañas publicitarias en línea.','Edificio A, Salón 101',40,'Lunes y Miércoles','09:00 - 11:00 hrs',45,'img/marketing_grid.jpg','img/marketing_bg.jpg',1),
('MER102','INVESTIGACIÓN DE MERCADOS','Metodologías cuantitativas y cualitativas para el análisis del consumidor.','Edificio A, Salón 102',40,'Martes y Jueves','11:00 - 13:00 hrs',35,'img/mercados_grid.jpg','img/mercados_bg.jpg',1);

/*Table structure for table `tbl_inscripciones` */

DROP TABLE IF EXISTS `tbl_inscripciones`;

CREATE TABLE `tbl_inscripciones` (
  `id_inscripcion` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_curso` varchar(30) NOT NULL,
  `matricula` varchar(30) NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_inscripcion`),
  UNIQUE KEY `uq_inscripcion_unica` (`codigo_curso`,`matricula`),
  KEY `fk_inscripcion_alumno` (`matricula`),
  CONSTRAINT `fk_inscripcion_alumno` FOREIGN KEY (`matricula`) REFERENCES `tbl_alumnos` (`matricula`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_inscripcion_curso` FOREIGN KEY (`codigo_curso`) REFERENCES `tbl_curso` (`codigo_curso`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tbl_inscripciones` */

/*Table structure for table `usuario` */

DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `ultimo_acceso` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `usuario` (`usuario`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `usuario` */

insert  into `usuario`(`id_usuario`,`usuario`,`contrasena`,`id_rol`,`ultimo_acceso`,`activo`) values 
(1,'admin','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',1,'2026-08-05 14:11:24',1),
(2,'asistente','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,'2026-08-04 13:06:26',1),
(3,'doctor','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',3,'2026-08-03 04:52:40',1),
(17,'drmartinez','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4',3,'2026-07-20 20:44:37',0),
(18,'mfernandez','2ecbd613111342530a35f0a5ab8141ec44a6a6d10f0211e51a0d255c7422aab7',3,'2026-08-04 08:44:35',1),
(19,'yo','e9058ab198f6908f702111b0c0fb5b36f99d00554521886c40e2891b349dc7a1',3,'2026-10-01 14:24:57',1),
(20,'drDamian','e9058ab198f6908f702111b0c0fb5b36f99d00554521886c40e2891b349dc7a1',3,'2026-07-30 20:11:22',0),
(21,'ronaldito','a0deb15a7ba486eaaa2b702f4d954f93c3decb0dcd0ac96cb8d2e9a18b8cb06c',3,NULL,0),
(22,'frank','2e51672858831d330326f5bbd72a42848314e6d6a35b5b75670b1e602fa04f3d',3,'2026-07-21 19:47:06',0),
(23,'dr.lopez','a1e0e955af49a59b69c5ae09a7bf954a5047ce646eb83a2468a725c7d3dc1a16',3,'2026-08-04 08:43:17',1),
(24,'dr.garcia','b974ebb9a97901339d70cbd59a98baeb15228d9f39e326d41014aa938512c4e9',3,'2026-08-03 07:33:50',1),
(25,'dr.rodriguez','cc8844298c08e2fb7ba75080b9fad6fbd23d63bf3534c713e87ad87cee8f5b57',3,'2026-07-30 20:26:53',1),
(26,'dr.martinez','51609286fb7f6089e0a0a418355949c791e84870ae2523093ba00bb3ecff7f8e',3,'2026-08-04 08:38:32',1),
(27,'dr.hernandez','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',3,NULL,1),
(28,'dr.gonzalez','5e0e5ddfda4ae91bad2a92d306c574eee3f3bd33516632e75b3af4bd99388d89',3,'2026-08-02 19:46:44',1),
(29,'dr.perez','b427c3dec9045990213ccc3dbffbdf189e75c7ce18e1a86ed7c4fe9a2db5d627',3,'2026-08-03 07:28:03',1),
(30,'dr.sanchez','6b9cd7872ae634539ea1a99e1c4c16b41c9314c99192560ecf9c4bb846647655',3,'2026-08-01 14:00:42',0),
(31,'dr.ramirez','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',3,NULL,1),
(32,'dr.flores','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',3,NULL,1),
(33,'asist.luna','970ec274ca867815174ebe4eff19282000f9495a6c7254e94991d1fb4dc3df30',2,'2026-08-18 16:50:23',1),
(34,'asist.diaz','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,1),
(35,'asist.ortiz','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,1),
(36,'asist.mendoza','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,1),
(37,'asist.cruz','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,1),
(38,'asist.reyes','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,0),
(39,'asist.morales','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,1),
(40,'asist.romero','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,0),
(41,'asist.torres','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,0),
(42,'asist.gutierrez','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',2,NULL,1),
(43,'no','e9058ab198f6908f702111b0c0fb5b36f99d00554521886c40e2891b349dc7a1',3,NULL,0),
(45,'rony','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4',2,NULL,0),
(46,'fabi','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',2,NULL,1),
(48,'art','d3cec99112255db9bf4963f7798562b6a36f1bd0b2016918629e007d474deb70',3,NULL,0),
(49,'pablo','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4',3,NULL,0);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
