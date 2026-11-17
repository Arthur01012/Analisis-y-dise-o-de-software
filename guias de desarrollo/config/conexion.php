<?php
// Conexión PDO a la base medicdate_multiplataforma.
// Las variables de entorno permiten cambiar host, puerto y credenciales sin editar el código.

$host = getenv("MEDICDATE_DB_HOST") ?: "127.0.0.1";
$puerto = getenv("MEDICDATE_DB_PORT") ?: "3306";
$base = getenv("MEDICDATE_DB_NAME") ?: "medicdate_multiplataforma";
$usuario = getenv("MEDICDATE_DB_USER") ?: "root";
$claveEntorno = getenv("MEDICDATE_DB_PASSWORD");
$clave = $claveEntorno === false ? "" : $claveEntorno;

$dsn = "mysql:host={$host};port={$puerto};dbname={$base};charset=utf8mb4";

$pdo = new PDO($dsn, $usuario, $clave, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
]);
