# PatitasUnidas — Backend (API)

API **Java 17** (Spring Boot 3) alineada al **DER completo** (10 entidades). El frontend está en **`../Front`**.

## Requisitos

| Herramienta | Versión |
|-------------|---------|
| **JDK** | **17** |
| **Maven** | Usar `mvnw.cmd` incluido |
| **SQL Server** | `[Patitas Unidas]` en tu instancia local, puerto **1433** |

## Base de datos (obligatorio antes de levantar la API)

Ejecutar en **SSMS** en este orden:

| Orden | Script | Contenido |
|-------|--------|-----------|
| 1 | `database/001_schema_der.sql` | Tablas DER + datos iniciales |
| 2 | `database/002_sql_login.sql` | Login `patitas_app` (si falta) |
| 3 | `database/003_stored_procedures.sql` | SPs CRUD |
| 4 | `database/004_triggers.sql` | Sobrecupo, traslados, adopción |
| 5 | `database/005_views.sql` | Vistas de reportes |
| 6 | `database/006_consultas.sql` | Consultas analíticas |

O desde PowerShell (requiere `sqlcmd`):

```powershell
cd Back
.\scripts\run-database-scripts.ps1
```

## Ejecutar la API

```powershell
cd Back
.\run-dev.ps1
```

API: http://localhost:8080

Perfil H2 (solo pruebas locales sin SQL Server):

```powershell
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=h2
```

## Modelo DER

| Entidad | Tabla | Relación principal |
|---------|-------|------------------|
| Direccion | `direccion` | 1:1 con Refugio, Adoptante, HogarTransito |
| Refugio | `refugio` | Aloja animales |
| Animal | `animal` | FK refugio; historial médico y ubicaciones |
| HistorialMedico | `historial_medico` | N por animal |
| UbicacionAnimal | `ubicacion_animal` | Historial de traslados |
| Adoptante | `adoptante` | Inicia adopciones |
| HogarTransito | `hogar_transito` | Aloja tránsitos |
| Adopcion | `adopcion` | 1:1 con animal |
| EtapaAdopcion | `etapa_adopcion` | Etapas por adopción |
| Transito | `transito` | Animal en hogar tránsito |

## Endpoints REST

### Refugios — `/api/refugios`

Body ejemplo (compatibilidad con front anterior: `domicilio` o `direccion`):

```json
{
  "nombre": "Patitas Norte",
  "email": "norte@patitas.org",
  "telefono": "011-4444-5555",
  "capacidad": 80,
  "responsable": "María González",
  "direccion": {
    "calle": "Av. del Libertador",
    "numero": "4500",
    "localidad": "Vicente López",
    "partido": "Vicente López",
    "cp": "1638"
  }
}
```

### Animales — `/api/animales`

Query: `refugioId`, `especie`, `estadoDisponibilidad` (`DISPONIBLE`, `EN_PROCESO`, `ADOPTADO`)

```json
{
  "nombre": "Luna",
  "especie": "Perro",
  "raza": "Mestizo",
  "edad": 3,
  "fechaIngreso": "2024-03-12",
  "esCastrado": true,
  "refugioId": 1
}
```

### Otros CRUD

| Recurso | Base |
|---------|------|
| Historial médico | `/api/historial-medico?animalId=` |
| Ubicaciones animal | `/api/ubicaciones-animal?animalId=` |
| Adoptantes | `/api/adoptantes` |
| Hogares tránsito | `/api/hogares-transito` |
| Adopciones | `/api/adopciones?estado=` |
| Etapas adopción | `/api/etapas-adopcion?adopcionId=` |
| Tránsitos | `/api/transitos?estado=&animalId=` |

### Reportes (vistas SQL)

| GET | Descripción |
|-----|-------------|
| `/api/reportes/animales-disponibles` | `vw_animales_disponibles_resumen` |
| `/api/reportes/refugios-ocupacion` | `vw_refugios_ocupacion` |
| `/api/reportes/adopciones-detalle` | `vw_adopciones_detalle` |

## Conexión SQL Server

Copiá `src/main/resources/application-local.properties.example` a `application-local.properties` y definí la contraseña del login `patitas_app`:

```properties
spring.datasource.password=TU-CONTRASEÑA
```

En `application.properties` quedan URL, usuario y JPA (`spring.jpa.hibernate.ddl-auto=validate`).

Primera vez en la PC: `scripts\fix-sqlserver-tcp-admin.cmd` (TCP 1433 + auth mixta).

CORS: `app.cors.allowed-origins=http://localhost:4200`
