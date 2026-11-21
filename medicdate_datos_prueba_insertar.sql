-- =====================================================================
-- Script de Datos de Prueba Funcionales (Trabajadores y Pacientes)
-- Base de Datos: innegone_bd_medicdate
-- Esquema: Version 2.1 Normalizada (3FN)
-- Contraseña para todas las cuentas de prueba: "Prueba123!"
-- Hash Bcrypt: $2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y
-- =====================================================================

USE `innegone_bd_medicdate`;

START TRANSACTION;

-- 1. CATALOGOS CLINICOS: ESPECIALIDADES, CONSULTORIOS Y TIPOS DE ATENCION
INSERT INTO `especialidad` (`id_especialidad`, `nombre`, `resumen`, `descripcion`, `activo`) VALUES
  (1, 'Medicina General', 'Atención primaria, chequeos de salud y medicina familiar preventiva.', 'Especialidad dedicada al cuidado integral del paciente en todas las etapas.', 1),
  (2, 'Cardiología', 'Evaluación, diagnóstico y control de patologías cardíacas e hipertensión.', 'Tratamiento avanzado de arritmias, insuficiencia cardíaca y riesgo cardiovascular.', 1),
  (3, 'Pediatría', 'Cuidado integral y monitoreo del desarrollo infantil y del adolescente.', 'Control de niño sano, vacunación y seguimiento pediátrico.', 1),
  (4, 'Dermatología', 'Diagnóstico y tratamiento de afecciones de piel, cabello y uñas.', 'Atención especializada de dermatitis, acné y control de lunares.', 1)
ON DUPLICATE KEY UPDATE `resumen` = VALUES(`resumen`), `descripcion` = VALUES(`descripcion`);

INSERT INTO `consultorio` (`id_consultorio`, `codigo`, `nombre`, `descripcion`, `activo`) VALUES
  (1, 'CONS-101', 'Consultorio 101 - Medicina Familiar', 'Planta Baja, equipado para atención primaria.', 1),
  (2, 'CONS-102', 'Consultorio 102 - Cardiología', 'Primer Piso, incluye electrocardiógrafo digital.', 1),
  (3, 'CONS-103', 'Consultorio 103 - Pediatría', 'Planta Baja, área ambientada para infantes.', 1),
  (4, 'CONS-104', 'Consultorio 104 - Dermatología', 'Primer Piso, instrumental dermatológico completo.', 1)
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`), `descripcion` = VALUES(`descripcion`);

INSERT INTO `tipo_atencion` (`id_tipo_atencion`, `id_especialidad`, `nombre`, `resumen`, `descripcion`, `duracion_minutos`, `costo_base`, `moneda`, `orden`, `activo`, `publicado_web`) VALUES
  (1, 1, 'Consulta de Medicina General', 'Evaluación clínica integral y diagnóstico de primer contacto.', 'Consulta de valoración médica general y prescripción de tratamiento.', 30, 350.00, 'MXN', 1, 1, 1),
  (2, 1, 'Chequeo Preventivo Anual', 'Revisión médica completa y tamizaje preventivo anual.', 'Examen físico detallado, toma de signos y solicitud de analíticas preventivas.', 45, 500.00, 'MXN', 2, 1, 1),
  (3, 2, 'Consulta Cardiológica con ECG', 'Valoración especializada con electrocardiograma en reposo.', 'Consulta con especialista cardiólogo, incluye reporte de ECG e interpretación.', 45, 750.00, 'MXN', 3, 1, 1),
  (4, 2, 'Control de Hipertensión', 'Seguimiento periódico y ajuste farmacológico de presión arterial.', 'Monitoreo de cifras tensionales y evaluación de apego al tratamiento.', 30, 600.00, 'MXN', 4, 1, 1),
  (5, 3, 'Control de Niño Sano', 'Monitoreo de percentiles de crecimiento y desarrollo pediátrico.', 'Evaluación integral de peso, talla, hitos del desarrollo y vacunación.', 30, 450.00, 'MXN', 5, 1, 1),
  (6, 4, 'Consulta Dermatológica', 'Evaluación clínica de patologías de piel, pelo y uñas.', 'Revisión especializada de lesiones cutáneas y tratamiento personalizado.', 30, 650.00, 'MXN', 6, 1, 1)
ON DUPLICATE KEY UPDATE `costo_base` = VALUES(`costo_base`), `duracion_minutos` = VALUES(`duracion_minutos`);

-- 2. PERSONAS (TRABAJADORES Y PACIENTES)
INSERT INTO `persona` (`id_persona`, `nombres`, `apellido_paterno`, `apellido_materno`, `fecha_nacimiento`, `correo_contacto`, `telefono_principal`, `telefono_secundario`) VALUES
  (1, 'Carlos', 'Vega', 'Mendoza', '1985-04-12', 'carlos.vega.admin@medicdate.com', '7711000001', '7711000002'),
  (2, 'Jose Manuel', 'Rodriguez', 'Lopez', '1980-05-14', 'jose.rodriguez.doc@example.test', '5550000001', NULL),
  (3, 'Sofia', 'Flores', 'Reyes', '1987-10-25', 'sofia.flores.doc@medicdate.com', '5550000002', NULL),
  (4, 'Luna Aurora', 'Reyes', 'Morales', '1995-04-18', 'luna.reyes.asistente@example.test', '5550000003', NULL),
  (5, 'Ronaldo', 'Hernandez', 'Hernandez', '1998-07-21', 'ronaldo@gmail.com', '7711008968', NULL),
  (6, 'Maria', 'Lopez', 'Martinez', '1992-06-15', 'maria.lopez@example.com', '5512345602', '5522345602'),
  (7, 'Juan', 'Perez', 'Garcia', '1985-03-10', 'juan.perez@example.com', '5512345678', NULL)
ON DUPLICATE KEY UPDATE `telefono_principal` = VALUES(`telefono_principal`);

-- 3. DOMICILIOS NORMALIZADOS EN DIRECCION
INSERT INTO `direccion` (`id_persona`, `calle`, `numero`, `colonia`, `localidad`, `id_municipio`, `codigo_postal`, `referencia`) VALUES
  (1, 'Av. Revolución', '105', 'Periodistas', 'Pachuca', 47, '42060', 'Frente al parque Hidalgo'),
  (2, 'Calle Benito Juárez', '45', 'Centro', 'Pachuca', 47, '42000', 'A media cuadra del Reloj'),
  (3, 'Blvd. Colosio', '1200', 'El Palmar', 'Pachuca', 47, '42088', 'Torre Médica A'),
  (4, 'Calle Hidalgo', '23', 'La Joya', 'Mineral de la Reforma', 38, '42180', 'Casa verde'),
  (5, 'Calle 5 de Mayo', '78', 'Centro', 'Tulancingo', 76, '43600', 'Entre Morelos y Zaragoza'),
  (6, 'Av. Nacional', '12', 'San Miguel', 'Actopan', 3, '42300', 'Junto a farmacia'),
  (7, 'Calle Morelos', '34', 'El Carmen', 'Tula de Allende', 75, '42800', 'Frente a escuela primaria')
ON DUPLICATE KEY UPDATE `calle` = VALUES(`calle`);

-- 4. CUENTAS DE USUARIO Y ASIGNACION DE ROLES
INSERT INTO `usuario` (`id_usuario`, `id_persona`, `correo_acceso`, `password_hash`, `estado`, `cambio_password_obligatorio`) VALUES
  (1, 1, 'carlos.vega.admin@medicdate.com', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0),
  (2, 2, 'jose.rodriguez.doc@example.test', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0),
  (3, 3, 'sofia.flores.doc@medicdate.com', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0),
  (4, 4, 'luna.reyes.asistente@example.test', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0),
  (5, 5, 'ronaldo@gmail.com', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0),
  (6, 6, 'maria.lopez@example.com', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0),
  (7, 7, 'juan.perez@example.com', '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y', 'activa', 0)
ON DUPLICATE KEY UPDATE `password_hash` = VALUES(`password_hash`);

INSERT INTO `usuario_rol` (`id_usuario`, `id_rol`) VALUES
  (1, 1), -- Admin
  (2, 3), -- Medico
  (3, 3), -- Medico
  (4, 2), -- Asistente
  (5, 4), -- Paciente
  (6, 4), -- Paciente
  (7, 4)  -- Paciente
ON DUPLICATE KEY UPDATE `fecha_asignacion` = CURRENT_TIMESTAMP;

-- 5. PREGUNTAS SECRETAS DE USUARIO (Respuesta SHA-256 de 'pelusa')
SET @hash_pelusa = SHA2('pelusa', 256);
INSERT INTO `usuario_pregunta_secreta` (`id_usuario`, `id_pregunta_secreta`, `respuesta_hash`) VALUES
  (1, 1, @hash_pelusa),
  (2, 1, @hash_pelusa),
  (4, 1, @hash_pelusa),
  (5, 1, @hash_pelusa),
  (6, 1, @hash_pelusa)
ON DUPLICATE KEY UPDATE `respuesta_hash` = VALUES(`respuesta_hash`);

-- 6. EMPLEADOS, ASISTENTE Y DOCTORES
INSERT INTO `empleado` (`id_empleado`, `id_persona`, `curp`, `fecha_contratacion`, `estado`) VALUES
  (1, 1, 'VEMC850412HDFRRL01', '2024-01-15', 'activo'),
  (2, 2, 'ROLJ800514HDFRPN02', '2024-02-01', 'activo'),
  (3, 3, 'FLRS871025MDFRPN10', '2024-03-01', 'activo'),
  (4, 4, 'REML950418MDFRPN11', '2024-04-01', 'activo')
ON DUPLICATE KEY UPDATE `estado` = VALUES(`estado`);

INSERT INTO `asistente` (`id_empleado`, `turno`) VALUES
  (4, 'Matutino')
ON DUPLICATE KEY UPDATE `turno` = VALUES(`turno`);

INSERT INTO `doctor` (`id_empleado`, `cedula_profesional`, `descripcion_publica`, `foto_ruta`, `publicado`) VALUES
  (2, 'CED-PRUEBA-JMR-2026', 'Médico General y Familiar con 12 años de trayectoria en medicina preventiva y salud comunitaria.', 'uploads/doctores/doc_rodriguez.jpg', 1),
  (3, 'CED-PRUEBA-SFR-2026', 'Especialista en Cardiología Clínica egresada del Instituto Nacional de Cardiología.', 'uploads/doctores/doc_flores.jpg', 1)
ON DUPLICATE KEY UPDATE `descripcion_publica` = VALUES(`descripcion_publica`);

INSERT INTO `doctor_especialidad` (`id_empleado`, `id_especialidad`) VALUES
  (2, 1), -- Dr. Rodriguez -> Medicina General
  (3, 2)  -- Dra. Flores -> Cardiologia
ON DUPLICATE KEY UPDATE `id_especialidad` = VALUES(`id_especialidad`);

-- 7. HORARIOS DE ATENCION Y BLOQUEO DE AGENDA
INSERT INTO `horario_atencion` (`id_empleado`, `id_consultorio`, `dia_semana`, `hora_inicio`, `hora_fin`, `intervalo_minutos`, `vigencia_desde`, `vigencia_hasta`, `activo`) VALUES
  (2, 1, 1, '09:00:00', '17:00:00', 30, '2026-01-01', NULL, 1),
  (2, 1, 2, '09:00:00', '17:00:00', 30, '2026-01-01', NULL, 1),
  (2, 1, 3, '09:00:00', '17:00:00', 30, '2026-01-01', NULL, 1),
  (2, 1, 4, '09:00:00', '17:00:00', 30, '2026-01-01', NULL, 1),
  (2, 1, 5, '09:00:00', '17:00:00', 30, '2026-01-01', NULL, 1),
  (3, 2, 1, '10:00:00', '18:00:00', 45, '2026-01-01', NULL, 1),
  (3, 2, 3, '10:00:00', '18:00:00', 45, '2026-01-01', NULL, 1),
  (3, 2, 5, '10:00:00', '18:00:00', 45, '2026-01-01', NULL, 1);

INSERT INTO `bloqueo_horario` (`id_empleado`, `id_consultorio`, `inicio`, `fin`, `motivo`, `id_usuario_registro`) VALUES
  (2, 1, DATE_ADD(NOW(), INTERVAL 14 DAY), DATE_ADD(DATE_ADD(NOW(), INTERVAL 14 DAY), INTERVAL 2 HOUR), 'Capacitación médica continua', 1);

-- 8. PACIENTES
INSERT INTO `paciente` (`id_paciente`, `id_persona`, `alergias`, `notas_medicas`, `estado`) VALUES
  (1, 5, 'Ninguna conocida.', 'Chequeo periódico de rutina.', 'activo'),
  (2, 6, 'Alérgica a penicilina y sulfas.', 'Monitoreo de presión arterial y perfil lipídico.', 'activo'),
  (3, 7, 'Alergia estacional a polen y polvo.', 'Control asmático leve bajo inhalador.', 'activo')
ON DUPLICATE KEY UPDATE `estado` = VALUES(`estado`);

-- 9. CITAS MEDICAS, HISTORIAL Y NOTIFICACIONES
SET @proximo_habil = DATE_ADD(CURDATE(), INTERVAL (7 - WEEKDAY(CURDATE())) DAY);

INSERT INTO `cita` (`id_cita`, `id_paciente`, `id_empleado`, `id_consultorio`, `id_tipo_atencion`, `inicio`, `fin`, `estado`, `canal_registro`, `motivo`, `costo`, `moneda`, `id_usuario_registro`) VALUES
  (1, 1, 2, 1, 1, TIMESTAMP(@proximo_habil, '09:30:00'), TIMESTAMP(@proximo_habil, '10:00:00'), 'confirmada', 'movil', 'Dolor lumbar leve y revisión de análisis', 350.00, 'MXN', 5),
  (2, 2, 3, 2, 3, TIMESTAMP(DATE_ADD(@proximo_habil, INTERVAL 2 DAY), '10:45:00'), TIMESTAMP(DATE_ADD(@proximo_habil, INTERVAL 2 DAY), '11:30:00'), 'confirmada', 'web', 'Chequeo cardiológico anual preventivo', 750.00, 'MXN', 4),
  (3, 3, 2, 1, 1, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 7 DAY), INTERVAL 30 MINUTE), 'completada', 'escritorio', 'Revisión de vías respiratorias', 350.00, 'MXN', 1)
ON DUPLICATE KEY UPDATE `estado` = VALUES(`estado`);

INSERT INTO `historial_cita` (`id_cita`, `id_usuario`, `estado_anterior`, `estado_nuevo`, `accion`, `observacion`) VALUES
  (1, 5, NULL, 'confirmada', 'creacion', 'Cita registrada vía móvil.'),
  (2, 4, NULL, 'confirmada', 'creacion', 'Cita registrada vía web por asistente.'),
  (3, 1, 'confirmada', 'completada', 'atencion', 'Consulta médica completada con éxito.');

INSERT INTO `notificacion` (`id_usuario`, `id_cita`, `tipo`, `canal`, `estado_envio`, `titulo`, `mensaje`) VALUES
  (5, 1, 'cita_confirmada', 'interno', 'enviada', 'Cita médica registrada', 'Tu cita quedó programada para el próximo día hábil en el Consultorio 101.'),
  (6, 2, 'cita_confirmada', 'interno', 'enviada', 'Cita cardiológica confirmada', 'Tu cita con la Dra. Sofía Flores quedó confirmada.'),
  (7, 3, 'cita_completada', 'interno', 'enviada', 'Resumen de consulta disponible', 'Tu consulta de Medicina General ha concluido.');

-- 10. PORTAL WEB: RESEÑAS, SLIDES, PREGUNTAS FRECUENTES Y CONTENIDO INFORMATIVO
INSERT INTO `resena` (`id_paciente`, `nombre_autor`, `estrellas`, `texto`, `publicada`) VALUES
  (1, 'Ronaldo Hernández', 5, 'Excelente atención por parte del Dr. Rodríguez. Muy puntual y diagnóstico preciso.', 1),
  (2, 'María López', 5, 'Las instalaciones del Centro Sagrado Corazón son impecables y la atención de la Dra. Flores fue excepcional.', 1),
  (NULL, 'Mariana Sánchez (Familiar)', 5, 'Atendieron a mi abuelito con mucha calidez y paciencia. Muy recomendados.', 1);

INSERT INTO `hero_slide` (`titulo`, `texto`, `boton_texto`, `enlace`, `imagen_ruta`, `color_fondo`, `orden`, `activo`) VALUES
  ('Cuidamos de tu Salud', 'Atención médica integral con tecnología avanzada y especialistas certificados.', 'Agendar Cita', '/citas', 'img/hero1.jpg', '#004085', 1, 1),
  ('Agenda Médica en Línea', 'Programa tu cita desde tu teléfono móvil o computadora en minutos.', 'Ver Horarios', '/horarios', 'img/hero2.jpg', '#155724', 2, 1),
  ('Cardiología de Alta Precisión', 'Estudios preventivos de salud cardiovascular a tu alcance.', 'Conocer Más', '/servicios', 'img/hero3.jpg', '#721c24', 3, 1);

INSERT INTO `pregunta_frecuente` (`pregunta`, `respuesta`, `orden`, `activo`) VALUES
  ('¿Cómo agendar una cita médica?', 'Puedes solicitar tu cita directamente desde nuestra aplicación móvil Android o en el portal web seleccionando la especialidad, médico y horario disponible.', 1, 1),
  ('¿Con cuánta anticipación debo llegar a mi cita?', 'Recomendamos presentarse 15 minutos antes de la hora acordada en recepción para toma de signos vitales.', 2, 1),
  ('¿Puedo cancelar o reprogramar una cita?', 'Sí, puedes cancelar o reprogramar con al menos 24 horas de anticipación desde tu panel de usuario.', 3, 1),
  ('¿Cuáles son los métodos de pago aceptados?', 'Aceptamos pago en efectivo, tarjeta de débito/crédito y transferencias electrónicas en el centro médico.', 4, 1);

INSERT INTO `contenido_informativo` (`slug`, `tipo`, `titulo`, `resumen`, `cuerpo`, `estado`, `id_usuario_autor`, `fecha_publicacion`) VALUES
  ('importancia-del-chequeo-medico-anual', 'consejo', 'La Importancia del Chequeo Médico Anual', 'Prevenir enfermedades crónicas mediante estudios periódicos de rutina.', 'El chequeo médico preventivo anual permite detectar oportunamente factores de riesgo como hipertensión arterial, diabetes mellitus y dislipidemias antes de que manifiesten complicaciones severas...', 'publicado', 2, NOW()),
  ('salud-cardiovascular-habitos-saludables', 'consejo', 'Hábitos para una Vida y Corazón Saludables', 'Recomendaciones clave de los cardiólogos para mantener un corazón fuerte.', 'Mantener una alimentación balanceada baja en sodio, realizar al menos 30 minutos de caminata diaria y evitar el tabaquismo son pilares fundamentales para la salud cardiovascular...', 'publicado', 3, NOW()),
  ('jornada-vacunacion-centro-sagrado-corazon', 'aviso', 'Próxima Jornada de Salud y Vacunación', 'Fechas y requisitos para la campaña de inmunización de temporada.', 'El Centro Médico Sagrado Corazón invita a la comunidad a participar en la jornada de salud infantil y preventiva durante este mes...', 'publicado', 1, NOW());

INSERT INTO `auditoria` (`id_usuario`, `modulo`, `accion`, `entidad`, `id_registro`, `resultado`, `observacion`) VALUES
  (1, 'sistema', 'carga_semilla_funcional', 'varias', 'seed_v2.1', 'correcto', 'Carga de datos de prueba funcionales para trabajadores, pacientes y portal web.');

COMMIT;
