# Inicia la API con JDK 17 (evita Java 8 del PATH)
$ErrorActionPreference = "Stop"

$jdk17 = "C:\Users\Ricar\.jdks\corretto-17.0.11"
if (-not (Test-Path "$jdk17\bin\java.exe")) {
    Write-Host "ERROR: JDK 17 no encontrado en $jdk17" -ForegroundColor Red
    Write-Host "Instale Amazon Corretto 17 o edite la ruta en run-dev.ps1 y mvnw.cmd"
    exit 1
}

$env:JAVA_HOME = $jdk17
$env:Path = "$jdk17\bin;" + ($env:Path -replace [regex]::Escape("$jdk17\bin;"), "")

Set-Location $PSScriptRoot
Write-Host "JAVA_HOME=$env:JAVA_HOME" -ForegroundColor Cyan
Write-Host "Iniciando PatitasUnidas API en http://localhost:8080 ..." -ForegroundColor Green

& cmd /c "mvnw.cmd spring-boot:run"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
