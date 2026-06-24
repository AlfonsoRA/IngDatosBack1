-- Triggers - PatitasUnidas (schema equipo)
USE [Patitas Unidas];
GO

-- Alerta de sobrecupo según ubicaciones actuales (no adoptados)
CREATE OR ALTER TRIGGER dbo.trg_refugio_sobrecupo
ON dbo.ubicacion_animal
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM dbo.refugio r
        INNER JOIN (
            SELECT ua.id_refugio, COUNT(*) AS ocupacion
            FROM dbo.ubicacion_animal ua
            INNER JOIN dbo.animal a ON ua.id_animal = a.id_animal
            WHERE ua.es_actual = 1 AND (a.estado IS NULL OR a.estado <> N'Adoptado')
            GROUP BY ua.id_refugio
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

-- Al concretar adopción, registrar etapa final automática
CREATE OR ALTER TRIGGER dbo.trg_adopcion_concretada
ON dbo.adopcion
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.etapa_adopcion (id_adopcion, id_refugio, fecha_inicio, fecha_fin, observaciones)
    SELECT i.id_adopcion, ua.id_refugio, CAST(GETDATE() AS DATE), CAST(GETDATE() AS DATE),
           N'Adopción concretada - cierre automático'
    FROM inserted i
    INNER JOIN deleted d ON i.id_adopcion = d.id_adopcion
    INNER JOIN dbo.ubicacion_animal ua ON ua.id_animal = i.id_animal AND ua.es_actual = 1
    WHERE i.estado_actual = N'Concretada' AND ISNULL(d.estado_actual, N'') <> N'Concretada';

    UPDATE a SET estado = N'Adoptado'
    FROM dbo.animal a
    INNER JOIN inserted i ON a.id_animal = i.id_animal
    INNER JOIN deleted d ON i.id_adopcion = d.id_adopcion
    WHERE i.estado_actual = N'Concretada' AND ISNULL(d.estado_actual, N'') <> N'Concretada';
END;
GO

-- Al marcar tránsito activo, actualizar estado del animal
CREATE OR ALTER TRIGGER dbo.trg_transito_activo
ON dbo.transito
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE a SET estado = N'En tránsito'
    FROM dbo.animal a
    INNER JOIN inserted i ON a.id_animal = i.id_animal
    WHERE i.estado_actual = N'En tránsito';

    UPDATE a SET estado = N'En refugio'
    FROM dbo.animal a
    INNER JOIN inserted i ON a.id_animal = i.id_animal
    WHERE i.estado_actual IN (N'Finalizado', N'Cancelado');
END;
GO
