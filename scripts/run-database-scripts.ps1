# Ejecuta los scripts SQL del DER en orden (requiere sqlcmd)
param(
    [string]$Server = "localhost,1433",
    [string]$Database = "Patitas Unidas",
    [string]$User = "patitas_app",
    [string]$Password = "TU-CONTRASEÑA"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$scripts = @(
    "001_schema_der.sql",
    "002_sql_login.sql",
    "003_stored_procedures.sql",
    "004_triggers.sql",
    "005_views.sql",
    "006_consultas.sql"
)

foreach ($file in $scripts) {
    $path = Join-Path $root "database\$file"
    if (-not (Test-Path $path)) {
        Write-Error "No se encontro: $path"
    }
    Write-Host "Ejecutando $file ..."
    sqlcmd -S $Server -d $Database -U $User -P $Password -C -i $path -b
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Fallo al ejecutar $file"
    }
}

Write-Host "Scripts aplicados correctamente."
