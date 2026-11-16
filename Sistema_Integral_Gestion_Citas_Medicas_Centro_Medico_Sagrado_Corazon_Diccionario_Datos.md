# Sistema Integral de Gestión de Citas Médicas para el Centro Médico Sagrado Corazón — Diccionario de datos

> **Versión:** modelo propuesto `medicdate_multiplataforma.sql` para la versión multiplataforma de citas. Este documento describe el DDL actual de 23 tablas; no es un modelo del esquema legado ni una migración, y todavía no cubre los módulos clínico-administrativos de la cotización integral ampliada.

## Convenciones

- **PK:** clave primaria; **FK:** clave foránea; **UQ:** índice/valor único; **AI:** autoincremental.
- **Nulo:** `No` significa `NOT NULL`; `Sí` significa que permite `NULL`.
- Los campos `DATETIME` almacenan fecha y hora. La zona horaria de aplicación debe acordarse y normalizarse.
- Los campos `activo` son `TINYINT(1)` y usan `1` para activo, `0` para inactivo.
- Las claves foráneas, acciones `ON DELETE`/`ON UPDATE`, índices y restricciones completas están en el DDL. Aquí se señalan las principales.

## Identidad y autorización

### `persona`

Datos personales de contacto que pueden asociarse a una cuenta y a un perfil de paciente o empleado.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_persona` | `BIGINT UNSIGNED` | No | PK, AI | Identificador interno de la persona. |
| `nombres` | `VARCHAR(100)` | No | — | Nombres de la persona. |
| `apellido_paterno` | `VARCHAR(80)` | No | — | Primer apellido. |
| `apellido_materno` | `VARCHAR(80)` | Sí | `NULL` | Segundo apellido, si existe. |
| `fecha_nacimiento` | `DATE` | Sí | `NULL` | Fecha de nacimiento. |
| `correo_contacto` | `VARCHAR(254)` | Sí | `NULL` | Correo de contacto; no es necesariamente el identificador de acceso. |
| `telefono_principal` | `VARCHAR(25)` | Sí | `NULL` | Teléfono principal. |
| `telefono_secundario` | `VARCHAR(25)` | Sí | `NULL` | Teléfono alternativo. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación del registro. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, autoactualización | Última modificación del registro. |

### `usuario`

Cuenta de autenticación asociada a una persona. Los permisos se asignan por medio de `usuario_rol`.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_usuario` | `BIGINT UNSIGNED` | No | PK, AI | Identificador de la cuenta. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK, UQ → `persona.id_persona` | Persona propietaria de la cuenta; una persona tiene como máximo una cuenta en este modelo. |
| `correo_acceso` | `VARCHAR(254)` | No | UQ | Correo utilizado como identificador de acceso. |
| `password_hash` | `VARCHAR(255)` | No | — | Hash de contraseña generado con un algoritmo específico para contraseñas; nunca guardar contraseña en claro. |
| `estado` | `ENUM('activa','inactiva','bloqueada')` | No | `'activa'` | Estado de la cuenta. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación de la cuenta. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, autoactualización | Última modificación de la cuenta. |
| `ultimo_acceso` | `DATETIME` | Sí | `NULL` | Fecha y hora del último acceso correcto. |

### `rol`

Catálogo de roles funcionales.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_rol` | `SMALLINT UNSIGNED` | No | PK, AI | Identificador del rol. |
| `nombre` | `VARCHAR(40)` | No | UQ | Código/nombre del rol, por ejemplo administrador, asistente, médico o paciente. |
| `descripcion` | `VARCHAR(255)` | Sí | `NULL` | Descripción del propósito del rol. |

### `permiso`

Catálogo de acciones autorizables. El catálogo se crea vacío en el DDL y requiere carga/mantenimiento aprobados.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_permiso` | `SMALLINT UNSIGNED` | No | PK, AI | Identificador del permiso. |
| `codigo` | `VARCHAR(80)` | No | UQ | Código estable del permiso para validación en Laravel. |
| `descripcion` | `VARCHAR(255)` | Sí | `NULL` | Explicación de la acción autorizada. |

### `usuario_rol`

Tabla puente que permite asignar uno o más roles a una cuenta.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_usuario` | `BIGINT UNSIGNED` | No | PK compuesta, FK → `usuario.id_usuario` | Cuenta a la que se asigna el rol. |
| `id_rol` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `rol.id_rol` | Rol asignado a la cuenta. |
| `fecha_asignacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Momento en que se asignó el rol. |

### `rol_permiso`

Tabla puente entre roles y permisos. La asignación concreta no viene precargada.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_rol` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `rol.id_rol` | Rol que recibe el permiso. |
| `id_permiso` | `SMALLINT UNSIGNED` | No | PK compuesta, FK → `permiso.id_permiso` | Permiso concedido al rol. |

## Perfiles

### `paciente`

Perfil de paciente asociado a una persona. Los datos de dirección del esquema legado aún no están modelados aquí.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_paciente` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del perfil de paciente. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK, UQ → `persona.id_persona` | Persona a la que corresponde el perfil. |
| `alergias` | `TEXT` | Sí | `NULL` | Información de alergias; dato sensible, con acceso restringido y retención definida. |
| `notas_medicas` | `TEXT` | Sí | `NULL` | Notas médicas; dato sensible, con acceso restringido y retención definida. |
| `estado` | `ENUM('activo','inactivo')` | No | `'activo'` | Estado administrativo del perfil. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de alta del perfil. |

### `empleado`

Perfil laboral común de médicos y asistentes. La pertenencia a un subtipo se representa en `doctor` y/o `asistente`.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK, AI | Identificador interno del empleado. |
| `id_persona` | `BIGINT UNSIGNED` | No | FK, UQ → `persona.id_persona` | Persona correspondiente al empleado. |
| `curp` | `CHAR(18)` | Sí | UQ, `NULL` | CURP, si su uso y tratamiento son aprobados. |
| `fecha_contratacion` | `DATE` | Sí | `NULL` | Fecha de contratación. |
| `estado` | `ENUM('activo','inactivo')` | No | `'activo'` | Estado laboral en el sistema. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de alta del registro laboral. |

### `asistente`

Datos específicos del perfil de asistente.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK, FK → `empleado.id_empleado` | Empleado que desempeña el perfil de asistente. |
| `turno` | `VARCHAR(30)` | Sí | `NULL` | Descripción del turno laboral. |

### `doctor`

Datos específicos del perfil médico.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK, FK → `empleado.id_empleado` | Empleado que desempeña el perfil médico. |
| `cedula_profesional` | `VARCHAR(50)` | No | UQ | Identificador de cédula profesional. |

## Catálogos de atención

### `especialidad`

Catálogo de especialidades médicas.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_especialidad` | `INT UNSIGNED` | No | PK, AI | Identificador de la especialidad. |
| `nombre` | `VARCHAR(100)` | No | UQ | Nombre único de la especialidad. |
| `descripcion` | `TEXT` | Sí | `NULL` | Descripción ampliada. |
| `activo` | `TINYINT(1)` | No | `1` | Indica si se ofrece para nuevas operaciones. |

### `doctor_especialidad`

Relación muchos-a-muchos entre médicos y especialidades.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_empleado` | `BIGINT UNSIGNED` | No | PK compuesta, FK → `doctor.id_empleado` | Médico relacionado con la especialidad. |
| `id_especialidad` | `INT UNSIGNED` | No | PK compuesta, FK → `especialidad.id_especialidad` | Especialidad relacionada con el médico. |

### `consultorio`

Catálogo de consultorios o espacios de atención.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_consultorio` | `INT UNSIGNED` | No | PK, AI | Identificador del consultorio. |
| `codigo` | `VARCHAR(30)` | No | UQ | Código único identificador. |
| `nombre` | `VARCHAR(100)` | Sí | `NULL` | Nombre visible del espacio. |
| `descripcion` | `VARCHAR(255)` | Sí | `NULL` | Descripción complementaria. |
| `activo` | `TINYINT(1)` | No | `1` | Indica si puede asignarse a una nueva atención. |

### `tipo_atencion`

Catálogo de servicios/tipos de atención y su duración y costo de referencia.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_tipo_atencion` | `INT UNSIGNED` | No | PK, AI | Identificador del tipo de atención. |
| `id_especialidad` | `INT UNSIGNED` | Sí | FK → `especialidad.id_especialidad`, `NULL` | Especialidad asociada, si aplica. |
| `nombre` | `VARCHAR(120)` | No | UQ compuesto con `id_especialidad` | Nombre del servicio dentro del catálogo correspondiente. |
| `descripcion` | `TEXT` | Sí | `NULL` | Detalle del servicio. |
| `duracion_minutos` | `SMALLINT UNSIGNED` | No | CHECK `> 0` | Duración prevista de una atención. |
| `costo_base` | `DECIMAL(10,2)` | Sí | CHECK `>= 0`, `NULL` | Costo de referencia; la cita conserva el costo efectivamente registrado. |
| `moneda` | `CHAR(3)` | No | `'MXN'` | Código de moneda ISO de tres caracteres. |
| `activo` | `TINYINT(1)` | No | `1` | Indica si el tipo de atención puede reservarse. |

## Agenda y citas

### `horario_atencion`

Disponibilidad recurrente de un médico, con vigencia e intervalo de atención.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_horario` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del horario. |
| `id_empleado` | `BIGINT UNSIGNED` | No | FK → `doctor.id_empleado` | Médico al que pertenece el horario. |
| `id_consultorio` | `INT UNSIGNED` | Sí | FK → `consultorio.id_consultorio`, `NULL` | Consultorio preferido/asignado, si aplica. |
| `dia_semana` | `TINYINT UNSIGNED` | No | CHECK `1–7` | Día ISO-8601: lunes=1 y domingo=7. |
| `hora_inicio` | `TIME` | No | — | Hora inicial del intervalo de trabajo. |
| `hora_fin` | `TIME` | No | CHECK posterior a `hora_inicio` | Hora final del intervalo de trabajo. |
| `intervalo_minutos` | `SMALLINT UNSIGNED` | No | `30`, CHECK `> 0` | Duración base de cada bloque de disponibilidad. |
| `vigencia_desde` | `DATE` | No | — | Primer día en que aplica el horario. |
| `vigencia_hasta` | `DATE` | Sí | `NULL` | Último día de vigencia; `NULL` indica sin fecha final definida. |
| `activo` | `TINYINT(1)` | No | `1` | Indica si el horario está habilitado. |

### `bloqueo_horario`

Excepción de disponibilidad que impide reservar un intervalo del médico y, opcionalmente, de un consultorio.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_bloqueo` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del bloqueo. |
| `id_empleado` | `BIGINT UNSIGNED` | No | FK → `doctor.id_empleado` | Médico cuya agenda se bloquea. |
| `id_consultorio` | `INT UNSIGNED` | Sí | FK → `consultorio.id_consultorio`, `NULL` | Consultorio adicionalmente afectado. |
| `inicio` | `DATETIME` | No | — | Inicio del bloqueo. |
| `fin` | `DATETIME` | No | CHECK `> inicio` | Fin del bloqueo. |
| `motivo` | `VARCHAR(255)` | Sí | `NULL` | Motivo administrativo; evitar información sensible innecesaria. |
| `id_usuario_registro` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Cuenta que registró el bloqueo. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de registro del bloqueo. |

### `cita`

Reserva de atención para un paciente, médico y tipo de atención. Los conflictos de intervalo requieren validación transaccional en Laravel.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_cita` | `BIGINT UNSIGNED` | No | PK, AI | Identificador de la cita. |
| `id_paciente` | `BIGINT UNSIGNED` | No | FK → `paciente.id_paciente` | Paciente atendido. |
| `id_empleado` | `BIGINT UNSIGNED` | No | FK → `doctor.id_empleado` | Médico asignado. |
| `id_consultorio` | `INT UNSIGNED` | Sí | FK → `consultorio.id_consultorio`, `NULL` | Espacio reservado, si aplica. |
| `id_tipo_atencion` | `INT UNSIGNED` | No | FK → `tipo_atencion.id_tipo_atencion` | Servicio o tipo de atención reservado. |
| `inicio` | `DATETIME` | No | — | Fecha y hora de inicio de la cita. |
| `fin` | `DATETIME` | No | CHECK `> inicio` | Fecha y hora de finalización. |
| `estado` | `ENUM('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia')` | No | `'pendiente'` | Estado de la cita; sus transiciones se validan en la API. |
| `motivo` | `VARCHAR(500)` | Sí | `NULL` | Motivo de consulta, si se requiere y autoriza. Puede contener información sensible. |
| `notas_internas` | `TEXT` | Sí | `NULL` | Notas restringidas al personal autorizado; no son visibles al paciente por defecto. |
| `costo` | `DECIMAL(10,2)` | Sí | CHECK `>= 0`, `NULL` | Costo registrado para esta cita. |
| `moneda` | `CHAR(3)` | No | `'MXN'` | Moneda del costo registrado. |
| `id_usuario_registro` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Cuenta que creó la cita. |
| `id_usuario_cancelacion` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario`, `NULL` | Cuenta que realizó la cancelación. |
| `motivo_cancelacion` | `VARCHAR(500)` | Sí | `NULL` | Motivo de cancelación, si se define como requerido. |
| `fecha_cancelacion` | `DATETIME` | Sí | `NULL` | Momento de cancelación; CHECK exige valor cuando estado es cancelado y NULL en otro caso. |
| `fecha_registro` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación del registro. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, autoactualización | Última modificación de la cita. |

### `historial_cita`

Bitácora de acciones y transiciones de estado de cada cita.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_historial` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del evento de historial. |
| `id_cita` | `BIGINT UNSIGNED` | No | FK → `cita.id_cita` | Cita afectada. |
| `id_usuario` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario`, `NULL` | Cuenta que originó el evento, si está disponible. |
| `estado_anterior` | `ENUM('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia')` | Sí | `NULL` | Estado previo de la cita. |
| `estado_nuevo` | `ENUM('pendiente','confirmada','en_progreso','completada','cancelada','inasistencia')` | Sí | `NULL` | Estado posterior de la cita. |
| `accion` | `VARCHAR(60)` | No | — | Código descriptivo de la operación realizada. |
| `observacion` | `VARCHAR(500)` | Sí | `NULL` | Explicación breve sin datos sensibles innecesarios. |
| `fecha_evento` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha y hora del evento. |

## Acceso, notificaciones y contenido

### `sesion_usuario`

Registro de sesiones por cliente. Solo debe guardarse el hash del token.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_sesion` | `BIGINT UNSIGNED` | No | PK, AI | Identificador de sesión. |
| `id_usuario` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Usuario propietario. |
| `token_hash` | `CHAR(64)` ASCII binario | No | UQ | Hash del token aleatorio; nunca almacenar token en claro. |
| `plataforma` | `ENUM('web','android','escritorio')` | No | — | Plataforma que creó la sesión. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Inicio de la sesión. |
| `fecha_expiracion` | `DATETIME` | No | CHECK posterior a creación | Límite de vigencia. |
| `fecha_revocacion` | `DATETIME` | Sí | `NULL` | Momento de cierre/revocación anticipada. |

### `token_recuperacion`

Token de un solo uso para recuperación de contraseña o verificación de correo.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_token` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del token. |
| `id_usuario` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Usuario al que pertenece. |
| `token_hash` | `CHAR(64)` ASCII binario | No | UQ | Hash del token aleatorio. |
| `proposito` | `ENUM('recuperacion_contrasena','verificacion_correo')` | No | — | Uso permitido del token. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de emisión. |
| `fecha_expiracion` | `DATETIME` | No | CHECK posterior a creación | Fecha de caducidad. |
| `fecha_consumo` | `DATETIME` | Sí | `NULL` | Fecha en que se utilizó; `NULL` significa no consumido. |

### `notificacion`

Mensaje dirigido a una cuenta, relacionado opcionalmente con una cita.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_notificacion` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del aviso. |
| `id_usuario` | `BIGINT UNSIGNED` | No | FK → `usuario.id_usuario` | Destinatario. |
| `id_cita` | `BIGINT UNSIGNED` | Sí | FK → `cita.id_cita`, `NULL` | Cita relacionada, si aplica. |
| `tipo` | `VARCHAR(60)` | No | — | Código del evento/plantilla de notificación. |
| `canal` | `ENUM('interno','correo','push','sms')` | No | `'interno'` | Canal seleccionado. Requiere configuración, consentimiento y proveedor si aplica. |
| `estado_envio` | `ENUM('pendiente','enviada','fallida')` | No | `'pendiente'` | Estado de entrega. |
| `titulo` | `VARCHAR(160)` | No | — | Título visible del aviso. |
| `mensaje` | `TEXT` | Sí | `NULL` | Contenido; no incluir información clínica innecesaria. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de creación. |
| `fecha_envio` | `DATETIME` | Sí | `NULL` | Fecha del intento/entrega registrado. |
| `fecha_lectura` | `DATETIME` | Sí | `NULL` | Fecha de lectura del aviso interno. |
| `codigo_error` | `VARCHAR(80)` | Sí | `NULL` | Código técnico de fallo, sin credenciales o tokens. |

### `contenido_informativo`

Contenido administrable para el portal público.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_contenido` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del contenido. |
| `slug` | `VARCHAR(160)` | No | UQ | Identificador legible y único para URL/ruta. |
| `titulo` | `VARCHAR(200)` | No | — | Título publicado. |
| `cuerpo` | `MEDIUMTEXT` | No | — | Cuerpo del contenido. |
| `estado` | `ENUM('borrador','publicado','archivado')` | No | `'borrador'` | Estado editorial. Solo publicado debe exponerse al público. |
| `id_usuario_autor` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario`, `NULL` | Autor, si la cuenta sigue disponible. |
| `fecha_publicacion` | `DATETIME` | Sí | `NULL` | Fecha de publicación. |
| `fecha_creacion` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha de alta. |
| `fecha_actualizacion` | `DATETIME` | No | `CURRENT_TIMESTAMP`, autoactualización | Última modificación. |

### `auditoria`

Eventos relevantes de seguridad y administración.

| Campo | Tipo | Nulo | Clave / valor inicial | Descripción |
|---|---|---:|---|---|
| `id_auditoria` | `BIGINT UNSIGNED` | No | PK, AI | Identificador del evento. |
| `id_usuario` | `BIGINT UNSIGNED` | Sí | FK → `usuario.id_usuario`, `NULL` | Cuenta relacionada; puede no existir para eventos anónimos o históricos. |
| `modulo` | `VARCHAR(60)` | No | — | Módulo funcional que originó el evento. |
| `accion` | `VARCHAR(80)` | No | — | Acción ejecutada o intentada. |
| `entidad` | `VARCHAR(80)` | Sí | `NULL` | Tipo de entidad afectada. |
| `id_registro` | `VARCHAR(80)` | Sí | `NULL` | ID lógico del registro afectado, almacenado como texto para admitir diferentes tipos de clave. |
| `resultado` | `ENUM('correcto','rechazado','error')` | No | — | Resultado de la operación. |
| `observacion` | `VARCHAR(500)` | Sí | `NULL` | Contexto limitado y no sensible del evento. |
| `fecha_evento` | `DATETIME` | No | `CURRENT_TIMESTAMP` | Fecha del evento de auditoría. |

## Decisiones de modelo por resolver

1. La cuenta y los perfiles se relacionan con `persona`, pero las FK no fuerzan que un paciente o empleado tenga cuenta ni que sus roles coincidan con el perfil. Laravel debe imponer la correspondencia y el alcance de acceso.
2. El esquema no conserva calle, colonia, número, localidad ni municipio del paciente legado. Añadirlos o definir una política de no migración antes de importar datos.
3. `cita.id_tipo_atencion` es obligatorio aunque el esquema legado no contiene ese dato; la migración necesita asignación verificada, tipo genérico aprobado o tratamiento explícito de registros históricos.
4. El DDL no define entidades de dirección, consentimiento, sucursal, facturación ni expediente clínico longitudinal.
5. `usuario.estado` no sustituye el estado del perfil de persona, paciente o empleado; las transiciones y su significado deben definirse en la API.
6. La relación consultorio/horario permite asignar consultorio al horario, pero el DDL no restringe por sí mismo citas simultáneas de un mismo consultorio. Validar esa regla transaccionalmente en Laravel.

### Referencias

- [`medicdate_multiplataforma.sql`](./medicdate_multiplataforma.sql): definición efectiva de tablas, columnas, claves, índices y restricciones.
- [`Sistema_Integral_Gestion_Citas_Medicas_Centro_Medico_Sagrado_Corazon_Resumen_Proyecto.md`](./Sistema_Integral_Gestion_Citas_Medicas_Centro_Medico_Sagrado_Corazon_Resumen_Proyecto.md): alcance, diagramas, procesos y revisión de compatibilidad con el escritorio.
