-- Elimina los datos de prueba de MedicDate (incluye citas creadas desde la app).
-- Los correos example.test identifican únicamente las cuentas semilla.
USE innegone_bd_medicdate;

START TRANSACTION;

DELETE FROM historial_cita
WHERE id_cita IN (
  SELECT c.id_cita
  FROM cita c
  JOIN paciente pa ON pa.id_paciente = c.id_paciente
  JOIN persona p ON p.id_persona = pa.id_persona
  WHERE p.correo_contacto = 'paciente.prueba@example.test'
);

DELETE FROM notificacion
WHERE id_cita IN (
  SELECT c.id_cita
  FROM cita c
  JOIN paciente pa ON pa.id_paciente = c.id_paciente
  JOIN persona p ON p.id_persona = pa.id_persona
  WHERE p.correo_contacto = 'paciente.prueba@example.test'
)
OR id_usuario IN (
  SELECT u.id_usuario
  FROM usuario u
  JOIN persona p ON p.id_persona = u.id_persona
  WHERE p.correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test',
    'paciente.prueba@example.test'
  )
);

DELETE FROM auditoria
WHERE id_usuario IN (
  SELECT u.id_usuario
  FROM usuario u
  JOIN persona p ON p.id_persona = u.id_persona
  WHERE p.correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test',
    'paciente.prueba@example.test'
  )
)
OR (
  entidad = 'cita'
  AND CAST(id_registro AS UNSIGNED) IN (
    SELECT c.id_cita
    FROM cita c
    JOIN paciente pa ON pa.id_paciente = c.id_paciente
    JOIN persona p ON p.id_persona = pa.id_persona
    WHERE p.correo_contacto = 'paciente.prueba@example.test'
  )
);

DELETE FROM cita
WHERE id_paciente IN (
  SELECT pa.id_paciente
  FROM paciente pa
  JOIN persona p ON p.id_persona = pa.id_persona
  WHERE p.correo_contacto = 'paciente.prueba@example.test'
);

DELETE FROM horario_atencion
WHERE id_empleado IN (
  SELECT e.id_empleado
  FROM empleado e
  JOIN persona p ON p.id_persona = e.id_persona
  WHERE p.correo_contacto = 'jose.rodriguez.doc@example.test'
);

DELETE FROM bloqueo_horario
WHERE id_empleado IN (
  SELECT e.id_empleado
  FROM empleado e
  JOIN persona p ON p.id_persona = e.id_persona
  WHERE p.correo_contacto = 'jose.rodriguez.doc@example.test'
);

DELETE FROM sesion_usuario
WHERE id_usuario IN (
  SELECT u.id_usuario
  FROM usuario u
  JOIN persona p ON p.id_persona = u.id_persona
  WHERE p.correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test',
    'paciente.prueba@example.test'
  )
);

DELETE FROM token_recuperacion
WHERE id_usuario IN (
  SELECT u.id_usuario
  FROM usuario u
  JOIN persona p ON p.id_persona = u.id_persona
  WHERE p.correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test',
    'paciente.prueba@example.test'
  )
);

DELETE FROM usuario_rol
WHERE id_usuario IN (
  SELECT u.id_usuario
  FROM usuario u
  JOIN persona p ON p.id_persona = u.id_persona
  WHERE p.correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test',
    'paciente.prueba@example.test'
  )
);

DELETE FROM doctor_especialidad
WHERE id_empleado IN (
  SELECT e.id_empleado
  FROM empleado e
  JOIN persona p ON p.id_persona = e.id_persona
  WHERE p.correo_contacto = 'jose.rodriguez.doc@example.test'
)
AND id_especialidad IN (
  SELECT id_especialidad
  FROM especialidad
  WHERE nombre = 'Medicina General - Prueba'
);

DELETE FROM doctor
WHERE id_empleado IN (
  SELECT e.id_empleado
  FROM empleado e
  JOIN persona p ON p.id_persona = e.id_persona
  WHERE p.correo_contacto = 'jose.rodriguez.doc@example.test'
)
AND NOT EXISTS (
  SELECT 1 FROM cita c WHERE c.id_empleado = doctor.id_empleado
);

DELETE FROM asistente
WHERE id_empleado IN (
  SELECT e.id_empleado
  FROM empleado e
  JOIN persona p ON p.id_persona = e.id_persona
  WHERE p.correo_contacto = 'luna.reyes.asistente@example.test'
);

DELETE FROM paciente
WHERE id_persona IN (
  SELECT id_persona
  FROM persona
  WHERE correo_contacto = 'paciente.prueba@example.test'
)
AND NOT EXISTS (
  SELECT 1 FROM cita c WHERE c.id_paciente = paciente.id_paciente
);

DELETE FROM empleado
WHERE id_persona IN (
  SELECT id_persona
  FROM persona
  WHERE correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test'
  )
)
AND NOT EXISTS (
  SELECT 1 FROM doctor d WHERE d.id_empleado = empleado.id_empleado
)
AND NOT EXISTS (
  SELECT 1 FROM asistente a WHERE a.id_empleado = empleado.id_empleado
);

DELETE FROM tipo_atencion
WHERE nombre = 'Consulta de prueba'
AND id_especialidad IN (
  SELECT id_especialidad
  FROM especialidad
  WHERE nombre = 'Medicina General - Prueba'
)
AND NOT EXISTS (
  SELECT 1 FROM cita c WHERE c.id_tipo_atencion = tipo_atencion.id_tipo_atencion
);

DELETE FROM consultorio
WHERE codigo = 'CONS-PRUEBA-01'
AND NOT EXISTS (
  SELECT 1 FROM cita c WHERE c.id_consultorio = consultorio.id_consultorio
)
AND NOT EXISTS (
  SELECT 1 FROM horario_atencion h WHERE h.id_consultorio = consultorio.id_consultorio
)
AND NOT EXISTS (
  SELECT 1 FROM bloqueo_horario b WHERE b.id_consultorio = consultorio.id_consultorio
);

DELETE FROM especialidad
WHERE nombre = 'Medicina General - Prueba'
AND NOT EXISTS (
  SELECT 1 FROM doctor_especialidad de WHERE de.id_especialidad = especialidad.id_especialidad
)
AND NOT EXISTS (
  SELECT 1 FROM tipo_atencion ta WHERE ta.id_especialidad = especialidad.id_especialidad
);

DELETE FROM usuario
WHERE id_persona IN (
  SELECT id_persona
  FROM persona
  WHERE correo_contacto IN (
    'jose.rodriguez.doc@example.test',
    'luna.reyes.asistente@example.test',
    'paciente.prueba@example.test'
  )
)
AND NOT EXISTS (
  SELECT 1 FROM cita c WHERE c.id_usuario_registro = usuario.id_usuario
)
AND NOT EXISTS (
  SELECT 1 FROM bloqueo_horario b WHERE b.id_usuario_registro = usuario.id_usuario
);

DELETE FROM persona
WHERE correo_contacto IN (
  'jose.rodriguez.doc@example.test',
  'luna.reyes.asistente@example.test',
  'paciente.prueba@example.test'
)
AND NOT EXISTS (
  SELECT 1 FROM usuario u WHERE u.id_persona = persona.id_persona
)
AND NOT EXISTS (
  SELECT 1 FROM paciente pa WHERE pa.id_persona = persona.id_persona
)
AND NOT EXISTS (
  SELECT 1 FROM empleado e WHERE e.id_persona = persona.id_persona
);

COMMIT;
