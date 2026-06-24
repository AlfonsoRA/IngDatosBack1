-- Stored Procedures CRUD - PatitasUnidas (schema equipo)
USE [Patitas Unidas];
GO

-- ========== DIRECCION ==========
CREATE OR ALTER PROCEDURE dbo.sp_direccion_listar AS
    SELECT d.*, cp.codigo_postal
    FROM dbo.direccion d
    LEFT JOIN dbo.codigo_postal cp ON cp.direccion_id = d.id_direccion
    ORDER BY d.id_direccion;
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_obtener @id INT AS
    SELECT d.*, cp.codigo_postal
    FROM dbo.direccion d
    LEFT JOIN dbo.codigo_postal cp ON cp.direccion_id = d.id_direccion
    WHERE d.id_direccion = @id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_crear
    @nombre NVARCHAR(120), @altura INT, @localidad NVARCHAR(80),
    @partido NVARCHAR(80), @provincia NVARCHAR(50), @codigo_postal CHAR(8), @id INT OUTPUT
AS
    INSERT INTO dbo.direccion (nombre, altura, localidad, partido, provincia)
    VALUES (@nombre, @altura, @localidad, @partido, ISNULL(@provincia, N'BUENOS AIRES'));
    SET @id = SCOPE_IDENTITY();
    IF @codigo_postal IS NOT NULL
        INSERT INTO dbo.codigo_postal (direccion_id, altura_desde, altura_hasta, paridad, codigo_postal)
        VALUES (@id, @altura, @altura, N'AMBOS', @codigo_postal);
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_actualizar
    @id INT, @nombre NVARCHAR(120), @altura INT, @localidad NVARCHAR(80),
    @partido NVARCHAR(80), @provincia NVARCHAR(50), @codigo_postal CHAR(8)
AS
    UPDATE dbo.direccion SET nombre=@nombre, altura=@altura, localidad=@localidad,
           partido=@partido, provincia=ISNULL(@provincia, N'BUENOS AIRES')
    WHERE id_direccion=@id;
    IF @codigo_postal IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.codigo_postal WHERE direccion_id=@id)
            UPDATE dbo.codigo_postal SET altura_desde=@altura, altura_hasta=@altura, codigo_postal=@codigo_postal
            WHERE direccion_id=@id;
        ELSE
            INSERT INTO dbo.codigo_postal (direccion_id, altura_desde, altura_hasta, paridad, codigo_postal)
            VALUES (@id, @altura, @altura, N'AMBOS', @codigo_postal);
    END
GO

CREATE OR ALTER PROCEDURE dbo.sp_direccion_eliminar @id INT AS
    DELETE FROM dbo.codigo_postal WHERE direccion_id = @id;
    DELETE FROM dbo.direccion WHERE id_direccion = @id;
GO

-- ========== REFUGIO ==========
CREATE OR ALTER PROCEDURE dbo.sp_refugio_listar AS
    SELECT r.*, d.nombre AS calle, CAST(d.altura AS NVARCHAR(20)) AS numero,
           d.localidad, d.partido, d.provincia, cp.codigo_postal AS cp
    FROM dbo.refugio r
    INNER JOIN dbo.direccion d ON r.id_direccion = d.id_direccion
    LEFT JOIN dbo.codigo_postal cp ON cp.direccion_id = d.id_direccion;
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_obtener @id INT AS
    SELECT r.*, d.nombre AS calle, CAST(d.altura AS NVARCHAR(20)) AS numero,
           d.localidad, d.partido, d.provincia, cp.codigo_postal AS cp
    FROM dbo.refugio r
    INNER JOIN dbo.direccion d ON r.id_direccion = d.id_direccion
    LEFT JOIN dbo.codigo_postal cp ON cp.direccion_id = d.id_direccion
    WHERE r.id_refugio = @id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_crear
    @id_direccion INT, @nombre NVARCHAR(100), @email NVARCHAR(100), @telefono NVARCHAR(50),
    @capacidad INT, @responsable NVARCHAR(100), @id INT OUTPUT
AS
    INSERT INTO dbo.refugio (id_direccion, nombre, email, telefono, capacidad, responsable)
    VALUES (@id_direccion, @nombre, @email, @telefono, @capacidad, @responsable);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_actualizar
    @id INT, @id_direccion INT, @nombre NVARCHAR(100), @email NVARCHAR(100),
    @telefono NVARCHAR(50), @capacidad INT, @responsable NVARCHAR(100)
AS
    UPDATE dbo.refugio SET id_direccion=@id_direccion, nombre=@nombre, email=@email,
           telefono=@telefono, capacidad=@capacidad, responsable=@responsable
    WHERE id_refugio=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_refugio_eliminar @id INT AS
    DELETE FROM dbo.refugio WHERE id_refugio = @id;
GO

-- ========== ANIMAL ==========
CREATE OR ALTER PROCEDURE dbo.sp_animal_listar AS
    SELECT a.*, ua.id_refugio, r.nombre AS refugio_nombre
    FROM dbo.animal a
    LEFT JOIN dbo.ubicacion_animal ua ON ua.id_animal = a.id_animal AND ua.es_actual = 1
    LEFT JOIN dbo.refugio r ON ua.id_refugio = r.id_refugio
    ORDER BY a.id_animal;
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_obtener @id INT AS
    SELECT a.*, ua.id_refugio, r.nombre AS refugio_nombre
    FROM dbo.animal a
    LEFT JOIN dbo.ubicacion_animal ua ON ua.id_animal = a.id_animal AND ua.es_actual = 1
    LEFT JOIN dbo.refugio r ON ua.id_refugio = r.id_refugio
    WHERE a.id_animal = @id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_crear
    @id_refugio INT, @especie NVARCHAR(50), @raza NVARCHAR(50), @nombre NVARCHAR(100),
    @fecha_nacimiento DATE, @sexo CHAR(1), @fecha_ingreso DATE, @castrado BIT, @id INT OUTPUT
AS
    INSERT INTO dbo.animal (especie, raza, nombre, fecha_nacimiento_estimada, sexo, fecha_ingreso, castrado, estado)
    VALUES (@especie, @raza, @nombre, @fecha_nacimiento, @sexo, @fecha_ingreso, @castrado, N'En refugio');
    SET @id = SCOPE_IDENTITY();
    INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual)
    VALUES (@id, @id_refugio, @fecha_ingreso, N'Ingreso inicial', 1);
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_actualizar
    @id INT, @id_refugio INT, @especie NVARCHAR(50), @raza NVARCHAR(50), @nombre NVARCHAR(100),
    @fecha_nacimiento DATE, @sexo CHAR(1), @fecha_ingreso DATE, @castrado BIT, @estado NVARCHAR(25)
AS
    UPDATE dbo.animal SET especie=@especie, raza=@raza, nombre=@nombre,
           fecha_nacimiento_estimada=@fecha_nacimiento, sexo=@sexo, fecha_ingreso=@fecha_ingreso,
           castrado=@castrado, estado=@estado
    WHERE id_animal=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_animal_eliminar @id INT AS
    DELETE FROM dbo.animal WHERE id_animal = @id;
GO

-- ========== HISTORIAL_MEDICO ==========
CREATE OR ALTER PROCEDURE dbo.sp_historial_listar AS SELECT * FROM dbo.historial_medico;
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_obtener @id INT AS SELECT * FROM dbo.historial_medico WHERE id_historial_medico=@id;
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_por_animal @id_animal INT AS
    SELECT * FROM dbo.historial_medico WHERE id_animal=@id_animal ORDER BY fecha DESC;
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_crear
    @id_animal INT, @nombre_veterinaria NVARCHAR(100), @observacion NVARCHAR(200),
    @medicamento NVARCHAR(150), @diagnostico NVARCHAR(150), @tipo_intervencion NVARCHAR(100),
    @fecha DATE, @antirrabica BIT, @sextuple BIT, @triple BIT, @id INT OUTPUT
AS
    INSERT INTO dbo.historial_medico (id_animal, nombre_veterinaria, observacion, medicamento,
        diagnostico, tipo_intervencion, fecha, antirrabica_anual, sextuple_anual, triple_anual)
    VALUES (@id_animal, @nombre_veterinaria, @observacion, @medicamento, @diagnostico,
        @tipo_intervencion, @fecha, @antirrabica, @sextuple, @triple);
    SET @id = SCOPE_IDENTITY();
GO
CREATE OR ALTER PROCEDURE dbo.sp_historial_eliminar @id INT AS DELETE FROM dbo.historial_medico WHERE id_historial_medico=@id;
GO

-- ========== UBICACION_ANIMAL ==========
CREATE OR ALTER PROCEDURE dbo.sp_ubicacion_listar AS SELECT * FROM dbo.ubicacion_animal;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ubicacion_por_animal @id_animal INT AS
    SELECT * FROM dbo.ubicacion_animal WHERE id_animal=@id_animal ORDER BY fecha_ingreso DESC;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ubicacion_crear
    @id_animal INT, @id_refugio INT, @fecha_ingreso DATE, @motivo NVARCHAR(150),
    @es_actual BIT, @id INT OUTPUT
AS
    IF @es_actual = 1
        UPDATE dbo.ubicacion_animal SET es_actual=0, fecha_salida=CAST(GETDATE() AS DATE)
        WHERE id_animal=@id_animal AND es_actual=1;
    INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual)
    VALUES (@id_animal, @id_refugio, @fecha_ingreso, @motivo, @es_actual);
    IF @es_actual = 1
        UPDATE dbo.animal SET estado = N'En refugio' WHERE id_animal = @id_animal;
    SET @id = SCOPE_IDENTITY();
GO

-- ========== ADOPTANTE, HOGAR, ADOPCION, ETAPA, TRANSITO ==========
CREATE OR ALTER PROCEDURE dbo.sp_adoptante_listar AS SELECT * FROM dbo.adoptante;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adoptante_obtener @id INT AS SELECT * FROM dbo.adoptante WHERE id_adoptante=@id;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adoptante_crear
    @id_direccion INT, @dni NVARCHAR(20), @nombre NVARCHAR(100), @apellido NVARCHAR(100),
    @email NVARCHAR(100), @telefono NVARCHAR(50), @previo BIT, @id INT OUTPUT
AS
    INSERT INTO dbo.adoptante (id_direccion, dni, nombre, apellido, email, telefono, adoptante_previo)
    VALUES (@id_direccion, @dni, @nombre, @apellido, @email, @telefono, @previo);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_hogar_transito_listar AS SELECT * FROM dbo.hogar_transito;
GO
CREATE OR ALTER PROCEDURE dbo.sp_hogar_transito_obtener @id INT AS SELECT * FROM dbo.hogar_transito WHERE id_hogar_transito=@id;
GO

CREATE OR ALTER PROCEDURE dbo.sp_adopcion_listar AS SELECT * FROM dbo.adopcion;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adopcion_obtener @id INT AS SELECT * FROM dbo.adopcion WHERE id_adopcion=@id;
GO
CREATE OR ALTER PROCEDURE dbo.sp_adopcion_crear
    @id_animal INT, @id_adoptante INT, @fecha DATE, @estado NVARCHAR(100), @id INT OUTPUT
AS
    INSERT INTO dbo.adopcion (id_animal, id_adoptante, fecha_solicitud, estado_actual)
    VALUES (@id_animal, @id_adoptante, @fecha, @estado);
    SET @id = SCOPE_IDENTITY();
GO

CREATE OR ALTER PROCEDURE dbo.sp_etapa_adopcion_listar AS SELECT * FROM dbo.etapa_adopcion;
GO
CREATE OR ALTER PROCEDURE dbo.sp_etapa_por_adopcion @id_adopcion INT AS
    SELECT * FROM dbo.etapa_adopcion WHERE id_adopcion=@id_adopcion ORDER BY fecha_inicio;
GO

CREATE OR ALTER PROCEDURE dbo.sp_transito_listar AS SELECT * FROM dbo.transito;
GO
CREATE OR ALTER PROCEDURE dbo.sp_transito_obtener @id INT AS SELECT * FROM dbo.transito WHERE id_transito=@id;
GO

-- Consultas analíticas del equipo
CREATE OR ALTER PROCEDURE dbo.sp_consulta_transitos_activos AS
    SELECT a.nombre AS animal, ht.nombre + N' ' + ht.apellido AS hogar_transito, t.estado_actual
    FROM dbo.transito t
    INNER JOIN dbo.animal a ON t.id_animal = a.id_animal
    INNER JOIN dbo.hogar_transito ht ON t.id_hogar_transito = ht.id_hogar_transito
    WHERE t.estado_actual = N'En tránsito';
GO

CREATE OR ALTER PROCEDURE dbo.sp_consulta_adopciones_por_mes AS
    SELECT YEAR(fecha_solicitud) AS anio, MONTH(fecha_solicitud) AS mes, COUNT(*) AS adopciones
    FROM dbo.adopcion
    WHERE estado_actual = N'Concretada'
    GROUP BY YEAR(fecha_solicitud), MONTH(fecha_solicitud)
    ORDER BY anio, mes;
GO

CREATE OR ALTER PROCEDURE dbo.sp_consulta_traslados_refugios AS
    SELECT a.nombre, r.nombre AS refugio, ua.fecha_ingreso, ua.motivo_traslado
    FROM dbo.ubicacion_animal ua
    INNER JOIN dbo.animal a ON ua.id_animal = a.id_animal
    INNER JOIN dbo.refugio r ON ua.id_refugio = r.id_refugio
    ORDER BY ua.fecha_ingreso DESC;
GO
