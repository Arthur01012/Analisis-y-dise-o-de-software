# Documentación Técnica: Módulo de Reserva y Confirmación de Citas

## 1. Resumen del Módulo

El **Módulo de Reserva y Confirmación de Citas** es el componente central de interacción de la aplicación móvil **MedicDate**. Su objetivo es permitir a los pacientes consultar la disponibilidad de horarios de un doctor en tiempo real, filtrar por días de atención y tipo de servicio, seleccionar una franja horaria válida y confirmar la reserva de manera atómica con el backend.

---

## 2. Arquitectura del Módulo (MVP)

El módulo sigue la arquitectura **Model-View-Presenter (MVP)**, garantizando la separación entre la interfaz gráfica, la lógica de presentación y el consumo de datos de red.

```mermaid
graph TD
    subgraph "Módulo de Reserva (MVP)"
        V["Vistas: RecervarCitaActivity / ConfirmarCitaActivity / CitaConfirmadaActivity"] <--> P["Presentadores: clsPresentadorReservaCita / clsPresentadorConfirmarCita"]
        P <--> M["Modelos de Lógica: clsDisponibilidadModelo / clsReservaCitaModelo"]
        M <--> D["Modelos de Datos: dataDisponibilidad / dataReserva / Horario"]
        M <--> R["Red: RetrofitCliente / ApiService"]
        SM["SessionManager (SharedPreferences)"] .-> V
    end

    subgraph "Servicios REST Backend (PHP)"
        R <--> API["APIs: disponibilidad.php / reservar_cita.php"]
    end
```

---

## 3. Componentes del Módulo

### 3.1 Vistas y Pantallas (`com.example.medicdate.Vista`)

#### 1. [`RecervarCitaActivity.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Vista/RecervarCitaActivity.kt)
- **Responsabilidad**: Interfaz gráfica para la selección de fecha y hora. Implementa explícitamente `View.OnClickListener`, `RadioGroup.OnCheckedChangeListener`, `WeekSwipeLayout.OnDateChangeListener` y `WeekSwipeLayout.OnWeekSwipeListener`, conservando la estructura por defecto de `onCreate` con `ViewCompat.setOnApplyWindowInsetsListener`.
- **Elementos UI**:
  - Encabezado dinámico con iniciales, nombre y especialidad del doctor.
  - Conmutador de tipo de atención (*Primera consulta - 30 min* / *Seguimiento - 20 min*) con actualización dinámica de bordes (`bg_option_selected` / `bg_option_default`).
  - Navegador semanal interactivo (`WeekSwipeLayout`) con botones anterior/siguiente y gestos táctiles (*swipe*). Al recibir `dias_atencion`, reenfoca automáticamente al primer día hábil futuro del médico y recarga la disponibilidad de esa fecha.
  - Cargador esqueleto animado (*Skeleton Shadow Load*) que se pulsa mientras se consulta la API.
  - Cuadrícula independiente de horarios (`rvHorarios` con `GridLayoutManager` y `HorarioAdapter : View.OnClickListener`) que muestra tachados y deshabilitados los horarios ocupados o bloqueados por `bloqueo_horario`.
  - Barra de resumen inferior con botón de acción **"Continuar"** que envía los datos a `ConfirmarCitaActivity` mediante constantes `EXTRA_*` definidas en `companion object`.

#### 2. [`ConfirmarCitaActivity.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Vista/ConfirmarCitaActivity.kt)
- **Responsabilidad**: Resumen pre-reserva de la cita. Implementa `View.OnClickListener`, conserva la estructura por defecto de `onCreate` y define sus constantes `EXTRA_*` en `companion object`.
- **Funcionalidad**: Valida la sesión activa del usuario vía `SessionManager`. Muestra el desglose del doctor, especialidad y tipo de atención, fecha/hora formateada (*ej. "Jueves 26 de noviembre de 2026 · 10:30"*) y consultorio. Al presionar **"Confirmar cita"**, invoca la transacción final.
- **Notificación de solapamiento / horario bloqueado**: Si el backend responde con conflicto (`HTTP 409`, `accion = "elegir_otro_horario"`, o códigos `MEDICO_OCUPADO`, `PACIENTE_OCUPADO`, `CONSULTORIO_OCUPADO`, `AGENDA_BLOQUEADA`, `HORARIO_NO_DISPONIBLE`, `CONSULTORIO_NO_DISPONIBLE`, `AGENDA_ACTUALIZADA`), muestra el banner `conflict_message` con la primera oración resaltada en negritas y reemplaza las acciones por el botón principal **"Elegir otro horario"** para regresar y refrescar disponibilidad.

#### 3. [`CitaConfirmadaActivity.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Vista/CitaConfirmadaActivity.kt)
- **Responsabilidad**: Pantalla de éxito post-reserva. Implementa `View.OnClickListener`, conserva la estructura por defecto de `onCreate` y recibe sus datos mediante constantes `EXTRA_*` en `companion object`.
- **Funcionalidad**: Despliega la confirmación con especialidad, médico, fecha/hora, consultorio y número de ticket (`#id_cita`), además de botones de retorno.

#### 4. Componente UI Personalizado: [`WeekSwipeLayout.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/UI/WeekSwipeLayout.kt)
- **Filtro por Días de Atención**: Mantiene los días deshabilitados mientras cargan los `dias_atencion` del médico y bloquea (`alpha = 0.35f`, `isEnabled = false`, `isClickable = false`, sin listener) todo día en el que el médico no tiene agenda activa.
- **Filtro de Fechas Pasadas**: Bloquea cualquier selección de fecha menor o igual a hoy (`fecha <= CURDATE()`).
- **Enfoque Automático**: Alinea la semana al lunes independientemente de la configuración regional y mueve la selección al primer día hábil futuro disponible del médico.
- **Eventos sin lambdas**: Implementa `View.OnClickListener` y expone las interfaces `OnDateChangeListener` y `OnWeekSwipeListener`.

---

### 3.2 Presentadores (`com.example.medicdate.Presentador`)

| Presentador | Métodos Clave | Descripción |
| :--- | :--- | :--- |
| [`clsPresentadorReservaCita.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Presentador/clsPresentadorReservaCita.kt) | `cargarDisponibilidad(idEmpleado, idTipoAtencion, fecha, idUsuario)`, `cancelarSolicitudes()` | Ejecuta la consulta de disponibilidad mediante `Call`/`Callback` de Retrofit (GET con fallback POST), cancela peticiones previas en vuelo y notifica a la vista (`mostrarHorarios` o `mostrarError`). |
| [`clsPresentadorConfirmarCita.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Presentador/clsPresentadorConfirmarCita.kt) | `reservarCita(request)`, `cancelarSolicitudes()` | Procesa la petición de reserva mediante `Call`/`Callback`. En éxito invoca `vista.irAConfirmada(idCita, consultorio)`; ante conflicto de solapamiento o bloqueo invoca `vista.mostrarConflictoHorario(mensaje)`. |
| [`clsPresentadorCitaConfirmada.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Presentador/clsPresentadorCitaConfirmada.kt) | `mostrarCita(idCita)` | Gestiona el renderizado de los detalles del ticket de confirmación. |

---

### 3.3 Modelos de Lógica y Clases de Datos (`com.example.medicdate.Modelo`)

#### Clases de Lógica de Negocio:
- [`clsDisponibilidadModelo.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Modelo/clsDisponibilidadModelo.kt): Construye las llamadas `Call<DisponibilidadResponse>` hacia `disponibilidad.php` (GET con parámetro `datos` y fallback POST) y parsea cuerpos de error HTTP (422, 409, 400).
- [`clsReservaCitaModelo.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Modelo/clsReservaCitaModelo.kt): Construye la llamada `Call<ReservaResponse>` hacia `reservar_cita.php` y parsea errores estructurados del backend.

#### Archivos de Datos Serializables:
- [`dataDisponibilidad.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Modelo/dataDisponibilidad.kt):
  - `DisponibilidadRequest`: Encapsula `id_empleado`, `id_tipo_atencion`, `fecha` e `id_usuario`.
  - `DisponibilidadResponse`: Retorna `exito`, `mensaje`, `medico`, `tipo_atencion`, `duracion_minutos`, `dias_atencion` y la lista de `horarios`.
- [`dataReserva.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Modelo/dataReserva.kt):
  - `ReservaRequest`: Encapsula `id_usuario`, `id_empleado`, `id_tipo_atencion`, `inicio` e `id_consultorio`.
  - `ReservaResponse`: Retorna `exito`, `codigo`, `mensaje`, `accion`, `id_cita` y el objeto `cita`.
  - `CitaDetalleReserva`: Estructura detallada del ticket de cita.
- [`Horario.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Modelo/Horario.kt):
  - `Horario`: Representa un slot individual con `inicio`, `fin`, `hora`, `id_consultorio`, `consultorio`, `disponible`, `bloqueado`, `codigo` y `mensaje`.

---

## 4. Consumo de APIs REST (Backend PHP)

### 4.1 Endpoints Consumidos por el Módulo

```mermaid
sequenceDiagram
    autonumber
    actor Usuario
    participant Recervar as RecervarCitaActivity
    participant PresReserva as clsPresentadorReservaCita
    participant ModDisp as clsDisponibilidadModelo
    participant ApiDisp as disponibilidad.php (GET)
    participant Confirmar as ConfirmarCitaActivity
    participant PresConf as clsPresentadorConfirmarCita
    participant ModRes as clsReservaCitaModelo
    participant ApiRes as reservar_cita.php (POST)

    Usuario->>Recervar: Selecciona Fecha o Tipo de Atención
    Recervar->>PresReserva: cargarDisponibilidad()
    PresReserva->>ModDisp: obtenerDisponibilidad(request)
    ModDisp->>ApiDisp: GET disponibilidad.php?datos={...}
    ApiDisp-->>ModDisp: JSON 200 (horarios, dias_atencion, exito)
    ModDisp-->>PresReserva: DisponibilidadResponse
    PresReserva-->>Recervar: mostrarHorarios(horarios, diasAtencion)
    Recervar-->>Usuario: Oculta Skeleton / Habilita Slots Disponibles

    Usuario->>Recervar: Selecciona Horario y pulsa "Continuar"
    Recervar->>Confirmar: Intent con datos de pre-reserva
    Usuario->>Confirmar: Pulsa "Confirmar Cita"
    Confirmar->>PresConf: reservarCita(request)
    PresConf->>ModRes: reservarCita(request)
    ModRes->>ApiRes: POST reservar_cita.php (JSON Body)
    ApiRes-->>ModRes: JSON 201 Cita Confirmada (id_cita)
    ModRes-->>PresConf: ReservaResponse
    PresConf-->>Confirmar: irAConfirmada(idCita)
    Confirmar-->>Usuario: Abre CitaConfirmadaActivity con Ticket
```

---

### 4.2 Detalle de Endpoints PHP

#### 1. `disponibilidad.php`
- **Método**: `GET` (vía parámetro query `datos` en JSON) / `POST`.
- **Estructura Query `datos`**:
  ```json
  {
    "id_empleado": 2,
    "id_tipo_atencion": 1,
    "fecha": "2026-11-23",
    "id_usuario": 5
  }
  ```
- **Respuesta JSON**:
  ```json
  {
    "exito": true,
    "mensaje": "Selecciona un horario disponible.",
    "fecha": "2026-11-23",
    "medico": "Jose Manuel Rodriguez Lopez",
    "tipo_atencion": "Consulta de Medicina General",
    "duracion_minutos": 30,
    "dias_atencion": [1, 2, 3, 4, 5],
    "horarios": [
      {
        "inicio": "2026-11-23 09:00:00",
        "fin": "2026-11-23 09:30:00",
        "hora": "09:00",
        "duracion_minutos": 30,
        "disponible": false
      },
      {
        "inicio": "2026-11-23 11:00:00",
        "fin": "2026-11-23 11:30:00",
        "hora": "11:00",
        "duracion_minutos": 30,
        "disponible": true
      }
    ]
  }
  ```

#### 2. `reservar_cita.php`
- **Método**: `POST` (`application/json`).
- **Body JSON**:
  ```json
  {
    "id_usuario": 5,
    "id_empleado": 2,
    "id_tipo_atencion": 1,
    "inicio": "2026-11-23 11:00:00"
  }
  ```
- **Respuesta JSON (HTTP 201)**:
  ```json
  {
    "exito": true,
    "codigo": "CITA_CONFIRMADA",
    "mensaje": "Cita confirmada.",
    "cita": {
      "id_cita": 14,
      "estado": "confirmada",
      "fecha": "2026-11-23",
      "hora": "11:00",
      "duracion_minutos": 30,
      "medico": "Jose Manuel Rodriguez Lopez",
      "tipo_atencion": "Consulta de Medicina General",
      "consultorio": "Consultorio 101 - Medicina Familiar"
    }
  }
  ```

---

## 5. Decisiones de Diseño y Optimizaciones

1. **Prevención de Caché en Red**:
   En [`RetrofitCliente.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Red/RetrofitCliente.kt) se implementó un `OkHttpClient` con interceptor que añade los encabezados `Cache-Control: no-cache, no-store, must-revalidate` y `Pragma: no-cache`, obligando a consultar la disponibilidad en la BD en tiempo real.

2. **Intervalo Estándar de 30 Minutos**:
   Se estandarizó la generación interna de slots a bloques uniformes de **30 minutos** tanto en la API PHP como en la app Android. Esto evita desfasamientos en la cuadrícula de horarios.

3. **Cargador Esqueleto (Skeleton Shadow Load)**:
   Durante el tiempo de vuelo de la API de disponibilidad, la pantalla despliega un contenedor de esqueleto animado (`AlphaAnimation`) que se oculta únicamente al recibir la respuesta con los horarios.

4. **Persistencia de Sesión**:
   Uso de [`SessionManager.kt`](file:///C:/Users/PC/OneDrive/Desktop/MedicDate-movil/app/src/main/java/com/example/medicdate/Util/SessionManager.kt) con `SharedPreferences` para preservar `usuarioId` y `pacienteId`, garantizando que la reserva se procese con la cuenta autenticada.

5. **Validación Completa de Bloqueo de Horarios (`bloqueo_horario`)**:
   Tanto `disponibilidad.php` como `reservar_cita.php` (vía `citasApiBuscarConflicto` en `citas_api.php`) evalúan intersección de intervalos completos fecha-hora (`inicio < fin_slot AND fin > inicio_slot`) para soportar bloqueos parciales, de día completo y multidía por médico o por consultorio, devolviendo código `AGENDA_BLOQUEADA` cuando aplica.
