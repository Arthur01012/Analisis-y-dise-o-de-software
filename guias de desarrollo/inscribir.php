<?php
// Indica que la respuesta del endpoint se enviará en formato JSON con soporte para acentos.
header("Content-Type: application/json; charset=UTF-8");
// Carga la conexión PDO existente; este archivo contiene la configuración de base de datos.
require_once "config/conexion.php";

try {
    // Lee y convierte el cuerpo de la solicitud, que normalmente llega en formato JSON.
    $datos = json_decode(file_get_contents("php://input"), true);
    // Si el cuerpo no contiene JSON válido, intenta obtener los datos de un formulario POST.
    if (!is_array($datos)) {
        $datos = $_POST;
    }

    // Lee los valores de la inscripción y quita espacios sobrantes.
    $codigoCurso = trim((string) ($datos["codigo_curso"] ?? ""));
    $matricula = trim((string) ($datos["matricula"] ?? ""));
    $fechaRegistro = trim((string) ($datos["fecha_registro"] ?? ""));

    // Rechaza la solicitud si falta cualquiera de los datos obligatorios.
    if ($codigoCurso === "" || $matricula === "" || $fechaRegistro === "") {
        http_response_code(400);
        echo json_encode([
            "exito" => false,
            "mensaje" => "Debe enviar el curso, la matrícula y la fecha."
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    // Busca al alumno con una consulta parametrizada antes de crear la inscripción.
    $consultaAlumno = $pdo->prepare(
        "SELECT matricula FROM tbl_alumnos WHERE matricula = ?"
    );
    $consultaAlumno->execute([$matricula]);
    // Guarda el resultado; si no hay fila, la matrícula no existe.
    $alumno = $consultaAlumno->fetch(PDO::FETCH_ASSOC);
    // No permite registrar una inscripción para una matrícula inexistente.
    if (!$alumno) {
        http_response_code(404);
        echo json_encode([
            "exito" => false,
            "mensaje" => "No existe un alumno registrado con esa matrícula."
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    // Inicia una transacción para que la inserción se confirme completa o se revierta.
    $pdo->beginTransaction();

    // Prepara la inserción de curso, alumno y fecha para proteger los valores recibidos.
    $inscripcion = $pdo->prepare(
        "INSERT INTO tbl_inscripciones (codigo_curso, matricula, fecha_registro) VALUES (?, ?, ?)"
    );
    // Ejecuta la inserción con los valores validados.
    $inscripcion->execute([$codigoCurso, $matricula, $fechaRegistro]);

    // Confirma la transacción y guarda los cambios en la base de datos.
    $pdo->commit();
    // Informa que la inscripción se completó correctamente.
    echo json_encode([
        "exito" => true,
        "mensaje" => "Inscripción realizada correctamente."
    ], JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    // Si la operación falló durante una transacción, revierte cualquier cambio parcial.
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    // Registra el detalle técnico del error sin exponerlo al cliente.
    error_log("Error al registrar inscripción: " . $e->getMessage());
    // Devuelve el error de servidor al cliente.
    http_response_code(500);
    echo json_encode([
        "exito" => false,
        "mensaje" => "Error al registrar la inscripción."
    ], JSON_UNESCAPED_UNICODE);
}

?>