# Scripts de base de datos — PatitasUnidas

Ejecutar **en este orden** en SSMS o con `scripts/run-database-scripts.ps1`.

| Script | Descripción |
|--------|-------------|
| `001_schema_der.sql` | **Schema DER completo** (10 tablas) + datos iniciales |
| `002_sql_login.sql` | Login SQL `patitas_app` para la API |
| `003_stored_procedures.sql` | Stored procedures CRUD |
| `004_triggers.sql` | Sobrecupo, traslado animal, adopción completada |
| `005_views.sql` | Vistas para reportes |
| `006_consultas.sql` | Consultas analíticas de ejemplo |

> **Nota:** `001_schema.sql` es el schema anterior (solo refugio + animal simplificado). Usar **`001_schema_der.sql`**.
