-- Stored Procedures CRUD - PatitasUnidas (DER)
USE [Patitas Unidas];
GO

-- ========== DIRECCION ==========
CREATE OR ALTER PROCEDURE dbo.sp_direccion_listar AS
    SELECT * FROM dbo.direccion ORDER BY id_direccion;
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_obtener @id BIGINT AS
    SELECT * FROM dbo.direccion WHERE id_direccion = @id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_crear
    @calle NVARCHAR(120), @numero NVARCHAR(20), @localidad NVARCHAR(100),
    @partido NVARCHAR(100), @cp NVARCHAR(10), @id BIGINT OUTPUT
AS
    INSERT INTO dbo.direccion (calle, numero, localidad, partido, cp)
    VALUES (@calle, @numero, @localidad, @partido, @cp);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_actualizar
    @id BIGINT, @calle NVARCHAR(120), @numero NVARCHAR(20), @localidad NVARCHAR(100),
    @partido NVARCHAR(100), @cp NVARCHAR(10)
AS
    UPDATE dbo.direccion SET calle=@calle, numero=@numero, localidad=@localidad,
           partido=@partido, cp=@cp WHERE id_direccion=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_eliminar @id BIGINT AS
    DELETE FROM dbo.direccion WHERE id_direccion = @id;
GO

-- ========== REFUGIO ==========
CREATE OR ALTER PROCEDURE dbo.sp_refugio_listar AS
    SELECT r.*, d.calle, d.numero, d.localidad, d.partido, d.cp
    FROM dbo.refugio r INNER JOIN dbo.direccion d ON r.id_direccion = d.id_direccion;
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_obtener @id BIGINT AS
    SELECT r.*, d.calle, d.numero, d.localidad, d.partido, d.cp
    FROM dbo.refugio r INNER JOIN dbo.direccion d ON r.id_direccion = d.id_direccion
    WHERE r.id_refugio = @id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_crear
    @id_direccion BIGINT, @nombre NVARCHAR(120), @email NVARCHAR(120), @telefono NVARCHAR(30),
    @capacidad INT, @responsable NVARCHAR(100), @id BIGINT OUTPUT
AS
    INSERT INTO dbo.refugio (id_direccion, nombre, email, telefono, capacidad, responsable)
    VALUES (@id_direccion, @nombre, @email, @telefono, @capacidad, @responsable);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_actualizar
    @id BIGINT, @id_direccion BIGINT, @nombre NVARCHAR(120), @email NVARCHAR(120),
    @telefono NVARCHAR(30), @capacidad INT, @responsable NVARCHAR(100)
AS
    UPDATE dbo.refugio SET id_direccion=@id_direccion, nombre=@nombre, email=@email,
           telefono=@telefono, capacidad=@capacidad, responsable=@responsable
    WHERE id_refugio=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_eliminar @id BIGINT AS
    DELETE FROM dbo.refugio WHERE id_refugio = @id;
GO

-- ========== ANIMAL ==========
CREATE OR ALTER PROCEDURE dbo.sp_animal_listar AS
    SELECT a.*, r.nombre AS refugio_nombre FROM dbo.animal a
    INNER JOIN dbo.refugio r ON a.id_refugio = r.id_refugio ORDER BY a.id_animal;
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_obtener @id BIGINT AS
    SELECT a.*, r.nombre AS refugio_nombre FROM dbo.animal a
    INNER JOIN dbo.refugio r ON a.id_refugio = r.id_refugio WHERE a.id_animal = @id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_crear
    @id_refugio BIGINT, @especie NVARCHAR(50), @raza NVARCHAR(80), @nombre NVARCHAR(120),
    @edad INT, @fecha_ingreso DATE, @es_castrado BIT, @id BIGINT OUTPUT
AS
    INSERT INTO dbo.animal (id_refugio, especie, raza, nombre, edad, fecha_ingreso, es_castrado)
    VALUES (@id_refugio, @especie, @raza, @nombre, @edad, @fecha_ingreso, @es_castrado);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_actualizar
    @id BIGINT, @id_refugio BIGINT, @especie NVARCHAR(50), @raza NVARCHAR(80),
    @nombre NVARCHAR(120), @edad INT, @fecha_ingreso DATE, @es_castrado BIT
AS
    UPDATE dbo.animal SET id_refugio=@id_refugio, especie=@especie, raza=@raza, nombre=@nombre,
           edad=@edad, fecha_ingreso=@fecha_ingreso, es_castrado=@es_castrado
    WHERE id_animal=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_eliminar @id BIGINT AS
    DELETE FROM dbo.animal WHERE id_animal = @id;
GO

-- ========== HISTORIAL_MEDICO ==========
CREATE OR ALTER PROCEDURE dbo.sp_historial_listar AS SELECT * FROM dbo.historial_medico;
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_obtener @id BIGINT AS SELECT * FROM dbo.historial_medico WHERE id_historial_medico=@id;
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_por_animal @id_animal BIGINT AS
    SELECT * FROM dbo.historial_medico WHERE id_animal=@id_animal ORDER BY fecha DESC;
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_crear
    @id_animal BIGINT, @nombre_veterinaria NVARCHAR(120), @observacion NVARCHAR(500),
    @medicamento NVARCHAR(200), @diagnostico NVARCHAR(300), @tipo_intervencion NVARCHAR(100),
    @fecha DATE, @antirrabica BIT, @sextuple BIT, @triple BIT, @id BIGINT OUTPUT
AS
    INSERT INTO dbo.historial_medico (id_animal, nombre_veterinaria, observacion, medicamento,
        diagnostico, tipo_intervencion, fecha, antirrabica_anual, sextuple_anual, triple_anual)
    VALUES (@id_animal, @nombre_veterinaria, @observacion, @medicamento, @diagnostico,
        @tipo_intervencion, @fecha, @antirrabica, @sextuple, @triple);
    SET @id = SCOPE_IDENTITY();
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_eliminar @id BIGINT AS DELETE FROM dbo.historial_medico WHERE id_historial_medico=@id;
GO

-- ========== UBICACION_ANIMAL ==========
CREATE OR ALTER PROCEDURE dbo.sp_ubicacion_listar AS SELECT * FROM dbo.ubicacion_animal;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ubicacion_por_animal @id_animal BIGINT AS
    SELECT * FROM dbo.ubicacion_animal WHERE id_animal=@id_animal ORDER BY fecha_ingreso DESC;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ubicacion_crear
    @id_animal BIGINT, @id_refugio BIGINT, @fecha_ingreso DATE, @motivo NVARCHAR(200),
    @es_actual BIT, @id BIGINT OUTPUT
AS
    IF @es_actual = 1
        UPDATE dbo.ubicacion_animal SET es_actual=0, fecha_salida=GETDATE() WHERE id_animal=@id_animal AND es_actual=1;
    INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual)
    VALUES (@id_animal, @id_refugio, @fecha_ingreso, @motivo, @es_actual);
    IF @es_actual = 1 UPDATE dbo.animal SET id_refugio=@id_refugio WHERE id_animal=@id_animal;
    SET @id = SCOPE_IDENTITY();
GO

-- ========== ADOPTANTE, HOGAR, ADOPCION, ETAPA, TRANSITO (CRUD base) ==========
CREATE OR ALTER PROCEDURE dbo.sp_adoptante_listar AS SELECT * FROM dbo.adoptante;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adoptante_obtener @id BIGINT AS SELECT * FROM dbo.adoptante WHERE id_adoptante=@id;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adoptante_crear
    @id_direccion BIGINT, @dni NVARCHAR(20), @nombre NVARCHAR(80), @apellido NVARCHAR(80),
    @email NVARCHAR(120), @telefono NVARCHAR(30), @previo BIT, @id BIGINT OUTPUT
AS
    INSERT INTO dbo.adoptante (id_direccion, dni, nombre, apellido, email, telefono, adoptante_previo)
    VALUES (@id_direccion, @dni, @nombre, @apellido, @email, @telefono, @previo);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_hogar_transito_listar AS SELECT * FROM dbo.hogar_transito;
GO
CREATE OR ALTER PROCEDURE dbo.sp_hogar_transito_obtener @id BIGINT AS SELECT * FROM dbo.hogar_transito WHERE id_hogar_transito=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_adopcion_listar AS SELECT * FROM dbo.adopcion;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adopcion_obtener @id BIGINT AS SELECT * FROM dbo.adopcion WHERE id_adopcion=@id;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adopcion_crear
    @id_animal BIGINT, @id_adoptante BIGINT, @fecha DATE, @estado NVARCHAR(50), @id BIGINT OUTPUT
AS
    INSERT INTO dbo.adopcion (id_animal, id_adoptante, fecha_solicitud, estado_actual)
    VALUES (@id_animal, @id_adoptante, @fecha, @estado);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_etapa_adopcion_listar AS SELECT * FROM dbo.etapa_adopcion;
GO
CREATE OR ALTER PROCEDURE dbo.sp_etapa_por_adopcion @id_adopcion BIGINT AS
    SELECT * FROM dbo.etapa_adopcion WHERE id_adopcion=@id_adopcion ORDER BY fecha_inicio;
GO

CREATE OR ALTER PROCEDURE dbo.sp_transito_listar AS SELECT * FROM dbo.transito;
GO
CREATE OR ALTER PROCEDURE dbo.sp_transito_obtener @id BIGINT AS SELECT * FROM dbo.transito WHERE id_transito=@id;
GO
