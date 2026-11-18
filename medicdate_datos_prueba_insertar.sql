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

-- Agenda de prueba de lunes a viernes para cargar horarios en la app.
INSERT INTO horario_atencion (
  id_empleado, id_consultorio, dia_semana, hora_inicio, hora_fin,
  intervalo_minutos, vigencia_desde, vigencia_hasta, activo
)
SELECT ed.id_empleado, co.id_consultorio, dias.dia,
       '09:00:00', '17:00:00', 30, CURDATE(), NULL, 1
FROM empleado ed
JOIN persona pd ON pd.id_persona = ed.id_persona
JOIN doctor d ON d.id_empleado = ed.id_empleado
JOIN consultorio co ON co.codigo = 'CONS-PRUEBA-01'
CROSS JOIN (
  SELECT 1 AS dia UNION ALL SELECT 2 UNION ALL SELECT 3
  UNION ALL SELECT 4 UNION ALL SELECT 5
) AS dias
WHERE pd.correo_contacto = 'jose.rodriguez.doc@example.test'
AND NOT EXISTS (
  SELECT 1 FROM horario_atencion h
  WHERE h.id_empleado = ed.id_empleado
    AND h.id_consultorio = co.id_consultorio
    AND h.dia_semana = dias.dia
    AND h.hora_inicio = '09:00:00'
    AND h.hora_fin = '17:00:00'
    AND h.intervalo_minutos = 30
    AND h.vigencia_desde = CURDATE()
);

SET @fecha_prueba = CASE DAYOFWEEK(CURDATE())
  WHEN 6 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)
  WHEN 7 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)
  ELSE DATE_ADD(CURDATE(), INTERVAL 1 DAY)
END;

INSERT INTO cita (
  id_paciente, id_empleado, id_consultorio, id_tipo_atencion,
  inicio, fin, estado, motivo, costo, moneda, id_usuario_registro
)
SELECT pa.id_paciente, d.id_empleado, co.id_consultorio, ta.id_tipo_atencion,
       TIMESTAMP(@fecha_prueba, '09:00:00'), TIMESTAMP(@fecha_prueba, '09:30:00'),
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
    AND DATE(c.inicio) = @fecha_prueba
);

INSERT INTO historial_cita (id_cita, id_usuario, estado_nuevo, accion, observacion)
SELECT c.id_cita, ua.id_usuario, c.estado, 'creacion', 'Registro de cita de prueba'
FROM cita c
JOIN paciente pa ON pa.id_paciente = c.id_paciente
JOIN persona pp ON pp.id_persona = pa.id_persona
JOIN usuario ua ON ua.correo_acceso = 'luna.reyes.asistente@example.test'
WHERE pp.correo_contacto = 'paciente.prueba@example.test'
  AND c.motivo = 'Cita de prueba'
  AND DATE(c.inicio) = @fecha_prueba
  AND NOT EXISTS (
    SELECT 1 FROM historial_cita h
    WHERE h.id_cita = c.id_cita AND h.accion = 'creacion'
  );

INSERT INTO notificacion (
  id_usuario, id_cita, tipo, canal, estado_envio, titulo, mensaje
)
SELECT ua.id_usuario, c.id_cita, 'cita_confirmada', 'interno', 'pendiente',
       'Cita de prueba', 'Cita de prueba para verificar horarios y confirmación.'
FROM cita c
JOIN paciente pa ON pa.id_paciente = c.id_paciente
JOIN persona pp ON pp.id_persona = pa.id_persona
JOIN usuario ua ON ua.correo_acceso = 'luna.reyes.asistente@example.test'
WHERE pp.correo_contacto = 'paciente.prueba@example.test'
  AND c.motivo = 'Cita de prueba'
  AND DATE(c.inicio) = @fecha_prueba
  AND NOT EXISTS (
    SELECT 1 FROM notificacion n
    WHERE n.id_cita = c.id_cita AND n.tipo = 'cita_confirmada' AND n.canal = 'interno'
  );

INSERT INTO auditoria (
  id_usuario, modulo, accion, entidad, id_registro, resultado, observacion
)
SELECT ua.id_usuario, 'citas', 'prueba_seed', 'cita', CAST(c.id_cita AS CHAR),
       'correcto', 'Cita semilla para probar disponibilidad móvil.'
FROM cita c
JOIN paciente pa ON pa.id_paciente = c.id_paciente
JOIN persona pp ON pp.id_persona = pa.id_persona
JOIN usuario ua ON ua.correo_acceso = 'luna.reyes.asistente@example.test'
WHERE pp.correo_contacto = 'paciente.prueba@example.test'
  AND c.motivo = 'Cita de prueba'
  AND DATE(c.inicio) = @fecha_prueba
  AND NOT EXISTS (
    SELECT 1 FROM auditoria a
    WHERE a.entidad = 'cita'
      AND CAST(a.id_registro AS UNSIGNED) = c.id_cita
      AND a.accion = 'prueba_seed'
  );

COMMIT;

