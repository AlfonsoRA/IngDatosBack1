# Ejecuta los scripts SQL V2 en orden (requiere sqlcmd)
param(
    [string]$Server = "localhost,1433",
    [string]$User = "sa",
    [string]$Password = "TU-CONTRASEÑA"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

function Invoke-SqlFile {
    param([string]$Path, [string]$Database = $null)
    $dbArg = if ($Database) { @("-d", $Database) } else { @() }
    Write-Host "Ejecutando $(Split-Path $Path -Leaf) ..."
    sqlcmd -S $Server @dbArg -U $User -P $Password -C -i $Path -b
    if ($LASTEXITCODE -ne 0) {
        throw "Fallo al ejecutar $Path"
    }
}

Invoke-SqlFile -Path (Join-Path $root "database\001_tablas.sql")
Invoke-SqlFile -Path (Join-Path $root "database\002_sql_login.sql") -Database "Patitas Unidas"
Invoke-SqlFile -Path (Join-Path $root "database\003_funciones_sp.sql") -Database "Patitas Unidas"
Invoke-SqlFile -Path (Join-Path $root "database\004_triggers_vistas.sql") -Database "Patitas Unidas"
Invoke-SqlFile -Path (Join-Path $root "database\005_inserts.sql") -Database "Patitas Unidas"

Write-Host "Scripts aplicados correctamente."
Write-Host "Opcional: ejecutar 006_consultas.sql manualmente en SSMS."
