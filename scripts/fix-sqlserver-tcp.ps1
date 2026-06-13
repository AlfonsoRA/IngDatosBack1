# EJECUTAR COMO ADMINISTRADOR (clic derecho → Ejecutar con PowerShell como administrador)
# Habilita TCP en SQLEXPRESS02, puerto 1433, reinicia SQL Server y verifica.

$ErrorActionPreference = "Stop"
$instance = "SQLEXPRESS02"
$regBase = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.$instance\MSSQLServer\SuperSocketNetLib\Tcp"
$port = "1433"

Write-Host "=== PatitasUnidas: configurar SQL Server ($instance) ===" -ForegroundColor Cyan

if (-not (Test-Path $regBase)) {
    Write-Host "ERROR: No se encuentra la instancia $instance en el registro." -ForegroundColor Red
    exit 1
}

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.$instance\MSSQLServer" -Name LoginMode -Value 2
Write-Host "Autenticacion mixta (Windows + SQL) habilitada" -ForegroundColor Green

Set-ItemProperty -Path $regBase -Name Enabled -Value 1
Set-ItemProperty -Path "$regBase\IPAll" -Name TcpPort -Value $port
Set-ItemProperty -Path "$regBase\IPAll" -Name TcpDynamicPorts -Value ""

Write-Host "TCP habilitado, puerto $port" -ForegroundColor Green

$serviceName = "MSSQL`$$instance"
Restart-Service $serviceName -Force
Write-Host "Servicio $serviceName reiniciado" -ForegroundColor Green

try {
    Set-Service SQLBrowser -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service SQLBrowser -ErrorAction SilentlyContinue
    Write-Host "SQL Server Browser iniciado (opcional)" -ForegroundColor Green
} catch {
    Write-Host "Browser no iniciado (no es crítico si usás puerto fijo)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2
$listening = netstat -an | Select-String ":$port "
if ($listening) {
    Write-Host "OK: SQL Server escuchando en puerto $port" -ForegroundColor Green
    Write-Host "Proba en SSMS: localhost,$port" -ForegroundColor Cyan
    Write-Host "Luego levanta PatitasUnidas API en IntelliJ." -ForegroundColor Cyan
} else {
    Write-Host "ADVERTENCIA: aun no se detecta el puerto $port. Revisá SQL Server Configuration Manager." -ForegroundColor Yellow
}

Read-Host "Presiona Enter para cerrar"
