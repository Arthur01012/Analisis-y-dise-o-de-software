-- =====================================================================
-- Script de Limpieza / Eliminación de Datos de Prueba
-- Base de Datos: innegone_bd_medicdate
-- Esquema: Version 2.1 Normalizada (3FN)
-- Borra únicamente registros transaccionales y de prueba, respetando
-- los catálogos base estructurales (roles, municipios y centro médico).
-- =====================================================================

USE `innegone_bd_medicdate`;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `historial_cita`;
TRUNCATE TABLE `notificacion`;
TRUNCATE TABLE `cita`;
TRUNCATE TABLE `bloqueo_horario`;
TRUNCATE TABLE `horario_atencion`;
TRUNCATE TABLE `doctor_especialidad`;
TRUNCATE TABLE `doctor`;
TRUNCATE TABLE `asistente`;
TRUNCATE TABLE `empleado`;
TRUNCATE TABLE `paciente`;
TRUNCATE TABLE `direccion`;
TRUNCATE TABLE `usuario_pregunta_secreta`;
TRUNCATE TABLE `usuario_rol`;
TRUNCATE TABLE `sesion_usuario`;
TRUNCATE TABLE `token_recuperacion`;
TRUNCATE TABLE `usuario`;
TRUNCATE TABLE `persona`;
TRUNCATE TABLE `resena`;
TRUNCATE TABLE `hero_slide`;
TRUNCATE TABLE `pregunta_frecuente`;
TRUNCATE TABLE `contenido_informativo`;
TRUNCATE TABLE `tipo_atencion`;
TRUNCATE TABLE `consultorio`;
TRUNCATE TABLE `especialidad`;
TRUNCATE TABLE `auditoria`;

SET FOREIGN_KEY_CHECKS = 1;
