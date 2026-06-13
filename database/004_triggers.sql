-- Triggers - PatitasUnidas
USE [Patitas Unidas];
GO

-- Alerta de sobrecupo al insertar animal en refugio
CREATE OR ALTER TRIGGER dbo.trg_refugio_sobrecupo
ON dbo.animal
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM dbo.refugio r
        INNER JOIN (
            SELECT id_refugio, COUNT(*) AS ocupacion
            FROM dbo.animal
            GROUP BY id_refugio
        ) o ON r.id_refugio = o.id_refugio
        WHERE o.ocupacion > r.capacidad
    )
    BEGIN
        RAISERROR(N'ALERTA: refugio en sobrecupo (capacidad maxima superada).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Al completar adopcion, registrar etapa final automatica (trazabilidad)
CREATE OR ALTER TRIGGER dbo.trg_adopcion_completada
ON dbo.adopcion
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.etapa_adopcion (id_adopcion, id_refugio, fecha_inicio, fecha_fin, observaciones)
    SELECT i.id_adopcion, a.id_refugio, CAST(GETDATE() AS DATE), CAST(GETDATE() AS DATE),
           N'Adopcion completada - cierre automatico'
    FROM inserted i
    INNER JOIN deleted d ON i.id_adopcion = d.id_adopcion
    INNER JOIN dbo.animal a ON i.id_animal = a.id_animal
    WHERE i.estado_actual = N'COMPLETADA' AND d.estado_actual <> N'COMPLETADA';
END;
GO

-- Log de traslados: al cambiar refugio del animal, cerrar ubicacion anterior
CREATE OR ALTER TRIGGER dbo.trg_animal_traslado
ON dbo.animal
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(id_refugio)
    BEGIN
        UPDATE ua SET es_actual = 0, fecha_salida = CAST(GETDATE() AS DATE)
        FROM dbo.ubicacion_animal ua
        INNER JOIN inserted i ON ua.id_animal = i.id_animal
        INNER JOIN deleted d ON i.id_animal = d.id_animal
        WHERE ua.es_actual = 1 AND i.id_refugio <> d.id_refugio;

        INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual)
        SELECT i.id_animal, i.id_refugio, CAST(GETDATE() AS DATE), N'Traslado entre refugios', 1
        FROM inserted i
        INNER JOIN deleted d ON i.id_animal = d.id_animal
        WHERE i.id_refugio <> d.id_refugio;
    END
END;
GO
