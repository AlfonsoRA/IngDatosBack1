-- =============================================================================
-- PatitasUnidas V2 — Triggers y vistas
-- Ejecutar ANTES de 005_inserts (los triggers actualizan estados en tránsito)
-- =============================================================================

USE [Patitas Unidas];
GO

CREATE OR ALTER TRIGGER dbo.TR_ActualizarEstadoAnimal_Adopcion
ON dbo.etapa_adopcion
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE A SET A.estado = 'Adoptado'
    FROM dbo.animal A
    INNER JOIN dbo.adopcion AD ON AD.id_animal = A.id_animal
    INNER JOIN inserted I ON I.id_adopcion = AD.id_adopcion
    WHERE I.estado = 'Concretada';

    UPDATE AD SET AD.estado_actual = 'Concretada'
    FROM dbo.adopcion AD
    INNER JOIN inserted I ON I.id_adopcion = AD.id_adopcion
    WHERE I.estado = 'Concretada';

    UPDATE A SET A.estado = 'En refugio'
    FROM dbo.animal A
    INNER JOIN dbo.adopcion AD ON AD.id_animal = A.id_animal
    INNER JOIN inserted I ON I.id_adopcion = AD.id_adopcion
    WHERE I.estado = 'Rechazada';

    UPDATE AD SET AD.estado_actual = 'Rechazada'
    FROM dbo.adopcion AD
    INNER JOIN inserted I ON I.id_adopcion = AD.id_adopcion
    WHERE I.estado = 'Rechazada';
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_ControlAdopcionDuplicada
ON dbo.adopcion
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM inserted I
        INNER JOIN dbo.adopcion AD ON AD.id_animal = I.id_animal
        WHERE AD.estado_actual IN ('Solicitada', 'En proceso', 'Aprobada')
    )
    BEGIN
        RAISERROR(
            'No se puede iniciar una nueva adopcion: el animal ya tiene un proceso activo (Solicitada, En proceso o Aprobada).',
            16, 1
        );
        RETURN;
    END;

    IF EXISTS (
        SELECT 1 FROM inserted I
        INNER JOIN dbo.animal A ON A.id_animal = I.id_animal
        WHERE A.estado = 'Adoptado'
    )
    BEGIN
        RAISERROR('No se puede iniciar una adopcion: el animal ya figura como Adoptado en el sistema.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.adopcion (id_animal, id_adoptante, fecha_solicitud, estado_actual)
    SELECT id_animal, id_adoptante, fecha_solicitud, estado_actual FROM inserted;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_ControlCapacidadRefugio
ON dbo.ubicacion_animal
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted WHERE es_actual = 1)
        RETURN;

    IF EXISTS (
        SELECT 1 FROM inserted I
        INNER JOIN dbo.refugio R ON R.id_refugio = I.id_refugio
        WHERE I.es_actual = 1
          AND (
              SELECT COUNT(*) FROM dbo.ubicacion_animal UA
              WHERE UA.id_refugio = I.id_refugio AND UA.es_actual = 1
          ) > R.capacidad
    )
    BEGIN
        RAISERROR(
            'No se puede alojar el animal: el refugio ha alcanzado su capacidad maxima.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_ActualizarEstadoAnimal_Transito
ON dbo.transito
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM inserted I
        LEFT JOIN deleted D ON D.id_transito = I.id_transito
        WHERE D.id_transito IS NULL OR I.estado_actual <> D.estado_actual
    )
        RETURN;

    UPDATE A SET A.estado = 'En tránsito'
    FROM dbo.animal A
    INNER JOIN inserted I ON I.id_animal = A.id_animal
    WHERE I.estado_actual = 'En tránsito';

    UPDATE A SET A.estado = 'En refugio'
    FROM dbo.animal A
    INNER JOIN inserted I ON I.id_animal = A.id_animal
    WHERE I.estado_actual IN ('Finalizado', 'Cancelado');
END;
GO

CREATE OR ALTER VIEW dbo.VW_AnimalesDisponibles AS
SELECT
    A.id_animal,
    A.nombre                        AS animal,
    A.especie,
    A.raza,
    A.sexo,
    A.castrado,
    A.fecha_nacimiento_estimada,
    A.fecha_ingreso                 AS ingreso_sistema,
    R.nombre                        AS refugio_actual,
    R.telefono                      AS telefono_refugio,
    DATEDIFF(DAY, A.fecha_ingreso, GETDATE()) AS dias_en_sistema
FROM dbo.animal A
INNER JOIN dbo.ubicacion_animal UA ON UA.id_animal = A.id_animal AND UA.es_actual = 1
INNER JOIN dbo.refugio R ON R.id_refugio = UA.id_refugio
WHERE A.estado = 'En refugio'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.adopcion AD
      WHERE AD.id_animal = A.id_animal
        AND AD.estado_actual IN ('Solicitada', 'En proceso', 'Aprobada')
  );
GO

CREATE OR ALTER VIEW dbo.VW_HistorialAdopciones AS
SELECT
    AD.id_adopcion,
    A.nombre                        AS animal,
    A.especie,
    A.raza,
    ADT.nombre + ' ' + ADT.apellido AS adoptante,
    ADT.dni                         AS dni_adoptante,
    ADT.telefono                    AS tel_adoptante,
    ADT.adoptante_previo,
    AD.fecha_solicitud,
    AD.estado_actual                AS estado_adopcion,
    COUNT(EA.id_etapa_adopcion)     AS cantidad_etapas,
    MAX(EA.fecha_inicio)            AS ultima_actualizacion
FROM dbo.adopcion AD
INNER JOIN dbo.animal A ON A.id_animal = AD.id_animal
INNER JOIN dbo.adoptante ADT ON ADT.id_adoptante = AD.id_adoptante
LEFT JOIN dbo.etapa_adopcion EA ON EA.id_adopcion = AD.id_adopcion
GROUP BY
    AD.id_adopcion, A.nombre, A.especie, A.raza,
    ADT.nombre, ADT.apellido, ADT.dni, ADT.telefono, ADT.adoptante_previo,
    AD.fecha_solicitud, AD.estado_actual;
GO

CREATE OR ALTER VIEW dbo.VW_OcupacionRefugios AS
SELECT
    R.id_refugio,
    R.nombre                        AS refugio,
    R.responsable,
    R.telefono,
    R.capacidad                     AS capacidad_maxima,
    COUNT(UA.id_ubicacion_animal)   AS animales_actuales,
    R.capacidad - COUNT(UA.id_ubicacion_animal) AS lugares_disponibles,
    CAST(COUNT(UA.id_ubicacion_animal) * 100.0 / R.capacidad AS DECIMAL(5,2)) AS porcentaje_ocupacion
FROM dbo.refugio R
LEFT JOIN dbo.ubicacion_animal UA ON UA.id_refugio = R.id_refugio AND UA.es_actual = 1
GROUP BY R.id_refugio, R.nombre, R.responsable, R.telefono, R.capacidad;
GO

CREATE OR ALTER VIEW dbo.VW_HistorialMedicoCompleto AS
SELECT
    A.id_animal,
    A.nombre                    AS animal,
    A.especie,
    A.raza,
    R.nombre                    AS refugio_actual,
    HM.id_historial_medico,
    HM.fecha                    AS fecha_atencion,
    HM.tipo_intervencion,
    HM.diagnostico,
    HM.medicamento,
    HM.nombre_veterinaria,
    HM.tipo_vacuna,
    HM.fecha_vencimiento        AS vencimiento_vacuna,
    CASE
        WHEN HM.fecha_vencimiento IS NOT NULL AND HM.fecha_vencimiento < GETDATE() THEN 'VENCIDA'
        WHEN HM.fecha_vencimiento IS NOT NULL AND DATEDIFF(DAY, GETDATE(), HM.fecha_vencimiento) <= 30 THEN 'PROXIMA A VENCER'
        WHEN HM.tipo_vacuna IS NOT NULL THEN 'VIGENTE'
        ELSE NULL
    END                         AS estado_vacuna,
    HM.observacion
FROM dbo.historial_medico HM
INNER JOIN dbo.animal A ON A.id_animal = HM.id_animal
LEFT JOIN dbo.ubicacion_animal UA ON UA.id_animal = A.id_animal AND UA.es_actual = 1
LEFT JOIN dbo.refugio R ON R.id_refugio = UA.id_refugio;
GO
