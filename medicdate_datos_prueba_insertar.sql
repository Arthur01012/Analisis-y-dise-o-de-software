-- Ejecutar despues de crear el esquema medicdate_multiplataforma.sql.
USE innegone_bd_medicdate;

-- Cuentas de prueba: la contraseña para los tres usuarios es "Prueba123!".
START TRANSACTION;

INSERT INTO persona (
  nombres, apellido_paterno, apellido_materno, correo_contacto, telefono_principal
)
SELECT 'Jose Manuel', 'Rodriguez', NULL, 'jose.rodriguez.doc@example.test', '5550000001'
WHERE NOT EXISTS (
  SELECT 1 FROM persona WHERE correo_contacto = 'jose.rodriguez.doc@example.test'
);

INSERT INTO persona (
  nombres, apellido_paterno, apellido_materno, correo_contacto, telefono_principal
)
SELECT 'Luna Aurora', 'Reyes', NULL, 'luna.reyes.asistente@example.test', '5550000002'
WHERE NOT EXISTS (
  SELECT 1 FROM persona WHERE correo_contacto = 'luna.reyes.asistente@example.test'
);

INSERT INTO persona (
  nombres, apellido_paterno, apellido_materno, correo_contacto, telefono_principal
)
SELECT 'Paciente', 'de Prueba', NULL, 'paciente.prueba@example.test', '5550000003'
WHERE NOT EXISTS (
  SELECT 1 FROM persona WHERE correo_contacto = 'paciente.prueba@example.test'
);

INSERT INTO empleado (id_persona, fecha_contratacion)
SELECT p.id_persona, CURDATE()
FROM persona p
WHERE p.correo_contacto IN (
  'jose.rodriguez.doc@example.test',
  'luna.reyes.asistente@example.test'
)
AND NOT EXISTS (
  SELECT 1 FROM empleado e WHERE e.id_persona = p.id_persona
);

INSERT INTO doctor (id_empleado, cedula_profesional)
SELECT e.id_empleado, 'CED-PRUEBA-JMR-2026'
FROM empleado e
JOIN persona p ON p.id_persona = e.id_persona
WHERE p.correo_contacto = 'jose.rodriguez.doc@example.test'
AND NOT EXISTS (
  SELECT 1 FROM doctor d WHERE d.id_empleado = e.id_empleado
);

INSERT INTO asistente (id_empleado, turno)
SELECT e.id_empleado, 'Matutino'
FROM empleado e
JOIN persona p ON p.id_persona = e.id_persona
WHERE p.correo_contacto = 'luna.reyes.asistente@example.test'
AND NOT EXISTS (
  SELECT 1 FROM asistente a WHERE a.id_empleado = e.id_empleado
);

INSERT INTO paciente (id_persona)
SELECT p.id_persona
FROM persona p
WHERE p.correo_contacto = 'paciente.prueba@example.test'
AND NOT EXISTS (
  SELECT 1 FROM paciente pa WHERE pa.id_persona = p.id_persona
);

INSERT INTO usuario (id_persona, correo_acceso, password_hash)
SELECT p.id_persona, p.correo_contacto,
       '$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y'
FROM persona p
WHERE p.correo_contacto IN (
  'jose.rodriguez.doc@example.test',
  'luna.reyes.asistente@example.test',
  'paciente.prueba@example.test'
)
AND NOT EXISTS (
  SELECT 1 FROM usuario u WHERE u.id_persona = p.id_persona
);

INSERT INTO usuario_rol (id_usuario, id_rol)
SELECT u.id_usuario, r.id_rol
FROM usuario u
JOIN persona p ON p.id_persona = u.id_persona
JOIN rol r ON r.nombre = CASE p.correo_contacto
  WHEN 'jose.rodriguez.doc@example.test' THEN 'medico'
  WHEN 'luna.reyes.asistente@example.test' THEN 'asistente'
  WHEN 'paciente.prueba@example.test' THEN 'paciente'
END
WHERE p.correo_contacto IN (
  'jose.rodriguez.doc@example.test',
  'luna.reyes.asistente@example.test',
  'paciente.prueba@example.test'
)
AND NOT EXISTS (
  SELECT 1
  FROM usuario_rol ur
  WHERE ur.id_usuario = u.id_usuario AND ur.id_rol = r.id_rol
);

INSERT INTO especialidad (nombre, descripcion)
VALUES ('Medicina General - Prueba', 'Especialidad para datos de prueba')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO doctor_especialidad (id_empleado, id_especialidad)
SELECT d.id_empleado, e.id_especialidad
FROM doctor d
JOIN empleado em ON em.id_empleado = d.id_empleado
JOIN persona p ON p.id_persona = em.id_persona
JOIN especialidad e ON e.nombre = 'Medicina General - Prueba'
WHERE p.correo_contacto = 'jose.rodriguez.doc@example.test'
AND NOT EXISTS (
  SELECT 1
  FROM doctor_especialidad de
  WHERE de.id_empleado = d.id_empleado AND de.id_especialidad = e.id_especialidad
);

INSERT INTO consultorio (codigo, nombre, descripcion)
VALUES ('CONS-PRUEBA-01', 'Consultorio de prueba', 'Consultorio para datos de prueba')
ON DUPLICATE KEY UPDATE codigo = VALUES(codigo);

INSERT INTO tipo_atencion (
  id_especialidad, nombre, descripcion, duracion_minutos, costo_base, moneda
)
SELECT e.id_especialidad, 'Consulta de prueba', 'Atencion para datos de prueba', 30, 0.00, 'MXN'
FROM especialidad e
WHERE e.nombre = 'Medicina General - Prueba'
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO cita (
  id_paciente, id_empleado, id_consultorio, id_tipo_atencion,
  inicio, fin, estado, motivo, costo, moneda, id_usuario_registro
)
SELECT pa.id_paciente, d.id_empleado, co.id_consultorio, ta.id_tipo_atencion,
       TIMESTAMP(CURDATE(), '23:00:00'), TIMESTAMP(CURDATE(), '23:30:00'),
       'pendiente', 'Cita de prueba', 0.00, 'MXN', ua.id_usuario
FROM paciente pa
JOIN persona pp ON pp.id_persona = pa.id_persona
JOIN persona pd ON pd.correo_contacto = 'jose.rodriguez.doc@example.test'
JOIN empleado ed ON ed.id_persona = pd.id_persona
JOIN doctor d ON d.id_empleado = ed.id_empleado
JOIN consultorio co ON co.codigo = 'CONS-PRUEBA-01'
JOIN especialidad es ON es.nombre = 'Medicina General - Prueba'
JOIN tipo_atencion ta
  ON ta.id_especialidad = es.id_especialidad
  AND ta.nombre = 'Consulta de prueba'
JOIN usuario ua ON ua.correo_acceso = 'luna.reyes.asistente@example.test'
WHERE pp.correo_contacto = 'paciente.prueba@example.test'
AND NOT EXISTS (
  SELECT 1 FROM cita c
  WHERE c.id_paciente = pa.id_paciente
    AND c.motivo = 'Cita de prueba'
    AND DATE(c.inicio) = CURDATE()
);

INSERT INTO historial_cita (id_cita, id_usuario, estado_nuevo, accion, observacion)
SELECT c.id_cita, ua.id_usuario, c.estado, 'creacion', 'Registro de cita de prueba'
FROM cita c
JOIN paciente pa ON pa.id_paciente = c.id_paciente
JOIN persona pp ON pp.id_persona = pa.id_persona
JOIN usuario ua ON ua.correo_acceso = 'luna.reyes.asistente@example.test'
WHERE pp.correo_contacto = 'paciente.prueba@example.test'
  AND c.motivo = 'Cita de prueba'
  AND DATE(c.inicio) = CURDATE()
  AND NOT EXISTS (
    SELECT 1 FROM historial_cita h
    WHERE h.id_cita = c.id_cita AND h.accion = 'creacion'
  );

COMMIT;
