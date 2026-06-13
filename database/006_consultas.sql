-- Consultas analiticas (>=10) - PatitasUnidas DER
USE [Patitas Unidas];
GO

-- 1. Animales por refugio (agregado)
-- SELECT r.nombre, COUNT(a.id_animal) AS cantidad FROM refugio r LEFT JOIN animal a ON r.id_refugio=a.id_refugio GROUP BY r.nombre;

-- 2. Refugios con sobrecupo (subconsulta)
-- SELECT * FROM vw_refugios_ocupacion WHERE en_sobrecupo = 1;

-- 3. Vacunas/antirrabica por vencer (proximos 30 dias - registros sin fecha vencimiento explicita: ultima + 1 anio)
-- SELECT a.nombre, MAX(hm.fecha) AS ultima_antirrabica FROM historial_medico hm JOIN animal a ON hm.id_animal=a.id_animal WHERE hm.antirrabica_anual=1 GROUP BY a.nombre HAVING DATEADD(YEAR,1,MAX(hm.fecha)) <= DATEADD(DAY,30,GETDATE());

-- 4. Tasa de adopciones completadas por mes
-- SELECT YEAR(fecha_solicitud) AS anio, MONTH(fecha_solicitud) AS mes, COUNT(*) AS adopciones FROM adopcion WHERE estado_actual='COMPLETADA' GROUP BY YEAR(fecha_solicitud), MONTH(fecha_solicitud);

-- 5. Ranking refugios por cantidad de animales
-- SELECT TOP 5 r.nombre, COUNT(a.id_animal) AS total FROM refugio r JOIN animal a ON r.id_refugio=a.id_refugio GROUP BY r.nombre ORDER BY total DESC;

-- 6. Animales en transito activo (JOIN 3 tablas)
-- SELECT a.nombre, ht.nombre, t.estado_actual FROM transito t JOIN animal a ON t.id_animal=a.id_animal JOIN hogar_transito ht ON t.id_hogar_transito=ht.id_hogar_transito WHERE t.estado_actual='ACTIVO';

-- 7. Adoptantes reincidentes
-- SELECT * FROM adoptante WHERE adoptante_previo = 1;

-- 8. Historial medico promedio por especie
-- SELECT a.especie, AVG(CAST(cnt AS FLOAT)) AS promedio_atenciones FROM (SELECT id_animal, COUNT(*) cnt FROM historial_medico GROUP BY id_animal) x JOIN animal a ON x.id_animal=a.id_animal GROUP BY a.especie;

-- 9. Etapas de adopcion abiertas (sin fecha_fin)
-- SELECT * FROM etapa_adopcion WHERE fecha_fin IS NULL;

-- 10. Traslados entre refugios (ubicacion_animal historico)
-- SELECT a.nombre, r.nombre AS refugio, ua.fecha_ingreso, ua.motivo_traslado FROM ubicacion_animal ua JOIN animal a ON ua.id_animal=a.id_animal JOIN refugio r ON ua.id_refugio=r.id_refugio ORDER BY ua.fecha_ingreso DESC;

-- 11. Ocupacion porcentual por refugio
-- SELECT nombre, ocupacion_actual, capacidad, CAST(ocupacion_actual AS FLOAT)/capacidad*100 AS pct FROM vw_refugios_ocupacion;

-- 12. Animales castrados vs no castrados
-- SELECT es_castrado, COUNT(*) FROM animal GROUP BY es_castrado;

-- ========== EJEMPLOS EJECUTABLES ==========

PRINT '--- Consulta 1: Animales por refugio ---';
SELECT r.nombre, COUNT(a.id_animal) AS cantidad
FROM dbo.refugio r
LEFT JOIN dbo.animal a ON r.id_refugio = a.id_refugio
GROUP BY r.nombre;

PRINT '--- Consulta 4: Adopciones completadas por mes ---';
SELECT YEAR(fecha_solicitud) AS anio, MONTH(fecha_solicitud) AS mes, COUNT(*) AS total
FROM dbo.adopcion WHERE estado_actual = N'COMPLETADA'
GROUP BY YEAR(fecha_solicitud), MONTH(fecha_solicitud);

PRINT '--- Consulta 5: Ranking refugios ---';
SELECT TOP 5 r.nombre, COUNT(a.id_animal) AS total_animales
FROM dbo.refugio r
INNER JOIN dbo.animal a ON r.id_refugio = a.id_refugio
GROUP BY r.nombre ORDER BY total_animales DESC;

PRINT '--- Consulta 6: Transitos activos ---';
SELECT a.nombre AS animal, ht.nombre + N' ' + ht.apellido AS hogar_transito, t.estado_actual
FROM dbo.transito t
INNER JOIN dbo.animal a ON t.id_animal = a.id_animal
INNER JOIN dbo.hogar_transito ht ON t.id_hogar_transito = ht.id_hogar_transito
WHERE t.estado_actual = N'ACTIVO';

PRINT '--- Vista: Animales disponibles con resumen medico ---';
SELECT TOP 10 * FROM dbo.vw_animales_disponibles_resumen;

GO
