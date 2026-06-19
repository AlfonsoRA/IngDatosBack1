-- =============================================================================
-- PatitasUnidas - Modelo completo según DER
-- Base: [Patitas Unidas] | Servidor: RICARDO\SQLEXPRESS02
-- Ejecutar en orden: 001 -> 003 -> 004 -> 005 -> 006
-- =============================================================================

USE [Patitas Unidas];
GO

-- Eliminar objetos dependientes
IF OBJECT_ID(N'dbo.vw_animales_disponibles_resumen', N'V') IS NOT NULL DROP VIEW dbo.vw_animales_disponibles_resumen;
IF OBJECT_ID(N'dbo.trg_adopcion_completada', N'TR') IS NOT NULL DROP TRIGGER dbo.trg_adopcion_completada;
IF OBJECT_ID(N'dbo.trg_refugio_sobrecupo', N'TR') IS NOT NULL DROP TRIGGER dbo.trg_refugio_sobrecupo;
GO

IF OBJECT_ID(N'dbo.transito', N'U') IS NOT NULL DROP TABLE dbo.transito;
IF OBJECT_ID(N'dbo.etapa_adopcion', N'U') IS NOT NULL DROP TABLE dbo.etapa_adopcion;
IF OBJECT_ID(N'dbo.adopcion', N'U') IS NOT NULL DROP TABLE dbo.adopcion;
IF OBJECT_ID(N'dbo.hogar_transito', N'U') IS NOT NULL DROP TABLE dbo.hogar_transito;
IF OBJECT_ID(N'dbo.adoptante', N'U') IS NOT NULL DROP TABLE dbo.adoptante;
IF OBJECT_ID(N'dbo.ubicacion_animal', N'U') IS NOT NULL DROP TABLE dbo.ubicacion_animal;
IF OBJECT_ID(N'dbo.historial_medico', N'U') IS NOT NULL DROP TABLE dbo.historial_medico;
IF OBJECT_ID(N'dbo.animal', N'U') IS NOT NULL DROP TABLE dbo.animal;
IF OBJECT_ID(N'dbo.refugio', N'U') IS NOT NULL DROP TABLE dbo.refugio;
IF OBJECT_ID(N'dbo.direccion', N'U') IS NOT NULL DROP TABLE dbo.direccion;
GO

-- DIRECCION
CREATE TABLE dbo.direccion (
    id_direccion BIGINT IDENTITY(1,1) NOT NULL,
    calle        NVARCHAR(120) NOT NULL,
    numero       NVARCHAR(20)  NULL,
    localidad    NVARCHAR(100) NOT NULL,
    partido      NVARCHAR(100) NULL,
    cp           NVARCHAR(10)  NULL,
    CONSTRAINT PK_direccion PRIMARY KEY (id_direccion)
);
GO

-- REFUGIO (1:1 con DIRECCION)
CREATE TABLE dbo.refugio (
    id_refugio   BIGINT IDENTITY(1,1) NOT NULL,
    id_direccion BIGINT NOT NULL,
    nombre       NVARCHAR(120) NOT NULL,
    email        NVARCHAR(120) NULL,
    telefono     NVARCHAR(30)  NULL,
    capacidad    INT NOT NULL,
    responsable  NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_refugio PRIMARY KEY (id_refugio),
    CONSTRAINT UQ_refugio_direccion UNIQUE (id_direccion),
    CONSTRAINT FK_refugio_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_refugio_capacidad CHECK (capacidad >= 1)
);
GO

-- ANIMAL (ALOJA en REFUGIO)
CREATE TABLE dbo.animal (
    id_animal     BIGINT IDENTITY(1,1) NOT NULL,
    id_refugio    BIGINT NOT NULL,
    especie       NVARCHAR(50)  NOT NULL,
    raza          NVARCHAR(80)  NULL,
    nombre        NVARCHAR(120) NOT NULL,
    edad          INT NULL,
    fecha_ingreso DATE NOT NULL,
    es_castrado   BIT NOT NULL CONSTRAINT DF_animal_castrado DEFAULT 0,
    CONSTRAINT PK_animal PRIMARY KEY (id_animal),
    CONSTRAINT FK_animal_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_animal_edad CHECK (edad IS NULL OR edad >= 0)
);
GO

-- HISTORIAL_MEDICO
CREATE TABLE dbo.historial_medico (
    id_historial_medico BIGINT IDENTITY(1,1) NOT NULL,
    id_animal           BIGINT NOT NULL,
    nombre_veterinaria  NVARCHAR(120) NULL,
    observacion         NVARCHAR(500) NULL,
    medicamento         NVARCHAR(200) NULL,
    diagnostico         NVARCHAR(300) NULL,
    tipo_intervencion   NVARCHAR(100) NULL,
    fecha               DATE NOT NULL,
    antirrabica_anual   BIT NOT NULL CONSTRAINT DF_hm_antirrabica DEFAULT 0,
    sextuple_anual      BIT NOT NULL CONSTRAINT DF_hm_sextuple DEFAULT 0,
    triple_anual        BIT NOT NULL CONSTRAINT DF_hm_triple DEFAULT 0,
    CONSTRAINT PK_historial_medico PRIMARY KEY (id_historial_medico),
    CONSTRAINT FK_historial_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal)
);
GO

-- UBICACION_ANIMAL (historial de traslados / sedes)
CREATE TABLE dbo.ubicacion_animal (
    id_ubicacion_animal BIGINT IDENTITY(1,1) NOT NULL,
    id_animal           BIGINT NOT NULL,
    id_refugio          BIGINT NOT NULL,
    fecha_ingreso       DATE NOT NULL,
    motivo_traslado     NVARCHAR(200) NULL,
    fecha_salida        DATE NULL,
    es_actual           BIT NOT NULL CONSTRAINT DF_ubicacion_actual DEFAULT 0,
    CONSTRAINT PK_ubicacion_animal PRIMARY KEY (id_ubicacion_animal),
    CONSTRAINT FK_ubicacion_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_ubicacion_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio)
);
GO

-- ADOPTANTE (1:1 DIRECCION)
CREATE TABLE dbo.adoptante (
    id_adoptante     BIGINT IDENTITY(1,1) NOT NULL,
    id_direccion     BIGINT NOT NULL,
    dni              NVARCHAR(20) NOT NULL,
    nombre           NVARCHAR(80) NOT NULL,
    apellido         NVARCHAR(80) NOT NULL,
    email            NVARCHAR(120) NULL,
    telefono         NVARCHAR(30)  NULL,
    adoptante_previo BIT NOT NULL CONSTRAINT DF_adoptante_previo DEFAULT 0,
    CONSTRAINT PK_adoptante PRIMARY KEY (id_adoptante),
    CONSTRAINT UQ_adoptante_direccion UNIQUE (id_direccion),
    CONSTRAINT UQ_adoptante_dni UNIQUE (dni),
    CONSTRAINT FK_adoptante_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion)
);
GO

-- HOGAR_TRANSITO (1:1 DIRECCION)
CREATE TABLE dbo.hogar_transito (
    id_hogar_transito BIGINT IDENTITY(1,1) NOT NULL,
    id_direccion      BIGINT NOT NULL,
    dni               NVARCHAR(20) NOT NULL,
    nombre            NVARCHAR(80) NOT NULL,
    apellido          NVARCHAR(80) NOT NULL,
    email             NVARCHAR(120) NULL,
    telefono          NVARCHAR(30)  NULL,
    capacidad_maxima  INT NOT NULL,
    tiene_gatos       BIT NOT NULL CONSTRAINT DF_ht_gatos DEFAULT 0,
    tiene_perros      BIT NOT NULL CONSTRAINT DF_ht_perros DEFAULT 0,
    CONSTRAINT PK_hogar_transito PRIMARY KEY (id_hogar_transito),
    CONSTRAINT UQ_hogar_direccion UNIQUE (id_direccion),
    CONSTRAINT UQ_hogar_dni UNIQUE (dni),
    CONSTRAINT FK_hogar_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_hogar_capacidad CHECK (capacidad_maxima >= 1)
);
GO

-- ADOPCION (1 animal -> 0..1 adopcion activa)
CREATE TABLE dbo.adopcion (
    id_adopcion     BIGINT IDENTITY(1,1) NOT NULL,
    id_animal       BIGINT NOT NULL,
    id_adoptante    BIGINT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    estado_actual   NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_adopcion PRIMARY KEY (id_adopcion),
    CONSTRAINT UQ_adopcion_animal UNIQUE (id_animal),
    CONSTRAINT FK_adopcion_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_adopcion_adoptante FOREIGN KEY (id_adoptante) REFERENCES dbo.adoptante (id_adoptante)
);
GO

-- ETAPA_ADOPCION
CREATE TABLE dbo.etapa_adopcion (
    id_etapa_adopcion BIGINT IDENTITY(1,1) NOT NULL,
    id_adopcion       BIGINT NOT NULL,
    id_refugio        BIGINT NOT NULL,
    fecha_inicio      DATE NOT NULL,
    fecha_fin         DATE NULL,
    observaciones     NVARCHAR(500) NULL,
    CONSTRAINT PK_etapa_adopcion PRIMARY KEY (id_etapa_adopcion),
    CONSTRAINT FK_etapa_adopcion FOREIGN KEY (id_adopcion) REFERENCES dbo.adopcion (id_adopcion),
    CONSTRAINT FK_etapa_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio)
);
GO

-- TRANSITO (foster)
CREATE TABLE dbo.transito (
    id_transito         BIGINT IDENTITY(1,1) NOT NULL,
    id_animal           BIGINT NOT NULL,
    id_hogar_transito   BIGINT NOT NULL,
    id_refugio          BIGINT NOT NULL,
    fecha_inicio        DATE NOT NULL,
    fecha_fin_estimada  DATE NULL,
    fecha_fin_real      DATE NULL,
    estado_actual       NVARCHAR(50) NOT NULL,
    observaciones       NVARCHAR(500) NULL,
    CONSTRAINT PK_transito PRIMARY KEY (id_transito),
    CONSTRAINT FK_transito_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_transito_hogar FOREIGN KEY (id_hogar_transito) REFERENCES dbo.hogar_transito (id_hogar_transito),
    CONSTRAINT FK_transito_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio)
);
GO

CREATE INDEX IX_animal_refugio ON dbo.animal (id_refugio);
CREATE INDEX IX_historial_animal ON dbo.historial_medico (id_animal);
CREATE INDEX IX_ubicacion_animal ON dbo.ubicacion_animal (id_animal, es_actual);
CREATE INDEX IX_adopcion_estado ON dbo.adopcion (estado_actual);
CREATE INDEX IX_transito_estado ON dbo.transito (estado_actual);
GO

-- ===================== DATOS SEMILLA =====================

SET IDENTITY_INSERT dbo.direccion ON;
INSERT INTO dbo.direccion (id_direccion, calle, numero, localidad, partido, cp) VALUES
(1, N'Av. del Libertador', N'4500', N'Vicente López', N'Vicente López', N'1638'),
(2, N'Calle 14', N'65', N'La Plata', N'La Plata', N'1900'),
(3, N'Ruta 8', N'km 32', N'Morón', N'Morón', N'1708'),
(4, N'Av. Corrientes', N'3200', N'CABA', N'CABA', N'C1195');
SET IDENTITY_INSERT dbo.direccion OFF;
GO

SET IDENTITY_INSERT dbo.refugio ON;
INSERT INTO dbo.refugio (id_refugio, id_direccion, nombre, email, telefono, capacidad, responsable) VALUES
(1, 1, N'Patitas Norte',  N'norte@patitasunidas.org',  N'11-4444-0001', 80, N'María González'),
(2, 2, N'Patitas Sur',    N'sur@patitasunidas.org',     N'11-4444-0002', 60, N'Juan Pérez'),
(3, 3, N'Patitas Oeste',  N'oeste@patitasunidas.org',   N'11-4444-0003', 70, N'Ana Rodríguez'),
(4, 4, N'Patitas Centro', N'centro@patitasunidas.org', N'11-4444-0004', 50, N'Carlos Méndez');
SET IDENTITY_INSERT dbo.refugio OFF;
GO

SET IDENTITY_INSERT dbo.animal ON;
INSERT INTO dbo.animal (id_animal, id_refugio, especie, raza, nombre, edad, fecha_ingreso, es_castrado) VALUES
(1, 1, N'Perro', N'Mestizo',  N'Luna',  3, '2024-03-12', 1),
(2, 1, N'Perro', N'Labrador', N'Rocky', 2, '2024-05-01', 1),
(3, 2, N'Gato',  N'Siames',   N'Michi', 1, '2024-01-20', 1),
(4, 2, N'Gato',  N'Mestizo',  N'Nina',  4, '2023-11-08', 1),
(5, 3, N'Perro', N'Beagle',   N'Toby',  5, '2024-06-15', 0),
(6, 4, N'Gato',  N'Persa',    N'Cleo',  2, '2024-02-28', 1);
SET IDENTITY_INSERT dbo.animal OFF;
GO

INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual) VALUES
(1, 1, '2024-03-12', N'Ingreso inicial', 1),
(2, 1, '2024-05-01', N'Ingreso inicial', 1),
(3, 2, '2024-01-20', N'Ingreso inicial', 1),
(4, 2, '2023-11-08', N'Ingreso inicial', 1),
(5, 3, '2024-06-15', N'Ingreso inicial', 1),
(6, 4, '2024-02-28', N'Ingreso inicial', 1);
GO

INSERT INTO dbo.historial_medico (id_animal, nombre_veterinaria, observacion, medicamento, diagnostico, tipo_intervencion, fecha, antirrabica_anual, sextuple_anual, triple_anual) VALUES
(1, N'Vet San Martín', N'Control general', NULL, N'Sano', N'Consulta', '2024-03-15', 1, 1, 0),
(2, N'Vet San Martín', NULL, NULL, N'Sano', N'Consulta', '2024-05-05', 1, 1, 0),
(3, N'Vet La Plata', N'Revisión felina', NULL, N'Sano', N'Consulta', '2024-01-25', 0, 0, 1);
GO

SET IDENTITY_INSERT dbo.direccion ON;
INSERT INTO dbo.direccion (id_direccion, calle, numero, localidad, partido, cp) VALUES
(5, N'Mitre', N'1200', N'Lanús', N'Lanús', N'1824'),
(6, N'Belgrano', N'800', N'Quilmes', N'Quilmes', N'1878');
SET IDENTITY_INSERT dbo.direccion OFF;
GO

INSERT INTO dbo.adoptante (id_direccion, dni, nombre, apellido, email, telefono, adoptante_previo) VALUES
(5, N'30123456', N'Laura', N'Fernández', N'laura@mail.com', N'11-5555-0101', 0);
GO

INSERT INTO dbo.adopcion (id_animal, id_adoptante, fecha_solicitud, estado_actual) VALUES
(4, 1, '2024-08-01', N'COMPLETADA');
GO

INSERT INTO dbo.etapa_adopcion (id_adopcion, id_refugio, fecha_inicio, fecha_fin, observaciones) VALUES
(1, 2, '2024-08-01', '2024-08-10', N'Entrevista inicial'),
(1, 2, '2024-08-11', '2024-08-20', N'Entrega y seguimiento');
GO

SET IDENTITY_INSERT dbo.direccion ON;
INSERT INTO dbo.direccion (id_direccion, calle, numero, localidad, partido, cp) VALUES
(7, N'Sarmiento', N'450', N'Avellaneda', N'Avellaneda', N'1870');
SET IDENTITY_INSERT dbo.direccion OFF;
GO

INSERT INTO dbo.hogar_transito (id_direccion, dni, nombre, apellido, email, telefono, capacidad_maxima, tiene_gatos, tiene_perros) VALUES
(7, N'28987654', N'Pedro', N'Gómez', N'pedro@mail.com', N'11-5555-0202', 3, 1, 1);
GO

INSERT INTO dbo.transito (id_animal, id_hogar_transito, id_refugio, fecha_inicio, fecha_fin_estimada, estado_actual, observaciones) VALUES
(5, 1, 3, '2024-07-01', '2024-09-01', N'ACTIVO', N'Tránsito post-operatorio');
GO
