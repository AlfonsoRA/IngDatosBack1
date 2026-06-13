@echo off
:: Clic derecho → Ejecutar como administrador
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0fix-sqlserver-tcp.ps1"
pause
