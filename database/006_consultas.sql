-- =============================================================================
-- PatitasUnidas V2 — Consultas analíticas (opcional, solo pruebas en SSMS)
-- =============================================================================

USE [Patitas Unidas];
GO

-- 1) Cantidad de animales por refugio
SELECT r.nombre, COUNT(ua.id_animal) AS cantidad_animales
FROM dbo.refugio r
LEFT JOIN dbo.ubicacion_animal ua ON r.id_refugio = ua.id_refugio AND ua.es_actual = 1
GROUP BY r.nombre;
GO

-- 2) Ocupacion porcentual por refugio
SELECT r.nombre,
       COUNT(ua.id_animal) AS ocupacion_actual,
       r.capacidad,
       CAST(COUNT(ua.id_animal) AS FLOAT) / r.capacidad * 100 AS porcentaje_ocupacion
FROM dbo.refugio r
LEFT JOIN dbo.ubicacion_animal ua ON r.id_refugio = ua.id_refugio AND ua.es_actual = 1
GROUP BY r.nombre, r.capacidad;
GO

-- 3) Top 5 refugios con mayor cantidad de animales
SELECT TOP 5 r.nombre, COUNT(ua.id_animal) AS total
FROM dbo.refugio r
JOIN dbo.ubicacion_animal ua ON r.id_refugio = ua.id_refugio AND ua.es_actual = 1
GROUP BY r.nombre
ORDER BY total DESC;
GO

-- 4) Animales en transito activo
SELECT a.nombre AS animal,
       ht.nombre + ' ' + ht.apellido AS hogar_transito,
       t.fecha_inicio
FROM dbo.transito t
JOIN dbo.animal a ON t.id_animal = a.id_animal
JOIN dbo.hogar_transito ht ON t.id_hogar_transito = ht.id_hogar_transito
WHERE t.estado_actual = 'En tránsito';
GO

-- 5) Adopciones concretadas por mes
SELECT YEAR(fecha_solicitud) AS anio,
       MONTH(fecha_solicitud) AS mes,
       COUNT(*) AS cantidad_adopciones
FROM dbo.adopcion
WHERE estado_actual = 'Concretada'
GROUP BY YEAR(fecha_solicitud), MONTH(fecha_solicitud)
ORDER BY anio, mes;
GO

-- 6) Etapas de adopciones pendientes
SELECT ea.id_etapa_adopcion, a.nombre, ea.estado, ea.fecha_inicio
FROM dbo.etapa_adopcion ea
JOIN dbo.adopcion ad ON ea.id_adopcion = ad.id_adopcion
JOIN dbo.animal a ON ad.id_animal = a.id_animal
WHERE ea.fecha_fin IS NULL;
GO

-- 7) Vacunas proximas a vencer
SELECT a.nombre, hm.tipo_vacuna, hm.fecha_vencimiento
FROM dbo.historial_medico hm
JOIN dbo.animal a ON hm.id_animal = a.id_animal
WHERE hm.fecha_vencimiento IS NOT NULL
ORDER BY hm.fecha_vencimiento;
GO

-- 8) Historial medico promedio por especie
SELECT a.especie, AVG(CAST(x.cantidad AS FLOAT)) AS promedio_atenciones
FROM (
    SELECT id_animal, COUNT(*) AS cantidad
    FROM dbo.historial_medico
    GROUP BY id_animal
) x
JOIN dbo.animal a ON x.id_animal = a.id_animal
GROUP BY a.especie;
GO

-- 9) Historial de traslados entre refugios
SELECT a.nombre, r.nombre AS refugio, ua.fecha_ingreso, ua.motivo_traslado
FROM dbo.ubicacion_animal ua
JOIN dbo.animal a ON ua.id_animal = a.id_animal
JOIN dbo.refugio r ON ua.id_refugio = r.id_refugio
WHERE ua.motivo_traslado IS NOT NULL
ORDER BY ua.fecha_ingreso DESC;
GO

-- 10) Animales disponibles (vista del equipo)
SELECT * FROM dbo.VW_AnimalesDisponibles;
GO
