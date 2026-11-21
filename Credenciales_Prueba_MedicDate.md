# Credenciales y Datos de Prueba del Sistema MedicDate
**Proyecto:** Sistema Integral de Gestión de Citas Médicas – Centro Médico Sagrado Corazón  
**Base de Datos Normalizada (v2.1):** `innegone_bd_medicdate`  
**Host de Despliegue:** `medicdate.innego.net`  
**Fecha de Actualización:** Noviembre 2026  

---

## 1. Parámetros de Conexión al Servidor de Base de Datos

| Parámetro | Valor | Notas |
|---|---|---|
| **Motor** | MySQL / MariaDB | Charset `utf8mb4`, Collation `utf8mb4_unicode_ci` |
| **Host** | `medicdate.innego.net` | IP pública: `174.136.37.110` |
| **Puerto** | `3306` | Abierto y verificado |
| **Base de Datos** | `innegone_bd_medicdate` | 31 tablas normalizadas en 3FN |
| **Usuario DB** | `innegone_u_medicdate` | Usuario con permisos DDL y DML completos |
| **Contraseña DB** | `*EzsnHGD8%)mdEgu` | Configurada en `medicDateApis/config/conexion.php` |

---

## 2. Parámetros de los Endpoints API REST

| Servicio / Endpoint | Método | URL Completa | Parámetros Clave |
|---|---|---|---|
| **Login / Autenticación** | `POST` | `https://medicdate.innego.net/medicDateApis/login.php` | Body JSON: `correo_acceso`, `password` |
| **Catálogo de Citas** | `GET` | `https://medicdate.innego.net/medicDateApis/catalogo_citas.php` | Ninguno (retorna especialidades, doctores y tipos de atención) |
| **Disponibilidad Horaria** | `GET` | `https://medicdate.innego.net/medicDateApis/Disponibilidad.php` | Query: `id_empleado`, `fecha` (ej. `YYYY-MM-DD`) |
| **Reservar Cita** | `POST` | `https://medicdate.innego.net/medicDateApis/reservar_cita.php` | Body JSON: `id_paciente`, `id_empleado`, `id_tipo_atencion`, `fecha_hora_inicio`, `motivo_consulta`, `canal_registro` |
| **Citas del Paciente** | `GET` | `https://medicdate.innego.net/medicDateApis/citas_paciente.php` | Query: `id_paciente`, `estado` (opcional) |
| **Detalle de Cita** | `GET` | `https://medicdate.innego.net/medicDateApis/detalle_cita.php` | Query: `id_cita` |
| **Registro de Paciente** | `POST` | `https://medicdate.innego.net/medicDateApis/registro.php` | Body JSON: `nombres`, `apellido_paterno`, `correo`, `telefono`, `password` |

> [!NOTE]
> Las peticiones HTTP son redirigidas obligatoriamente con código `301` hacia el protocolo seguro **HTTPS** (`https://medicdate.innego.net`).

---

## 3. Parámetros Generales de Seguridad de Prueba

* **Contraseña Universal de Prueba:** `Prueba123!`
* **Algoritmo de Cifrado:** Bcrypt (`PASSWORD_BCRYPT`, coste 10 en PHP).
* **Hash Bcrypt Almacenado:** `$2y$10$reOHrQvpZlRP1k3pZwchMe62D00akETHI2i5AA3UVMBgG4v2rYd7y`  
  *(Válido para PHP `password_verify("Prueba123!", $hash)`)*.
* **Pregunta Secreta Configurada:** `id_pregunta_secreta = 1` (*"¿Cuál es el nombre de tu primera mascota?"*).
* **Respuesta Secreta Universal:** `pelusa`
* **Hash SHA-256 de Respuesta:** `6201b147321e1d0339d1b747385f0ef3dbfb6886e2467d3dd4b4e340a6b223c6`

---

## 4. Directorio de Cuentas de Acceso por Perfil

### 4.1 Módulo Administrativo

#### Cuenta Administrador General
* **ID Usuario:** `1`
* **ID Persona:** `1`
* **Nombre Completo:** Lic. Carlos Vega Mendoza
* **Correo de Acceso (Usuario):** `carlos.vega.admin@medicdate.com`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `administrador`
* **Teléfono:** `7711000001`
* **Estado:** `activo`
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Alcance Funcional:** Gestión total de usuarios, roles, consultorios, catálogo médico, bloqueos de agenda y auditoría del sistema.
* **Plataformas de Uso:** Panel Web Administrativo y Sistema de Escritorio (WinForms).

---

### 4.2 Módulo de Personal Médico (Doctores)

#### Doctor 1: Medicina General
* **ID Usuario:** `2`
* **ID Persona:** `2`
* **ID Empleado:** `1`
* **Nombre Completo:** Dr. José Manuel Rodríguez López
* **Correo de Acceso (Usuario):** `jose.rodriguez.doc@example.test`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `medico`
* **Teléfono:** `5550000001`
* **Cédula Profesional:** `MED-100201`
* **Consultorio Asignado:** Consultorio 101 (Planta Baja)
* **Especialidad:** Medicina General (`id_especialidad: 1`)
* **Tipos de Atención:**
  * Consulta General (`id: 1`, $350.00 MXN, 30 min)
  * Certificado Médico (`id: 2`, $200.00 MXN, 20 min)
* **Horario de Atención:** Lunes a Viernes de 08:00 a 14:00 hrs.
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Plataformas de Uso:** Panel Web de Médico y Sistema de Escritorio.

#### Doctora 2: Pediatría y Cardiología
* **ID Usuario:** `3`
* **ID Persona:** `3`
* **ID Empleado:** `2`
* **Nombre Completo:** Dra. Sofía Flores Reyes
* **Correo de Acceso (Usuario):** `sofia.flores.doc@medicdate.com`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `medico`
* **Teléfono:** `5550000002`
* **Cédula Profesional:** `PED-200301`
* **Consultorio Asignado:** Consultorio 102 (Planta Baja)
* **Especialidades:** 
  * Pediatría (`id_especialidad: 2`, principal)
  * Cardiología (`id_especialidad: 4`, secundaria)
* **Tipos de Atención:**
  * Consulta Pediátrica (`id: 3`, $450.00 MXN, 40 min)
  * Control de Niño Sano (`id: 4`, $400.00 MXN, 30 min)
  * Electrocardiograma (`id: 6`, $600.00 MXN, 30 min)
* **Horario de Atención:** Lunes a Viernes de 09:00 a 15:00 hrs.
* **Bloqueo Registrado (Prueba):** `2026-12-01` de 10:00 a 12:00 hrs (*Capacitación médica interna*).
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Plataformas de Uso:** Panel Web de Médico y Sistema de Escritorio.

---

### 4.3 Módulo de Asistencia / Recepción

#### Asistente de Recepción
* **ID Usuario:** `4`
* **ID Persona:** `4`
* **ID Empleado:** `3`
* **Nombre Completo:** Luna Aurora Reyes Morales
* **Correo de Acceso (Usuario):** `luna.reyes.asistente@example.test`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `asistente`
* **Teléfono:** `5550000003`
* **Turno Asignado:** Matutino
* **Estado:** `activo`
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Alcance Funcional:** Recepción física y telefónica de pacientes, agendación manual de citas, cambio de estados (confirmada, cancelada, inasistencia), registro de ausencias y bloqueos.
* **Plataformas de Uso:** Sistema de Escritorio (WinForms) y Panel Web.

---

### 4.4 Módulo de Pacientes

#### Paciente 1 (Cuenta Principal de Pruebas Móviles)
* **ID Usuario:** `5`
* **ID Persona:** `5`
* **ID Paciente:** `1`
* **Nombre Completo:** Ronaldo Hernández Hernández
* **Correo de Acceso (Usuario):** `ronaldo@gmail.com`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `paciente`
* **Teléfono:** `7711008968`
* **CURP:** `HEHR000101HDFRRN01`
* **NSS:** `12345678901`
* **Alergias:** Penicilina
* **Dirección:** Av. Revolución #405, Col. Centro, Pachuca de Soto, Hidalgo (CP 42000)
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Citas Activas Cargadas:**
  * **Cita #1:** `2026-11-25 09:00:00` | Dr. José Rodríguez | Consulta General | Estado: `confirmada` | Canal: `movil`
  * **Cita #2:** `2026-11-26 10:00:00` | Dra. Sofía Flores | Electrocardiograma | Estado: `pendiente` | Canal: `movil`
* **Plataformas de Uso:** Aplicación Móvil (Android) y Portal Web del Paciente.

#### Paciente 2
* **ID Usuario:** `6`
* **ID Persona:** `6`
* **ID Paciente:** `2`
* **Nombre Completo:** María López Martínez
* **Correo de Acceso (Usuario):** `maria.lopez@example.com`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `paciente`
* **Teléfono:** `5512345602`
* **CURP:** `LOMM950512MDFRR01`
* **NSS:** `98765432101`
* **Alergias:** Ninguna
* **Dirección:** Calle Guerrero #12, Mineral de la Reforma, Hidalgo (CP 42180)
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Citas Activas Cargadas:**
  * **Cita #3:** `2026-11-27 11:00:00` | Dra. Sofía Flores | Consulta Pediátrica | Estado: `confirmada` | Canal: `movil`
* **Plataformas de Uso:** Aplicación Móvil (Android) y Portal Web del Paciente.

#### Paciente 3
* **ID Usuario:** `7`
* **ID Persona:** `7`
* **ID Paciente:** `3`
* **Nombre Completo:** Juan Pérez García
* **Correo de Acceso (Usuario):** `juan.perez@example.com`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `paciente`
* **Teléfono:** `5512345678`
* **CURP:** `PEGJ900215HDFRR02`
* **NSS:** `55443322110`
* **Alergias:** Polen y AINEs
* **Dirección:** Calle Juárez #78, Tulancingo de Bravo, Hidalgo (CP 43600)
* **Pregunta Secreta:** ¿Cuál es el nombre de tu primera mascota? | **Respuesta:** `pelusa`
* **Citas Activas Cargadas:**
  * **Cita #4:** `2026-11-28 08:30:00` | Dr. José Rodríguez | Certificado Médico | Estado: `pendiente` | Canal: `escritorio`
* **Plataformas de Uso:** Aplicación Móvil (Android) y Portal Web del Paciente.

#### Paciente 4 (Creado por Test de API `registro.php`)
* **ID Usuario:** `8`
* **ID Persona:** `8`
* **ID Paciente:** `4`
* **Nombre Completo:** Valeria Montes Serrano
* **Correo de Acceso (Usuario):** `nuevo.paciente.test@medicdate.com`
* **Contraseña:** `Prueba123!`
* **Rol Asignado:** `paciente`
* **Teléfono:** `7719998877`
* **Plataformas de Uso:** Aplicación Móvil (Android) y Portal Web del Paciente.

---

## 5. Matriz de Acceso por Plataforma

```
+------------------------------------+-----------------+--------------------+--------------------+
| Rol / Perfil                       | Android (Móvil) | Escritorio (Forms) | Web Administrativa |
+------------------------------------+-----------------+--------------------+--------------------+
| Administrador                      |       No        |         Sí         |         Sí         |
| Médico                             |       No        |         Sí         |         Sí         |
| Asistente / Recepcionista          |       No        |         Sí         |         Sí         |
| Paciente                           |       Sí        |         No         |         Sí         |
+------------------------------------+-----------------+--------------------+--------------------+
```

---

## 6. Ejemplos Prácticos de Consumo API con cURL

### 6.1 Autenticación (Login)
```bash
curl -X POST "https://medicdate.innego.net/medicDateApis/login.php" \
     -H "Content-Type: application/json" \
     -d '{"correo_acceso": "ronaldo@gmail.com", "password": "Prueba123!"}'
```

### 6.2 Consulta de Disponibilidad de Horarios
```bash
# Consultar horarios disponibles del Dr. José Rodríguez (id: 1) para el 25 de Noviembre de 2026
curl -X GET "https://medicdate.innego.net/medicDateApis/Disponibilidad.php?id_empleado=1&fecha=2026-11-25"
```

### 6.3 Reservar una Nueva Cita
```bash
curl -X POST "https://medicdate.innego.net/medicDateApis/reservar_cita.php" \
     -H "Content-Type: application/json" \
     -d '{
       "id_paciente": 1,
       "id_empleado": 1,
       "id_tipo_atencion": 1,
       "fecha_hora_inicio": "2026-11-29 11:00:00",
       "motivo_consulta": "Dolor de cabeza recurrente y revisión general",
       "canal_registro": "movil"
     }'
```

### 6.4 Ver Citas del Paciente
```bash
curl -X GET "https://medicdate.innego.net/medicDateApis/citas_paciente.php?id_paciente=1"
```
