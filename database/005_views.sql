-- Vistas - PatitasUnidas
USE [Patitas Unidas];
GO

CREATE OR ALTER VIEW dbo.vw_animales_disponibles_resumen AS
SELECT
    a.id_animal,
    a.nombre,
    a.especie,
    a.raza,
    a.edad,
    a.fecha_ingreso,
    a.es_castrado,
    r.id_refugio,
    r.nombre AS refugio_nombre,
    (SELECT COUNT(*) FROM dbo.historial_medico hm WHERE hm.id_animal = a.id_animal) AS total_atenciones,
    (SELECT MAX(hm.fecha) FROM dbo.historial_medico hm WHERE hm.id_animal = a.id_animal) AS ultima_atencion,
    (SELECT MAX(CASE WHEN hm.antirrabica_anual = 1 THEN hm.fecha END) FROM dbo.historial_medico hm WHERE hm.id_animal = a.id_animal) AS ultima_antirrabica,
    CASE WHEN ad.id_adopcion IS NULL THEN N'DISPONIBLE'
         WHEN ad.estado_actual = N'COMPLETADA' THEN N'ADOPTADO'
         ELSE N'EN_PROCESO' END AS estado_disponibilidad
FROM dbo.animal a
INNER JOIN dbo.refugio r ON a.id_refugio = r.id_refugio
LEFT JOIN dbo.adopcion ad ON a.id_animal = ad.id_animal
WHERE ad.id_adopcion IS NULL OR ad.estado_actual <> N'COMPLETADA';
GO

CREATE OR ALTER VIEW dbo.vw_refugios_ocupacion AS
SELECT
    r.id_refugio,
    r.nombre,
    r.capacidad,
    COUNT(a.id_animal) AS ocupacion_actual,
    r.capacidad - COUNT(a.id_animal) AS cupos_libres,
    CASE WHEN COUNT(a.id_animal) > r.capacidad THEN 1 ELSE 0 END AS en_sobrecupo
FROM dbo.refugio r
LEFT JOIN dbo.animal a ON r.id_refugio = a.id_refugio
GROUP BY r.id_refugio, r.nombre, r.capacidad;
GO

CREATE OR ALTER VIEW dbo.vw_adopciones_detalle AS
SELECT
    ad.id_adopcion,
    ad.estado_actual,
    ad.fecha_solicitud,
    a.id_animal,
    a.nombre AS animal_nombre,
    ap.nombre + N' ' + ap.apellido AS adoptante_nombre,
    r.nombre AS refugio_actual
FROM dbo.adopcion ad
INNER JOIN dbo.animal a ON ad.id_animal = a.id_animal
INNER JOIN dbo.adoptante ap ON ad.id_adoptante = ap.id_adoptante
INNER JOIN dbo.refugio r ON a.id_refugio = r.id_refugio;
GO
