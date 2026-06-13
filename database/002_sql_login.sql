-- Ejecutar en SSMS sobre la instancia RICARDO\SQLEXPRESS02
-- Login para la API Java (evita DLL de Windows Auth en JDBC)

USE [master];
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'patitas_app')
BEGIN
    CREATE LOGIN patitas_app WITH PASSWORD = N'TU-CONTRASEÑA';
END
GO

USE [Patitas Unidas];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'patitas_app')
BEGIN
    CREATE USER patitas_app FOR LOGIN patitas_app;
END
GO

ALTER ROLE db_owner ADD MEMBER patitas_app;
GO
