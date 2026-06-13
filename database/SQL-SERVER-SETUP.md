# Conectar el Back a SQL Server (SQLEXPRESS02)

**Error típico:** `Connection refused: localhost, puerto 14330`  
**Causa:** JDBC usa TCP; en tu PC TCP está **deshabilitado** en `SQLEXPRESS02`. SSMS conecta igual porque usa memoria compartida.

> Ejecutá los pasos 1–3 **como Administrador** (Configuration Manager y reinicio del servicio).

## Pasos (una sola vez)

### 1. Abrir SQL Server Configuration Manager

- Menú Inicio → buscar **"SQL Server Configuration Manager"**
- Si no aparece: `C:\Windows\SysWOW64\SQLServerManager17.msc` (o Manager16/15 según versión)

### 2. Habilitar TCP/IP

1. **SQL Server Network Configuration** → **Protocols for SQLEXPRESS02**
2. Clic derecho en **TCP/IP** → **Enable**
3. Doble clic en **TCP/IP** → pestaña **IP Addresses**
4. Bajá hasta **IPAll**:
   - **TCP Dynamic Ports**: vacío (borrá cualquier valor)
   - **TCP Port**: `14330`
5. **Aceptar**

### 3. Reiniciar SQL Server

1. **SQL Server Services** → **SQL Server (SQLEXPRESS02)**
2. Clic derecho → **Restart**

### 4. Verificar (PowerShell)

```powershell
cd Back
.\scripts\check-sqlserver.ps1
```

Debe decir **TCP habilitado: SI** y **Escuchando en 14330: SI**.

### 5. Probar en SSMS

- **Server name:** `localhost,14330`
- **Authentication:** Windows Authentication
- Base: **Patitas Unidas**

Si SSMS conecta con `localhost,14330`, el Back también debería.

### 6. Levantar el Back

Run **PatitasUnidas API** en IntelliJ. Deberías ver `HikariPool-1 - Start completed` sin errores.

## Si usás otro puerto

Editá `src/main/resources/application-local.properties` (copiá desde `.example`) y cambiá `14330` por tu puerto.

## Alternativa: SQL Server Browser

Si no querés puerto fijo, iniciá el servicio **SQL Server Browser** (Automático) y usá en `application-local.properties`:

```properties
spring.datasource.url=jdbc:sqlserver://localhost\\SQLEXPRESS02;databaseName=Patitas Unidas;integratedSecurity=true;encrypt=true;trustServerCertificate=true
```

## Verificar datos

```sql
USE [Patitas Unidas];
SELECT COUNT(*) FROM refugio;  -- 4
SELECT COUNT(*) FROM animal;   -- 6
```
