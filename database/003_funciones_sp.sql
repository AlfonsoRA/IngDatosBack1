-- =============================================================================
-- PatitasUnidas V2 — Funciones y stored procedures de negocio
-- Ejecutar DESPUÉS de 001_tablas y 002_sql_login
-- =============================================================================

USE [Patitas Unidas];
GO

CREATE OR ALTER FUNCTION dbo.FN_EdadEstimadaMeses (@FechaNacimiento DATE)
RETURNS INT
AS
BEGIN
    IF @FechaNacimiento IS NULL OR @FechaNacimiento > CAST(GETDATE() AS DATE)
        RETURN NULL;
    RETURN DATEDIFF(MONTH, @FechaNacimiento, GETDATE());
END;
GO

CREATE OR ALTER FUNCTION dbo.FN_AnimalDisponibleParaAdopcion (@ID_Animal INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Disponible BIT = 0;
    DECLARE @Estado     VARCHAR(25);

    SELECT @Estado = estado FROM dbo.animal WHERE id_animal = @ID_Animal;

    IF @Estado = 'En refugio'
       AND NOT EXISTS (
           SELECT 1 FROM dbo.adopcion
           WHERE id_animal = @ID_Animal
             AND estado_actual IN ('Solicitada', 'En proceso', 'Aprobada')
       )
        SET @Disponible = 1;

    RETURN @Disponible;
END;
GO

CREATE OR ALTER FUNCTION dbo.FN_DiasHastaVencimientoVacuna (
    @ID_Animal   INT,
    @Tipo_Vacuna VARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @FechaVencimiento DATE;

    SELECT TOP 1 @FechaVencimiento = fecha_vencimiento
    FROM dbo.historial_medico
    WHERE id_animal = @ID_Animal
      AND tipo_vacuna = @Tipo_Vacuna
      AND fecha_vencimiento IS NOT NULL
    ORDER BY fecha DESC;

    IF @FechaVencimiento IS NULL
        RETURN NULL;

    RETURN DATEDIFF(DAY, CAST(GETDATE() AS DATE), @FechaVencimiento);
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_AltaAnimalConUbicacion
    @Nombre                   VARCHAR(100),
    @Especie                  VARCHAR(50),
    @Raza                     VARCHAR(50)   = NULL,
    @Sexo                     CHAR(1)       = NULL,
    @Castrado                 BIT           = 0,
    @FechaNacimiento_Estimada DATE          = NULL,
    @ID_Refugio               INT,
    @Motivo_Ingreso           VARCHAR(150)  = 'Ingreso inicial al sistema',
    @ID_Animal_Nuevo          INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM dbo.refugio WHERE id_refugio = @ID_Refugio)
        BEGIN
            RAISERROR('El refugio indicado no existe en el sistema.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @Capacidad INT;
        DECLARE @Ocupacion INT;

        SELECT @Capacidad = capacidad FROM dbo.refugio WHERE id_refugio = @ID_Refugio;
        SELECT @Ocupacion = COUNT(*) FROM dbo.ubicacion_animal
        WHERE id_refugio = @ID_Refugio AND es_actual = 1;

        IF @Ocupacion >= @Capacidad
        BEGIN
            RAISERROR('El refugio seleccionado no tiene lugares disponibles (capacidad maxima alcanzada).', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        INSERT INTO dbo.animal
            (nombre, especie, raza, sexo, castrado, fecha_nacimiento_estimada, estado, fecha_ingreso)
        VALUES
            (@Nombre, @Especie, @Raza, @Sexo, @Castrado, @FechaNacimiento_Estimada, 'En refugio', GETDATE());

        SET @ID_Animal_Nuevo = SCOPE_IDENTITY();

        INSERT INTO dbo.ubicacion_animal
            (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual)
        VALUES
            (@ID_Animal_Nuevo, @ID_Refugio, GETDATE(), @Motivo_Ingreso, 1);

        COMMIT TRANSACTION;

        SELECT @ID_Animal_Nuevo AS id_animal, @Nombre AS nombre, @Especie AS especie,
               @ID_Refugio AS refugio_asignado, 'Alta exitosa' AS resultado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        RAISERROR('Error en SP_AltaAnimalConUbicacion (linea %d): %s', 16, 1, @ErrorLine, @ErrorMsg);
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarEtapaAdopcion
    @ID_Adopcion   INT,
    @ID_Refugio    INT,
    @Estado        VARCHAR(25),
    @Observaciones VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM dbo.adopcion WHERE id_adopcion = @ID_Adopcion)
        BEGIN
            RAISERROR('La adopcion indicada no existe en el sistema.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        IF @Estado NOT IN ('Solicitada', 'En proceso', 'Aprobada', 'Rechazada', 'Concretada')
        BEGIN
            RAISERROR('Estado invalido. Valores permitidos: Solicitada, En proceso, Aprobada, Rechazada, Concretada.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @EstadoActual VARCHAR(25);
        SELECT @EstadoActual = estado_actual FROM dbo.adopcion WHERE id_adopcion = @ID_Adopcion;

        IF @EstadoActual IN ('Rechazada', 'Concretada')
        BEGIN
            RAISERROR('No se pueden agregar etapas a una adopcion que ya esta %s.', 16, 1, @EstadoActual);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        UPDATE dbo.etapa_adopcion
        SET fecha_fin = CAST(GETDATE() AS DATE)
        WHERE id_adopcion = @ID_Adopcion AND fecha_fin IS NULL;

        INSERT INTO dbo.etapa_adopcion
            (id_adopcion, id_refugio, estado, fecha_inicio, observaciones)
        VALUES
            (@ID_Adopcion, @ID_Refugio, @Estado, CAST(GETDATE() AS DATE), @Observaciones);

        UPDATE dbo.adopcion SET estado_actual = @Estado WHERE id_adopcion = @ID_Adopcion;

        COMMIT TRANSACTION;

        SELECT @ID_Adopcion AS id_adopcion, @Estado AS nuevo_estado,
               CAST(GETDATE() AS DATE) AS fecha_etapa, 'Etapa registrada exitosamente' AS resultado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg2  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine2 INT = ERROR_LINE();
        RAISERROR('Error en SP_RegistrarEtapaAdopcion (linea %d): %s', 16, 1, @ErrorLine2, @ErrorMsg2);
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarTrasladoAnimal
    @ID_Animal       INT,
    @ID_Refugio_Dest INT,
    @Motivo_Traslado VARCHAR(150) = 'Traslado entre refugios'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM dbo.animal WHERE id_animal = @ID_Animal)
        BEGIN
            RAISERROR('El animal indicado no existe en el sistema.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @EstadoAnimal VARCHAR(25);
        SELECT @EstadoAnimal = estado FROM dbo.animal WHERE id_animal = @ID_Animal;

        IF @EstadoAnimal <> 'En refugio'
        BEGIN
            RAISERROR('Solo se pueden trasladar animales en estado "En refugio". Estado actual: %s.', 16, 1, @EstadoAnimal);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.refugio WHERE id_refugio = @ID_Refugio_Dest)
        BEGIN
            RAISERROR('El refugio de destino no existe en el sistema.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @ID_Refugio_Actual INT;
        SELECT @ID_Refugio_Actual = id_refugio
        FROM dbo.ubicacion_animal
        WHERE id_animal = @ID_Animal AND es_actual = 1;

        IF @ID_Refugio_Actual = @ID_Refugio_Dest
        BEGIN
            RAISERROR('El animal ya se encuentra en el refugio de destino indicado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @Capacidad INT;
        DECLARE @Ocupacion INT;
        SELECT @Capacidad = capacidad FROM dbo.refugio WHERE id_refugio = @ID_Refugio_Dest;
        SELECT @Ocupacion = COUNT(*) FROM dbo.ubicacion_animal
        WHERE id_refugio = @ID_Refugio_Dest AND es_actual = 1;

        IF @Ocupacion >= @Capacidad
        BEGIN
            RAISERROR('El refugio de destino no tiene lugares disponibles (capacidad maxima alcanzada).', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        UPDATE dbo.ubicacion_animal
        SET es_actual = 0, fecha_salida = CAST(GETDATE() AS DATE)
        WHERE id_animal = @ID_Animal AND es_actual = 1;

        INSERT INTO dbo.ubicacion_animal
            (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual)
        VALUES
            (@ID_Animal, @ID_Refugio_Dest, CAST(GETDATE() AS DATE), @Motivo_Traslado, 1);

        COMMIT TRANSACTION;

        SELECT @ID_Animal AS id_animal,
               (SELECT nombre FROM dbo.animal WHERE id_animal = @ID_Animal) AS animal,
               (SELECT nombre FROM dbo.refugio WHERE id_refugio = @ID_Refugio_Actual) AS refugio_origen,
               (SELECT nombre FROM dbo.refugio WHERE id_refugio = @ID_Refugio_Dest) AS refugio_destino,
               CAST(GETDATE() AS DATE) AS fecha_traslado,
               @Motivo_Traslado AS motivo,
               'Traslado registrado exitosamente' AS resultado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg3  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine3 INT = ERROR_LINE();
        RAISERROR('Error en SP_RegistrarTrasladoAnimal (linea %d): %s', 16, 1, @ErrorLine3, @ErrorMsg3);
    END CATCH;
END;
GO
