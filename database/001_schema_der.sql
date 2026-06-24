-- =============================================================================
-- PatitasUnidas - Modelo DER (versión equipo - corregida)
-- Base: [Patitas Unidas] | Convención: dbo + snake_case para JPA
-- Ejecutar en orden: 001 -> 002 -> 003 -> 004 -> 005 -> 006
-- =============================================================================

USE [Patitas Unidas];
GO

IF OBJECT_ID(N'dbo.vw_animales_disponibles_resumen', N'V') IS NOT NULL DROP VIEW dbo.vw_animales_disponibles_resumen;
IF OBJECT_ID(N'dbo.vw_refugios_ocupacion', N'V') IS NOT NULL DROP VIEW dbo.vw_refugios_ocupacion;
IF OBJECT_ID(N'dbo.vw_adopciones_detalle', N'V') IS NOT NULL DROP VIEW dbo.vw_adopciones_detalle;
IF OBJECT_ID(N'dbo.trg_adopcion_concretada', N'TR') IS NOT NULL DROP TRIGGER dbo.trg_adopcion_concretada;
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
IF OBJECT_ID(N'dbo.codigo_postal', N'U') IS NOT NULL DROP TABLE dbo.codigo_postal;
IF OBJECT_ID(N'dbo.direccion', N'U') IS NOT NULL DROP TABLE dbo.direccion;
GO

-- DIRECCION
CREATE TABLE dbo.direccion (
    id_direccion INT IDENTITY(1,1) NOT NULL,
    nombre       NVARCHAR(120) NOT NULL,
    altura       INT NOT NULL,
    localidad    NVARCHAR(80) NULL,
    partido      NVARCHAR(80) NULL,
    provincia    NVARCHAR(50) NOT NULL CONSTRAINT DF_direccion_provincia DEFAULT N'BUENOS AIRES',
    CONSTRAINT PK_direccion PRIMARY KEY (id_direccion),
    CONSTRAINT CK_direccion_provincia CHECK (provincia = N'BUENOS AIRES')
);
GO

-- CODIGO_POSTAL (rango por calle / dirección)
CREATE TABLE dbo.codigo_postal (
    cpa_id          INT IDENTITY(1,1) NOT NULL,
    direccion_id    INT NOT NULL,
    altura_desde    INT NOT NULL,
    altura_hasta    INT NOT NULL,
    paridad         NVARCHAR(5) NOT NULL,
    codigo_postal   CHAR(8) NOT NULL,
    CONSTRAINT PK_codigo_postal PRIMARY KEY (cpa_id),
    CONSTRAINT FK_codigo_postal_direccion FOREIGN KEY (direccion_id) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_codigo_postal_paridad CHECK (paridad IN (N'PAR', N'IMPAR', N'AMBOS'))
);
GO

-- ANIMAL (ubicación actual vía ubicacion_animal)
CREATE TABLE dbo.animal (
    id_animal                  INT IDENTITY(1,1) NOT NULL,
    fecha_ingreso              DATE NOT NULL CONSTRAINT DF_animal_fecha_ingreso DEFAULT CAST(GETDATE() AS DATE),
    especie                    NVARCHAR(50) NOT NULL,
    raza                       NVARCHAR(50) NULL,
    nombre                     NVARCHAR(100) NOT NULL,
    fecha_nacimiento_estimada  DATE NULL,
    estado                     NVARCHAR(25) NULL,
    sexo                       CHAR(1) NULL,
    castrado                   BIT NOT NULL CONSTRAINT DF_animal_castrado DEFAULT 0,
    CONSTRAINT PK_animal PRIMARY KEY (id_animal),
    CONSTRAINT CK_animal_estado CHECK (estado IS NULL OR estado IN (N'En refugio', N'En tránsito', N'Adoptado')),
    CONSTRAINT CK_animal_sexo CHECK (sexo IS NULL OR sexo IN ('M', 'F'))
);
GO

-- REFUGIO
CREATE TABLE dbo.refugio (
    id_refugio   INT IDENTITY(1,1) NOT NULL,
    id_direccion INT NOT NULL,
    nombre       NVARCHAR(100) NOT NULL,
    telefono     NVARCHAR(50) NULL,
    email        NVARCHAR(100) NULL,
    capacidad    INT NOT NULL,
    responsable  NVARCHAR(100) NULL,
    CONSTRAINT PK_refugio PRIMARY KEY (id_refugio),
    CONSTRAINT FK_refugio_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_refugio_capacidad CHECK (capacidad > 0)
);
GO

-- ADOPTANTE
CREATE TABLE dbo.adoptante (
    id_adoptante     INT IDENTITY(1,1) NOT NULL,
    id_direccion     INT NOT NULL,
    dni              NVARCHAR(20) NOT NULL,
    nombre           NVARCHAR(100) NOT NULL,
    apellido         NVARCHAR(100) NOT NULL,
    telefono         NVARCHAR(50) NOT NULL,
    email            NVARCHAR(100) NULL,
    adoptante_previo BIT NOT NULL CONSTRAINT DF_adoptante_previo DEFAULT 0,
    CONSTRAINT PK_adoptante PRIMARY KEY (id_adoptante),
    CONSTRAINT UQ_adoptante_dni UNIQUE (dni),
    CONSTRAINT FK_adoptante_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion)
);
GO

-- HOGAR_TRANSITO
CREATE TABLE dbo.hogar_transito (
    id_hogar_transito  INT IDENTITY(1,1) NOT NULL,
    id_direccion       INT NOT NULL,
    dni                NVARCHAR(20) NOT NULL,
    nombre             NVARCHAR(100) NOT NULL,
    apellido           NVARCHAR(100) NOT NULL,
    telefono           NVARCHAR(50) NOT NULL,
    email              NVARCHAR(100) NULL,
    capacidad_aceptada INT NOT NULL,
    acepta_perros      BIT NOT NULL CONSTRAINT DF_ht_perros DEFAULT 0,
    acepta_gatos       BIT NOT NULL CONSTRAINT DF_ht_gatos DEFAULT 0,
    CONSTRAINT PK_hogar_transito PRIMARY KEY (id_hogar_transito),
    CONSTRAINT UQ_hogar_transito_dni UNIQUE (dni),
    CONSTRAINT FK_hogar_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_hogar_capacidad CHECK (capacidad_aceptada > 0)
);
GO

-- HISTORIAL_MEDICO
CREATE TABLE dbo.historial_medico (
    id_historial_medico INT IDENTITY(1,1) NOT NULL,
    id_animal           INT NOT NULL,
    fecha               DATE NOT NULL,
    tipo_intervencion   NVARCHAR(100) NOT NULL,
    diagnostico         NVARCHAR(150) NULL,
    medicamento         NVARCHAR(150) NULL,
    nombre_veterinaria  NVARCHAR(100) NULL,
    antirrabica_anual   BIT NOT NULL CONSTRAINT DF_hm_antirrabica DEFAULT 0,
    sextuple_anual      BIT NOT NULL CONSTRAINT DF_hm_sextuple DEFAULT 0,
    triple_anual        BIT NOT NULL CONSTRAINT DF_hm_triple DEFAULT 0,
    observacion         NVARCHAR(200) NULL,
    CONSTRAINT PK_historial_medico PRIMARY KEY (id_historial_medico),
    CONSTRAINT FK_historial_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal)
);
GO

-- UBICACION_ANIMAL (historial de traslados)
CREATE TABLE dbo.ubicacion_animal (
    id_ubicacion_animal INT IDENTITY(1,1) NOT NULL,
    id_animal           INT NOT NULL,
    id_refugio          INT NOT NULL,
    fecha_ingreso       DATE NOT NULL,
    fecha_salida        DATE NULL,
    motivo_traslado     NVARCHAR(150) NULL,
    es_actual           BIT NOT NULL CONSTRAINT DF_ubicacion_actual DEFAULT 1,
    CONSTRAINT PK_ubicacion_animal PRIMARY KEY (id_ubicacion_animal),
    CONSTRAINT FK_ubicacion_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_ubicacion_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_ubicacion_fechas CHECK (fecha_salida IS NULL OR fecha_salida >= fecha_ingreso)
);
GO

-- TRANSITO
CREATE TABLE dbo.transito (
    id_transito         INT IDENTITY(1,1) NOT NULL,
    id_animal           INT NOT NULL,
    id_hogar_transito   INT NOT NULL,
    id_refugio          INT NOT NULL,
    fecha_inicio        DATE NOT NULL,
    estado_actual       NVARCHAR(100) NULL,
    fecha_fin_estimada  DATE NULL,
    fecha_fin_real      DATE NULL,
    observaciones       NVARCHAR(200) NULL,
    CONSTRAINT PK_transito PRIMARY KEY (id_transito),
    CONSTRAINT FK_transito_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_transito_hogar FOREIGN KEY (id_hogar_transito) REFERENCES dbo.hogar_transito (id_hogar_transito),
    CONSTRAINT FK_transito_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_transito_fechas CHECK (fecha_fin_real IS NULL OR fecha_fin_real >= fecha_inicio),
    CONSTRAINT CK_transito_estado CHECK (estado_actual IS NULL OR estado_actual IN (N'En tránsito', N'Finalizado', N'Cancelado'))
);
GO

-- ADOPCION
CREATE TABLE dbo.adopcion (
    id_adopcion     INT IDENTITY(1,1) NOT NULL,
    id_animal       INT NOT NULL,
    id_adoptante    INT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    estado_actual   NVARCHAR(100) NULL,
    CONSTRAINT PK_adopcion PRIMARY KEY (id_adopcion),
    CONSTRAINT FK_adopcion_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_adopcion_adoptante FOREIGN KEY (id_adoptante) REFERENCES dbo.adoptante (id_adoptante),
    CONSTRAINT CK_adopcion_estado CHECK (estado_actual IS NULL OR estado_actual IN (N'Solicitada', N'En proceso', N'Aprobada', N'Rechazada', N'Concretada'))
);
GO

-- ETAPA_ADOPCION
CREATE TABLE dbo.etapa_adopcion (
    id_etapa_adopcion INT IDENTITY(1,1) NOT NULL,
    id_adopcion       INT NOT NULL,
    fecha_inicio      DATE NOT NULL,
    id_refugio        INT NOT NULL,
    fecha_fin         DATE NULL,
    observaciones     NVARCHAR(200) NULL,
    CONSTRAINT PK_etapa_adopcion PRIMARY KEY (id_etapa_adopcion),
    CONSTRAINT FK_etapa_adopcion FOREIGN KEY (id_adopcion) REFERENCES dbo.adopcion (id_adopcion),
    CONSTRAINT FK_etapa_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_etapa_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);
GO

CREATE INDEX IX_historial_animal ON dbo.historial_medico (id_animal);
CREATE INDEX IX_ubicacion_animal ON dbo.ubicacion_animal (id_animal, es_actual);
CREATE INDEX IX_adopcion_estado ON dbo.adopcion (estado_actual);
CREATE INDEX IX_transito_estado ON dbo.transito (estado_actual);
GO

-- ===================== DATOS SEMILLA =====================

SET IDENTITY_INSERT dbo.direccion ON;
INSERT INTO dbo.direccion (id_direccion, nombre, altura, localidad, partido, provincia) VALUES
(1, N'Av. del Libertador', 4500, N'Vicente López', N'Vicente López', N'BUENOS AIRES'),
(2, N'Calle 14', 65, N'La Plata', N'La Plata', N'BUENOS AIRES'),
(3, N'Ruta 8', 3200, N'Morón', N'Morón', N'BUENOS AIRES'),
(4, N'Av. Corrientes', 3200, N'CABA', N'CABA', N'BUENOS AIRES');
SET IDENTITY_INSERT dbo.direccion OFF;
GO

INSERT INTO dbo.codigo_postal (direccion_id, altura_desde, altura_hasta, paridad, codigo_postal) VALUES
(1, 4500, 4500, N'AMBOS', N'B1638   '),
(2, 65, 65, N'AMBOS', N'B1900   '),
(3, 3200, 3200, N'AMBOS', N'B1708   '),
(4, 3200, 3200, N'AMBOS', N'C1195   ');
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
INSERT INTO dbo.animal (id_animal, especie, raza, nombre, fecha_nacimiento_estimada, estado, sexo, fecha_ingreso, castrado) VALUES
(1, N'Perro', N'Mestizo',  N'Luna',  '2021-03-12', N'En refugio', 'F', '2024-03-12', 1),
(2, N'Perro', N'Labrador', N'Rocky', '2022-05-01', N'En refugio', 'M', '2024-05-01', 1),
(3, N'Gato',  N'Siames',   N'Michi', '2023-01-20', N'En refugio', 'F', '2024-01-20', 1),
(4, N'Gato',  N'Mestizo',  N'Nina',  '2020-11-08', N'Adoptado',   'F', '2023-11-08', 1),
(5, N'Perro', N'Beagle',   N'Toby',  '2019-06-15', N'En tránsito', 'M', '2024-06-15', 0),
(6, N'Gato',  N'Persa',    N'Cleo',  '2022-02-28', N'En refugio', 'F', '2024-02-28', 1);
SET IDENTITY_INSERT dbo.animal OFF;
GO

INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, motivo_traslado, es_actual) VALUES
(1, 1, '2024-03-12', N'Ingreso inicial', 1),
(2, 1, '2024-05-01', N'Ingreso inicial', 1),
(3, 2, '2024-01-20', N'Ingreso inicial', 1),
(4, 2, '2023-11-08', N'Ingreso inicial', 0),
(5, 3, '2024-06-15', N'Ingreso inicial', 1),
(6, 4, '2024-02-28', N'Ingreso inicial', 1);
GO

INSERT INTO dbo.historial_medico (id_animal, nombre_veterinaria, observacion, medicamento, diagnostico, tipo_intervencion, fecha, antirrabica_anual, sextuple_anual, triple_anual) VALUES
(1, N'Vet San Martín', N'Control general', NULL, N'Sano', N'Consulta', '2024-03-15', 1, 1, 0),
(2, N'Vet San Martín', NULL, NULL, N'Sano', N'Consulta', '2024-05-05', 1, 1, 0),
(3, N'Vet La Plata', N'Revisión felina', NULL, N'Sano', N'Consulta', '2024-01-25', 0, 0, 1);
GO

SET IDENTITY_INSERT dbo.direccion ON;
INSERT INTO dbo.direccion (id_direccion, nombre, altura, localidad, partido, provincia) VALUES
(5, N'Mitre', 1200, N'Lanús', N'Lanús', N'BUENOS AIRES'),
(6, N'Belgrano', 800, N'Quilmes', N'Quilmes', N'BUENOS AIRES'),
(7, N'Sarmiento', 450, N'Avellaneda', N'Avellaneda', N'BUENOS AIRES');
SET IDENTITY_INSERT dbo.direccion OFF;
GO

INSERT INTO dbo.codigo_postal (direccion_id, altura_desde, altura_hasta, paridad, codigo_postal) VALUES
(5, 1200, 1200, N'AMBOS', N'B1824   '),
(6, 800, 800, N'AMBOS', N'B1878   '),
(7, 450, 450, N'AMBOS', N'B1870   ');
GO

INSERT INTO dbo.adoptante (id_direccion, dni, nombre, apellido, email, telefono, adoptante_previo) VALUES
(5, N'30123456', N'Laura', N'Fernández', N'laura@mail.com', N'11-5555-0101', 0);
GO

INSERT INTO dbo.adopcion (id_animal, id_adoptante, fecha_solicitud, estado_actual) VALUES
(4, 1, '2024-08-01', N'Concretada');
GO

INSERT INTO dbo.etapa_adopcion (id_adopcion, id_refugio, fecha_inicio, fecha_fin, observaciones) VALUES
(1, 2, '2024-08-01', '2024-08-10', N'Entrevista inicial'),
(1, 2, '2024-08-11', '2024-08-20', N'Entrega y seguimiento');
GO

INSERT INTO dbo.hogar_transito (id_direccion, dni, nombre, apellido, email, telefono, capacidad_aceptada, acepta_gatos, acepta_perros) VALUES
(7, N'28987654', N'Pedro', N'Gómez', N'pedro@mail.com', N'11-5555-0202', 3, 1, 1);
GO

INSERT INTO dbo.transito (id_animal, id_hogar_transito, id_refugio, fecha_inicio, fecha_fin_estimada, estado_actual, observaciones) VALUES
(5, 1, 3, '2024-07-01', '2024-09-01', N'En tránsito', N'Tránsito post-operatorio');
GO
