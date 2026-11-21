# Sistema Integral de Gestión de Citas Médicas para el Centro Médico Sagrado Corazón — Diccionario de datos

> **Versión:** Modelo Normalizado `innegone_bd_medicdate` (Versión 2.1). Este documento describe el DDL definitivo y normalizado en Tercera Forma Normal (3FN) compuesto por 31 tablas para la plataforma integral (Escritorio C# / Windows Forms, Móvil Android Kotlin, Web React y Backend Laravel API).

## Convenciones

- **PK:** Clave primaria; **FK:** Clave foránea; **UQ:** Índice/Restricción de unicidad; **AI:** Autoincremental.
- **Nulo:** `No` significa `NOT NULL`; `Sí` significa que permite `NULL`.
- Los campos `DATETIME` almacenan marca temporal de fecha y hora. La zona horaria acordada en el backend es `America/Mexico_City`.
- Los campos booleanos son `TINYINT(1)` y usan `1` para verdadero/activo y `0` para falso/inactivo.
- Motor de almacenamiento: `InnoDB` con juego de caracteres `utf8mb4` y colación `utf8mb4_unicode_ci`.

---

## 1. Identidad y Autorización

### `persona`
Datos personales y de contacto base que se vinculan a cuentas de usuario y perfiles de paciente o empleado.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_persona` | `BIGINT UNSIGNED` | No | PK, AI | Identificador interno único de la persona. |
| `nombres` | `VARCHAR(100)` | No | — | Nombres de pila de la persona. |
| `apellido_paterno` | `VARCHAR(80)` | No | — | Primer apellido. |
| `apellido_materno` | `VARCHAR(80)` | Sí | `NULL` | Segundo apellido, si aplica. |
| `fecha_nacimiento` | `DATE` | Sí | `NULL` | Fecha de nacimiento. |
| `correo_contacto` | `VARCHAR(254)` | Sí | `NULL` | Correo electrónico de contacto personal. |
| `telefono_principal` | `VARCHAR(25)` | Sí | `NULL` | Teléfono móvil o principal. |
| `telefono_secundario` | `VARCHAR(25)` | Sí | `NULL` | Teléfono alternativo de contacto. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Momento de alta del registro. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Momento de última modificación. |

### `usuario`
Cuenta de autenticación y acceso al sistema asociada de forma biunívoca a una persona.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_usuario` | `BIGINT UNSIGNED` | No | PK, AI | Identificador único de la cuenta. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK, UQ → `persona.id_persona` | Persona propietaria de la cuenta. |
| `correo_acceso` | `VARCHAR(254)` | No | UQ | Correo electrónico utilizado para autenticarse. |
| `password_hash` | `VARCHAR(255)` | No | — | Hash de contraseña seguro (bcrypt / Argon2id). |
| `estado` | `ENUM('activa','inactiva','bloqueada')` | No | `'activa'` | Estado operativo de la cuenta. |
| `cambio_password_obligatorio` | `TINYINT(1)` | No | `0` | Indica si el usuario debe renovar contraseña al ingresar. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación de la cuenta. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Última actualización de datos de acceso. |
| `ultimo_acceso` | `DATETIME` | Sí | `NULL` | Fecha y hora del último login correcto. |

### `rol`
Catálogo de roles autorizados en el sistema.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_rol` | `SMALLINT UNSIGNED` | No | PK, AI | Identificador interno del rol. |
| `nombre` | `VARCHAR(40)` | No | UQ | Nombre del rol (`administrador`, `asistente`, `medico`, `paciente`). |
| `descripcion` | `VARCHAR(255)` | Sí | `NULL` | Alcance y responsabilidades del rol. |

### `permiso`
Catálogo granular de acciones autorizables por el backend Laravel.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_permiso` | `SMALLINT UNSIGNED` | No | PK, AI | Identificador del permiso. |
| `codigo` | `VARCHAR(80)` | No | UQ | Código semántico (ej. `citas.crear`, `medicos.bloquear`). |
| `descripcion` | `VARCHAR(255)` | Sí | `NULL` | Explicación funcional de la acción autorizada. |

### `usuario_rol`
Tabla puente muchos a muchos entre usuarios y roles.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_usuario` | `BIGINT UNSIGNED` | No | PK compuesta, FK → `usuario.id_usuario` | Usuario al que se le otorga el rol (ON DELETE CASCADE). |
| `id_rol` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `rol.id_rol` | Rol asignado (ON DELETE RESTRICT). |
| `fecha_asignacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de asignación del rol. |

### `rol_permiso`
Tabla puente muchos a muchos que define los permisos inherentes a cada rol.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_rol` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `rol.id_rol` | Rol que recibe la facultad (ON DELETE CASCADE). |
| `id_permiso` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `permiso.id_permiso` | Permiso otorgado (ON DELETE RESTRICT). |

---

## 2. Ubicación Geográfica y Domicilios

### `municipio`
Catálogo oficial de municipios de cobertura clínica (inicialmente los 84 municipios del Estado de Hidalgo).

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_municipio` | `INT UNSIGNED` | No | PK, AI | Identificador del municipio. |
| `nombre` | `VARCHAR(100)` | No | KEY | Nombre oficial del municipio. |
| `estado` | `VARCHAR(50)` | No | `'Hidalgo'` | Entidad federativa. |
| `codigo_postal` | `VARCHAR(10)` | Sí | `NULL` | Código postal de referencia municipal. |

### `direccion`
Domicilios normalizados asociados a personas (pacientes, personal o referencias).

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_direccion` | `BIGINT UNSIGNED` | No | PK, AI | Identificador interno de la dirección. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK → `persona.id_persona` | Persona propietaria del domicilio (ON DELETE CASCADE). |
| `calle` | `VARCHAR(120)` | No | — | Nombre de la vialidad. |
| `numero` | `VARCHAR(30)` | Sí | `NULL` | Número exterior e interior. |
| `colonia` | `VARCHAR(100)` | Sí | `NULL` | Asentamiento o colonia. |
| `localidad` | `VARCHAR(100)` | Sí | `NULL` | Localidad, pueblo o ciudad. |
| `id_municipio` | `INT UNSIGNED` | Sí | FK → `municipio.id_municipio` | Municipio correspondiente (ON DELETE SET NULL). |
| `codigo_postal` | `VARCHAR(10)` | Sí | `NULL` | Código postal de 5 dígitos. |
| `referencia` | `VARCHAR(255)` | Sí | `NULL` | Indicaciones o puntos de referencia. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de registro del domicilio. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Última actualización. |

---

## 3. Perfiles de Paciente y Personal

### `paciente`
Perfil clínico-administrativo de un paciente vinculado a `persona`.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_paciente` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del paciente. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK, UQ → `persona.id_persona` | Persona correspondiente (ON DELETE RESTRICT). |
| `alergias` | `TEXT` | Sí | `NULL` | Alergias conocidas (dato sensible de acceso restringido). |
| `notas_medicas` | `TEXT` | Sí | `NULL` | Antecedentes o notas preventivas. |
| `estado` | `ENUM('activo','inactivo')` | No | `'activo'` | Estado del paciente en el centro médico. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de alta del perfil. |

### `empleado`
Perfil laboral general de trabajadores del centro médico.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del empleado. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK, UQ → `persona.id_persona` | Persona asociada al registro laboral (ON DELETE RESTRICT). |
| `curp` | `CHAR(18)` | Sí | UQ, `NULL` | Clave Única de Registro de Población. |
| `fecha_contratacion` | `DATE` | Sí | `NULL` | Fecha de ingreso laboral. |
| `estado` | `ENUM('activo','inactivo')` | No | `'activo'` | Estado laboral en el centro médico. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de registro del empleado. |

### `asistente`
Especialización del empleado como asistente o recepcionista.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK, FK → `empleado.id_empleado` | Empleado asignado a asistencia (ON DELETE RESTRICT). |
| `turno` | `VARCHAR(30)` | Sí | `NULL` | Turno de trabajo (`Matutino`, `Vespertino`, `Mixto`, `Nocturno`). |

### `doctor`
Especialización del empleado como profesional médico habilitado para dar consulta.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK, FK → `empleado.id_empleado` | Empleado con perfil de médico (ON DELETE RESTRICT). |
| `cedula_profesional` | `VARCHAR(50)` | No | UQ | Cédula profesional emitida por la autoridad competente. |
| `descripcion_publica` | `TEXT` | Sí | `NULL` | Perfil y trayectoria para exposición en el portal web. |
| `foto_ruta` | `VARCHAR(255)` | Sí | `NULL` | Ruta del archivo de fotografía profesional. |
| `publicado` | `TINYINT(1)` | No | `1` | Define si el médico es visible en el directorio web. |

---

## 4. Catálogos Clínicos y Servicios Unificados

### `especialidad`
Ramas o especialidades médicas ofrecidas por la clínica.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_especialidad` | `INT UNSIGNED` | No | PK, AI | Identificador de la especialidad. |
| `nombre` | `VARCHAR(100)` | No | UQ | Nombre oficial de la especialidad. |
| `resumen` | `VARCHAR(200)` | Sí | `NULL` | Síntesis concisa para tarjetas informativas web. |
| `descripcion` | `TEXT` | Sí | `NULL` | Detalle ampliado de la especialidad. |
| `activo` | `TINYINT(1)` | No | `1` | Estado de vigencia operativa. |

### `doctor_especialidad`
Relación muchos a muchos entre médicos y sus especialidades acreditadas.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK compuesta, FK → `doctor.id_empleado` | Médico tratante (ON DELETE RESTRICT). |
| `id_especialidad` | `INT UNSIGNED` | No | PK compuesta, FK → `especialidad.id_especialidad` | Especialidad acreditada (ON DELETE RESTRICT). |

### `consultorio`
Espacios físicos o salas de atención clínica.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_consultorio` | `INT UNSIGNED` | No | PK, AI | Identificador del consultorio. |
| `codigo` | `VARCHAR(30)` | No | UQ | Código de sala (ej. `CONS-101`). |
| `nombre` | `VARCHAR(100)` | Sí | `NULL` | Nombre identificable del espacio. |
| `descripcion` | `VARCHAR(255)` | Sí | `NULL` | Equipamiento o piso. |
| `activo` | `TINYINT(1)` | No | `1` | Habilitado para programación de agendas. |

### `tipo_atencion`
Catálogo unificado de prestaciones y servicios médicos (integra requerimientos operativos y web pública, cumpliendo 3FN).

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_tipo_atencion` | `INT UNSIGNED` | No | PK, AI | Identificador del servicio/tipo de atención. |
| `id_especialidad` | `INT UNSIGNED` | Sí | FK → `especialidad.id_especialidad` | Especialidad vinculada (ON DELETE RESTRICT). |
| `nombre` | `VARCHAR(120)` | No | UQ compuesto con especialidad | Nombre del servicio médico. |
| `resumen` | `VARCHAR(200)` | Sí | `NULL` | Resumen breve para tarjetas públicas. |
| `descripcion` | `TEXT` | Sí | `NULL` | Descripción completa y preparación para la atención. |
| `duracion_minutos` | `SMALLINT UNSIGNED` | No | CHECK `> 0` | Duración prevista de la consulta/intervención. |
| `costo_base` | `DECIMAL(10,2)` | Sí | CHECK `>= 0`, `NULL` | Costo de referencia en catálogo. |
| `moneda` | `CHAR(3)` | No | `'MXN'` | Código de divisa ISO 4217. |
| `orden` | `SMALLINT UNSIGNED` | No | `0` | Prioridad de visualización en catálogo y portal. |
| `activo` | `TINYINT(1)` | No | `1` | Habilitado para agendamiento. |
| `publicado_web` | `TINYINT(1)` | No | `1` | Visible en la sección de servicios del portal web. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Última modificación del servicio. |

---

## 5. Agenda, Bloqueos y Citas

### `horario_atencion`
Disponibilidad semanal recurrente del médico por consultorio y vigencia temporal.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_horario` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del bloque de horario. |
| `id_empleado` | `BIGINT UNSIGNED` | No | FK → `doctor.id_empleado` | Médico con disponibilidad (ON DELETE RESTRICT). |
| `id_consultorio` | `INT UNSIGNED` | Sí | FK → `consultorio.id_consultorio` | Consultorio asignado (ON DELETE RESTRICT). |
| `dia_semana` | `TINYINT UNSIGNED` | No | CHECK `1..7` | Día ISO-8601 (1 = lunes, 7 = domingo). |
| `hora_inicio` | `TIME` | No | — | Hora de apertura del turno. |
| `hora_fin` | `TIME` | No | CHECK `> hora_inicio` | Hora de cierre del turno. |
| `intervalo_minutos` | `SMALLINT UNSIGNED` | No | `30`, CHECK `> 0` | Duración base de cada intervalo para citas. |
| `vigencia_desde` | `DATE` | No | — | Fecha de inicio de aplicación del horario. |
| `vigencia_hasta` | `DATE` | Sí | CHECK `>= vigencia_desde`, `NULL` | Fin de vigencia (`NULL` indica indefinida). |
| `activo` | `TINYINT(1)` | No | `1` | Habilitado para generar disponibilidad. |

### `bloqueo_horario`
Excepciones temporales a la agenda médica o cierre temporal de consultorio (vacaciones, congresos, mantenimientos).

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_bloqueo` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del bloqueo. |
| `id_empleado` | `BIGINT UNSIGNED` | No | FK → `doctor.id_empleado` | Médico indisponible (ON DELETE RESTRICT). |
| `id_consultorio` | `INT UNSIGNED` | Sí | FK → `consultorio.id_consultorio` | Consultorio afectado (ON DELETE RESTRICT). |
| `inicio` | `DATETIME` | No | — | Inicio de la indisponibilidad. |
| `fin` | `DATETIME` | No | CHECK `> inicio` | Fin de la indisponibilidad. |
| `motivo` | `VARCHAR(255)` | Sí | `NULL` | Motivo de la excepción de agenda. |
| `id_usuario_registro` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Cuenta que cargó el bloqueo (ON DELETE RESTRICT). |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de captura. |

### `cita`
Reserva formal de atención médica.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_cita` | `BIGINT UNSIGNED` | No | PK, AI | Identificador de la cita médica. |
| `id_paciente` | `BIGINT UNSIGNED` | No | FK → `paciente.id_paciente` | Paciente que recibirá atención (ON DELETE RESTRICT). |
| `id_empleado` | `BIGINT UNSIGNED` | No | FK → `doctor.id_empleado` | Médico responsable de la cita (ON DELETE RESTRICT). |
| `id_consultorio` | `INT UNSIGNED` | Sí | FK → `consultorio.id_consultorio` | Espacio reservado (ON DELETE RESTRICT). |
| `id_tipo_atencion` | `INT UNSIGNED` | No | FK → `tipo_atencion.id_tipo_atencion` | Servicio médico contratado (ON DELETE RESTRICT). |
| `inicio` | `DATETIME` | No | — | Fecha y hora de inicio de la cita. |
| `fin` | `DATETIME` | No | CHECK `> inicio` | Fecha y hora proyectada de finalización. |
| `estado` | `ENUM('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia')` | No | `'pendiente'` | Estado operativo de la cita. |
| `canal_registro` | `ENUM('movil','web','escritorio')` | No | `'movil'` | Origen del agendamiento (por omisión móvil). |
| `motivo` | `VARCHAR(500)` | Sí | `NULL` | Razón de consulta manifestada por el paciente. |
| `notas_internas` | `TEXT` | Sí | `NULL` | Comentarios del personal clínico/administrativo. |
| `costo` | `DECIMAL(10,2)` | Sí | CHECK `>= 0`, `NULL` | Costo efectivamente registrado al momento de la cita. |
| `moneda` | `CHAR(3)` | No | `'MXN'` | Moneda del costo pactado. |
| `id_usuario_registro` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Cuenta que dio de alta la cita (ON DELETE RESTRICT). |
| `id_usuario_cancelacion` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario` | Cuenta que canceló la cita (ON DELETE SET NULL). |
| `motivo_cancelacion` | `VARCHAR(500)` | Sí | `NULL` | Causa de la cancelación. |
| `fecha_cancelacion` | `DATETIME` | Sí | `NULL` | CHECK: Obligatorio si estado = `'cancelada'`, NULL en caso contrario. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación del registro. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Última modificación de la cita. |

### `historial_cita`
Trazabilidad inmutable de cambios de estado y eventos sobre la cita.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_historial` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del evento de auditoría de cita. |
| `id_cita` | `BIGINT UNSIGNED` | No | FK → `cita.id_cita` | Cita afectada (ON DELETE RESTRICT). |
| `id_usuario` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario` | Usuario autor del cambio (ON DELETE SET NULL). |
| `estado_anterior` | `ENUM('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia')` | Sí | `NULL` | Estado previo. |
| `estado_nuevo` | `ENUM('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia')` | Sí | `NULL` | Estado asignado. |
| `accion` | `VARCHAR(60)` | No | — | Operación ejecutada (`creacion`, `confirmacion`, `cancelacion`, etc.). |
| `observacion` | `VARCHAR(500)` | Sí | `NULL` | Comentario explicativo del evento. |
| `fecha_evento` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Momento exacto del cambio. |

---

## 6. Sesiones, Seguridad y Notificaciones

### `sesion_usuario`
Control de tokens de sesión autenticada para móvil, web y escritorio.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_sesion` | `BIGINT UNSIGNED` | No | PK, AI | Identificador de la sesión activa. |
| `id_usuario` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Usuario propietario (ON DELETE RESTRICT). |
| `token_hash` | `CHAR(64)` | No | UQ | Hash SHA-256 binario del token emitido. |
| `plataforma` | `ENUM('web','android','escritorio')` | No | — | Plataforma cliente originaria. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Inicio de sesión. |
| `fecha_expiracion` | `DATETIME` | No | CHECK `> fecha_creacion` | Límite temporal de vigencia del token. |
| `fecha_revocacion` | `DATETIME` | Sí | `NULL` | Momento de cierre explícito o invalidación. |

### `token_recuperacion`
Tokens temporales fuera de banda para recuperación de clave o verificación de correo.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_token` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del token de un solo uso. |
| `id_usuario` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Cuenta beneficiaria (ON DELETE RESTRICT). |
| `token_hash` | `CHAR(64)` | No | UQ | Hash seguro del token enviado por correo. |
| `proposito` | `ENUM('recuperacion_contrasena','verificacion_correo')` | No | — | Objeto específico del token. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de generación. |
| `fecha_expiracion` | `DATETIME` | No | CHECK `> fecha_creacion` | Caducidad (ej. 30 minutos). |
| `fecha_consumo` | `DATETIME` | Sí | `NULL` | Momento en que fue consumido exitosamente. |

### `pregunta_secreta`
Catálogo institucional de preguntas secretas de seguridad.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_pregunta_secreta` | `SMALLINT UNSIGNED` | No | PK, AI | Identificador de la pregunta. |
| `texto` | `VARCHAR(150)` | No | UQ | Texto visible de la pregunta de desafío. |
| `activo` | `TINYINT(1)` | No | `1` | Habilitada para selección en perfiles de usuario. |

### `usuario_pregunta_secreta`
Respuestas de seguridad registradas por el usuario (clave primaria compuesta para admitir 1, 2 o más preguntas).

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_usuario` | `BIGINT UNSIGNED` | No | PK compuesta, FK → `usuario.id_usuario` | Cuenta de usuario (ON DELETE CASCADE). |
| `id_pregunta_secreta` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `pregunta_secreta.id_pregunta_secreta` | Pregunta seleccionada (ON DELETE RESTRICT). |
| `respuesta_hash` | `VARCHAR(255)` | No | — | Hash irreversible de la respuesta normalizada. |
| `intentos_fallidos` | `TINYINT UNSIGNED` | No | `0` | Contador de intentos erróneos. |
| `bloqueado_hasta` | `DATETIME` | Sí | `NULL` | Tiempo límite de bloqueo por exceso de fallos. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Momento de registro o actualización. |

### `notificacion`
Buzón de notificaciones internas y registro de mensajes push/correo.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_notificacion` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del mensaje. |
| `id_usuario` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Destinatario del aviso (ON DELETE RESTRICT). |
| `id_cita` | `BIGINT UNSIGNED` | Sí | FK → `cita.id_cita` | Cita relacionada (ON DELETE SET NULL). |
| `tipo` | `VARCHAR(60)` | No | — | Código de plantilla (`cita_confirmada`, `recordatorio`, etc.). |
| `canal` | `ENUM('interno','correo','push','sms')` | No | `'interno'` | Canal de entrega. |
| `estado_envio` | `ENUM('pendiente','enviada','fallida')` | No | `'pendiente'` | Estado de transmisión. |
| `titulo` | `VARCHAR(160)` | No | — | Asunto o título breve. |
| `mensaje` | `TEXT` | Sí | `NULL` | Contenido del mensaje. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Creación del aviso. |
| `fecha_envio` | `DATETIME` | Sí | `NULL` | Momento de despacho exitoso. |
| `fecha_lectura` | `DATETIME` | Sí | `NULL` | Fecha de lectura por parte del usuario. |
| `codigo_error` | `VARCHAR(80)` | Sí | `NULL` | Código de error técnico si falló la entrega. |

### `auditoria`
Registro general de eventos de seguridad, cambios administrativos y fallos operativos.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_auditoria` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del evento de auditoría. |
| `id_usuario` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario` | Usuario responsable del evento (ON DELETE SET NULL). |
| `modulo` | `VARCHAR(60)` | No | — | Subsistema de origen (`citas`, `usuarios`, `auth`). |
| `accion` | `VARCHAR(80)` | No | — | Operación ejecutada (`login`, `cancelacion`, `bloqueo`). |
| `entidad` | `VARCHAR(80)` | Sí | `NULL` | Nombre de la tabla o entidad intervenida. |
| `id_registro` | `VARCHAR(80)` | Sí | `NULL` | Clave del registro afectado en formato texto. |
| `resultado` | `ENUM('correcto','rechazado','error')` | No | — | Resultado de la operación. |
| `observacion` | `VARCHAR(500)` | Sí | `NULL` | Detalles técnicos o motivo no sensible. |
| `fecha_evento` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Marca temporal del evento. |

---

## 7. Portal Web Público e Información Institucional

### `centro_medico`
Configuración institucional de la clínica bajo patrón relacional Singleton (`CHECK id_centro = 1`).

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_centro` | `TINYINT UNSIGNED` | No | PK, CHECK `= 1` | Clave estática de la institución. |
| `nombre` | `VARCHAR(150)` | No | — | Nombre legal o comercial del centro médico. |
| `direccion` | `VARCHAR(255)` | Sí | `NULL` | Domicilio visible en el pie del portal. |
| `telefono` | `VARCHAR(25)` | Sí | `NULL` | Teléfono de atención al público. |
| `correo` | `VARCHAR(254)` | Sí | `NULL` | Correo institucional de informes. |
| `horario` | `VARCHAR(255)` | Sí | `NULL` | Horario general de apertura. |
| `mision` | `TEXT` | Sí | `NULL` | Declaración de misión corporativa. |
| `vision` | `TEXT` | Sí | `NULL` | Declaración de visión institucional. |
| `valores` | `TEXT` | Sí | `NULL` | Valores éticos y profesionales. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Momento de última actualización. |

### `hero_slide`
Diapositivas dinámicas para el carrusel de la página de inicio pública.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_slide` | `INT UNSIGNED` | No | PK, AI | Identificador de la diapositiva. |
| `titulo` | `VARCHAR(60)` | No | — | Encabezado principal. |
| `texto` | `VARCHAR(160)` | No | — | Subtítulo o llamado a la acción. |
| `boton_texto` | `VARCHAR(24)` | Sí | `NULL` | Texto dentro del botón interactivo. |
| `enlace` | `VARCHAR(255)` | Sí | `NULL` | Ruta de redirección o destino del botón. |
| `imagen_ruta` | `VARCHAR(255)` | Sí | `NULL` | Ruta del recurso gráfico de fondo. |
| `color_fondo` | `CHAR(7)` | Sí | `NULL` | Color hexadecimal de fondo (ej. `#FFFFFF`). |
| `orden` | `SMALLINT UNSIGNED` | No | `0` | Secuencia de reproducción. |
| `activo` | `TINYINT(1)` | No | `1` | Diapositiva visible en el carrusel. |

### `resena`
Testimonios y valoraciones públicas del servicio médico; admite opiniones de pacientes registrados y de visitantes externos.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_resena` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del testimonio. |
| `id_paciente` | `BIGINT UNSIGNED` | Sí | FK → `paciente.id_paciente` | Paciente registrado, si aplica (ON DELETE SET NULL). |
| `nombre_autor` | `VARCHAR(100)` | No | — | Nombre o alias del autor (permite agentes externos). |
| `estrellas` | `TINYINT UNSIGNED` | No | CHECK `1..5` | Puntuación de calidad del servicio (1 a 5). |
| `texto` | `VARCHAR(500)` | No | — | Comentario de la reseña. |
| `publicada` | `TINYINT(1)` | No | `0` | Aprobación editorial previa a mostrarse en web. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de captura de la reseña. |

### `pregunta_frecuente`
Sección de preguntas frecuentes (FAQ) administrables para pacientes.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_pregunta_frecuente` | `INT UNSIGNED` | No | PK, AI | Identificador de la FAQ. |
| `pregunta` | `VARCHAR(200)` | No | — | Interrogante recurrente de los pacientes. |
| `respuesta` | `TEXT` | No | — | Respuesta detallada. |
| `orden` | `SMALLINT UNSIGNED` | No | `0` | Posición en el acordeón visual. |
| `activo` | `TINYINT(1)` | No | `1` | Visible en el portal web. |

### `contenido_informativo`
Publicación de artículos de salud, noticias del centro y avisos oficiales.

| Campo | Tipo | Nulo | Clave / Inicial | Descripción |
|---|---|---:|---|---|
| `id_contenido` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del artículo. |
| `slug` | `VARCHAR(160)` | No | UQ | Identificador URL amigable único. |
| `tipo` | `ENUM('consejo','noticia','aviso')` | No | `'consejo'` | Clasificación editorial del contenido. |
| `titulo` | `VARCHAR(200)` | No | — | Título del artículo o noticia. |
| `resumen` | `VARCHAR(300)` | Sí | `NULL` | Resumen introductorio. |
| `cuerpo` | `MEDIUMTEXT` | No | — | Contenido formateado del artículo. |
| `estado` | `ENUM('borrador','publicado','archivado')` | No | `'borrador'` | Estado de publicación. |
| `id_usuario_autor` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario` | Redactor o editor (ON DELETE SET NULL). |
| `fecha_publicacion` | `DATETIME` | Sí | `NULL` | Fecha y hora de lanzamiento público. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación del borrador. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, auto | Momento de última edición. |

---

## 8. Resoluciones Arquitectónicas Aplicadas en la Normalización

1. **Nombre de Base de Datos Unificado:** Se estandarizó el esquema en `innegone_bd_medicdate`, alineando la base de datos física con los scripts de backend PHP/Laravel existentes (`conexion.php`).
2. **Normalización de Servicios (3FN):** Se eliminó la tabla redundante `servicio`, integrando sus atributos de ordenamiento y presentación web (`resumen`, `orden`, `publicado_web`) dentro de `tipo_atencion`, el cual mantiene la clave foránea a `especialidad`.
3. **Reseñas Externas e Integridad:** Se confirmó `nombre_autor VARCHAR(100) NOT NULL` con `id_paciente` anulable (`NULLable`), satisfaciendo la regla de negocio que permite valoraciones tanto de pacientes autenticados como de usuarios externos.
4. **Asignación Obligatoria de Médico y Canal de Registro:** En `cita`, `id_empleado` se mantiene como `NOT NULL` garantizando que ninguna cita clínica carezca de médico responsable; se incorporó `canal_registro ENUM('movil','web','escritorio') NOT NULL DEFAULT 'movil'` para identificar automáticamente el origen de la reserva.
5. **Doble Esquema de Recuperación:** Coexisten de forma armónica `token_recuperacion` (flujo mediante enlace y correo) y `pregunta_secreta` junto a `usuario_pregunta_secreta`. Esta última implementa clave primaria compuesta `(id_usuario, id_pregunta_secreta)`, posibilitando configurar 1 o múltiples preguntas por usuario según se defina operativamente.
6. **Módulo de Direcciones Completo:** Se integró el catálogo `municipio` (con los 84 municipios de Hidalgo) y la tabla `direccion` relacionada a `persona`, normalizando los domicilios de pacientes y empleados sin duplicar datos en tablas secundarias.
