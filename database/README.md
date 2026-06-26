# Scripts de base de datos — PatitasUnidas V2

Instalación **desde cero** en SQL Server. Ejecutar **en este orden** en SSMS (como admin) o con `scripts/run-database-scripts.ps1`.

| Orden | Script | Descripción |
|-------|--------|-------------|
| 1 | `001_tablas.sql` | Crea BD `[Patitas Unidas]` y las 10 tablas |
| 2 | `002_sql_login.sql` | Login SQL `patitas_app` para la API Java |
| 3 | `003_funciones_sp.sql` | 3 funciones + 3 SP de negocio del equipo |
| 4 | `004_triggers_vistas.sql` | 4 triggers + 4 vistas (antes de los datos) |
| 5 | `005_inserts.sql` | Datos iniciales (10 filas por tabla) |
| 6 | `006_consultas.sql` | Consultas analíticas de ejemplo *(opcional)* |

## Instalación manual en SSMS

1. Abrir `001_tablas.sql` → ejecutar (recrea la BD completa).
2. Editar la contraseña en `002_sql_login.sql` → ejecutar.
3. Ejecutar `003`, `004` y `005` en orden.
4. `006` solo si querés probar consultas.

## PowerShell

```powershell
.\scripts\run-database-scripts.ps1 -Password "TuContraseña"
```

> **Importante:** `004_triggers_vistas.sql` debe ejecutarse **antes** de `005_inserts.sql` porque los triggers actualizan el estado de los animales al cargar tránsitos.

## Cambios principales respecto al schema anterior

- `codigo_postal` es tabla independiente; `direccion` referencia `cpa_id`.
- `historial_medico` usa `tipo_vacuna` + `fecha_vencimiento` (sin flags BIT).
- `etapa_adopcion` incluye columna `estado` obligatoria.
- Vistas del equipo: `VW_AnimalesDisponibles`, `VW_HistorialAdopciones`, `VW_OcupacionRefugios`, `VW_HistorialMedicoCompleto`.
