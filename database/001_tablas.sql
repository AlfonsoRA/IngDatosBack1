-- =============================================================================
-- PatitasUnidas V2 — Tablas (schema equipo)
-- Base: [Patitas Unidas] | Ejecutar PRIMERO (como admin en SSMS)
-- =============================================================================

USE [master];
GO

IF DB_ID(N'Patitas Unidas') IS NOT NULL
BEGIN
    ALTER DATABASE [Patitas Unidas] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Patitas Unidas];
END
GO

CREATE DATABASE [Patitas Unidas];
GO

USE [Patitas Unidas];
GO

-- CODIGO_POSTAL (se crea primero; DIRECCION lo referencia)
CREATE TABLE dbo.codigo_postal (
    cpa_id          INT IDENTITY(1,1) NOT NULL,
    nombre_calle    VARCHAR(100) NOT NULL,
    localidad       VARCHAR(50) NULL,
    partido         VARCHAR(50) NULL,
    provincia       VARCHAR(50) NOT NULL CONSTRAINT DF_cp_provincia DEFAULT 'BUENOS AIRES',
    altura_desde    INT NOT NULL,
    altura_hasta    INT NOT NULL,
    paridad         VARCHAR(10) NOT NULL,
    codigo_postal   CHAR(8) NOT NULL,
    CONSTRAINT PK_codigo_postal PRIMARY KEY (cpa_id),
    CONSTRAINT CK_cp_paridad CHECK (paridad IN ('PAR', 'IMPAR', 'AMBOS')),
    CONSTRAINT CK_cp_alturas CHECK (altura_hasta >= altura_desde)
);
GO

CREATE TABLE dbo.direccion (
    id_direccion INT IDENTITY(1,1) NOT NULL,
    cpa_id       INT NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    altura       INT NOT NULL,
    localidad    VARCHAR(50) NULL,
    partido      VARCHAR(50) NULL,
    provincia    VARCHAR(50) NOT NULL CONSTRAINT DF_dir_provincia DEFAULT 'BUENOS AIRES',
    CONSTRAINT PK_direccion PRIMARY KEY (id_direccion),
    CONSTRAINT FK_direccion_codigo_postal FOREIGN KEY (cpa_id) REFERENCES dbo.codigo_postal (cpa_id),
    CONSTRAINT CK_dir_provincia CHECK (provincia = 'BUENOS AIRES')
);
GO

CREATE TABLE dbo.animal (
    id_animal                  INT IDENTITY(1,1) NOT NULL,
    fecha_ingreso              DATE NOT NULL CONSTRAINT DF_animal_fecha_ingreso DEFAULT CAST(GETDATE() AS DATE),
    especie                    VARCHAR(50) NOT NULL,
    raza                       VARCHAR(50) NULL,
    nombre                     VARCHAR(100) NOT NULL,
    fecha_nacimiento_estimada  DATE NULL,
    estado                     VARCHAR(25) NOT NULL CONSTRAINT DF_animal_estado DEFAULT 'En refugio',
    sexo                       CHAR(1) NULL,
    castrado                   BIT NOT NULL CONSTRAINT DF_animal_castrado DEFAULT 0,
    CONSTRAINT PK_animal PRIMARY KEY (id_animal),
    CONSTRAINT CK_animal_estado CHECK (estado IN ('En refugio', 'En tránsito', 'Adoptado')),
    CONSTRAINT CK_animal_sexo CHECK (sexo IS NULL OR sexo IN ('M', 'F'))
);
GO

CREATE TABLE dbo.refugio (
    id_refugio   INT IDENTITY(1,1) NOT NULL,
    id_direccion INT NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    telefono     VARCHAR(50) NULL,
    email        VARCHAR(100) NULL,
    capacidad    INT NOT NULL,
    responsable  VARCHAR(100) NULL,
    CONSTRAINT PK_refugio PRIMARY KEY (id_refugio),
    CONSTRAINT FK_refugio_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_refugio_capacidad CHECK (capacidad > 0)
);
GO

CREATE TABLE dbo.adoptante (
    id_adoptante     INT IDENTITY(1,1) NOT NULL,
    id_direccion     INT NOT NULL,
    dni              VARCHAR(20) NOT NULL,
    nombre           VARCHAR(100) NOT NULL,
    apellido         VARCHAR(100) NOT NULL,
    telefono         VARCHAR(50) NOT NULL,
    email            VARCHAR(100) NULL,
    adoptante_previo BIT NOT NULL CONSTRAINT DF_adoptante_previo DEFAULT 0,
    CONSTRAINT PK_adoptante PRIMARY KEY (id_adoptante),
    CONSTRAINT UQ_adoptante_dni UNIQUE (dni),
    CONSTRAINT FK_adoptante_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion)
);
GO

CREATE TABLE dbo.hogar_transito (
    id_hogar_transito  INT IDENTITY(1,1) NOT NULL,
    id_direccion       INT NOT NULL,
    dni                VARCHAR(20) NOT NULL,
    nombre             VARCHAR(100) NOT NULL,
    apellido           VARCHAR(100) NOT NULL,
    telefono           VARCHAR(50) NOT NULL,
    email              VARCHAR(100) NULL,
    capacidad_aceptada INT NOT NULL,
    acepta_perros      BIT NOT NULL CONSTRAINT DF_ht_perros DEFAULT 0,
    acepta_gatos       BIT NOT NULL CONSTRAINT DF_ht_gatos DEFAULT 0,
    CONSTRAINT PK_hogar_transito PRIMARY KEY (id_hogar_transito),
    CONSTRAINT UQ_hogar_transito_dni UNIQUE (dni),
    CONSTRAINT FK_hogar_direccion FOREIGN KEY (id_direccion) REFERENCES dbo.direccion (id_direccion),
    CONSTRAINT CK_hogar_capacidad CHECK (capacidad_aceptada > 0)
);
GO

CREATE TABLE dbo.historial_medico (
    id_historial_medico INT IDENTITY(1,1) NOT NULL,
    id_animal           INT NOT NULL,
    fecha               DATE NOT NULL CONSTRAINT DF_hm_fecha DEFAULT CAST(GETDATE() AS DATE),
    tipo_intervencion   VARCHAR(100) NOT NULL,
    diagnostico         VARCHAR(150) NULL,
    medicamento         VARCHAR(150) NULL,
    nombre_veterinaria  VARCHAR(100) NULL,
    tipo_vacuna         VARCHAR(100) NULL,
    fecha_vencimiento   DATE NULL,
    observacion         VARCHAR(200) NULL,
    CONSTRAINT PK_historial_medico PRIMARY KEY (id_historial_medico),
    CONSTRAINT FK_historial_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT CK_historial_vacuna CHECK (fecha_vencimiento IS NULL OR tipo_vacuna IS NOT NULL)
);
GO

CREATE TABLE dbo.ubicacion_animal (
    id_ubicacion_animal INT IDENTITY(1,1) NOT NULL,
    id_animal           INT NOT NULL,
    id_refugio          INT NOT NULL,
    fecha_ingreso       DATE NOT NULL CONSTRAINT DF_ua_fecha DEFAULT CAST(GETDATE() AS DATE),
    fecha_salida        DATE NULL,
    motivo_traslado     VARCHAR(150) NULL,
    es_actual           BIT NOT NULL CONSTRAINT DF_ua_actual DEFAULT 1,
    CONSTRAINT PK_ubicacion_animal PRIMARY KEY (id_ubicacion_animal),
    CONSTRAINT FK_ubicacion_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_ubicacion_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_ubicacion_fechas CHECK (fecha_salida IS NULL OR fecha_salida >= fecha_ingreso)
);
GO

CREATE TABLE dbo.transito (
    id_transito         INT IDENTITY(1,1) NOT NULL,
    id_animal           INT NOT NULL,
    id_hogar_transito   INT NOT NULL,
    id_refugio          INT NOT NULL,
    fecha_inicio        DATE NOT NULL CONSTRAINT DF_transito_inicio DEFAULT CAST(GETDATE() AS DATE),
    estado_actual       VARCHAR(25) NOT NULL CONSTRAINT DF_transito_estado DEFAULT 'En tránsito',
    fecha_fin_estimada  DATE NULL,
    fecha_fin_real      DATE NULL,
    observaciones       VARCHAR(200) NULL,
    CONSTRAINT PK_transito PRIMARY KEY (id_transito),
    CONSTRAINT FK_transito_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_transito_hogar FOREIGN KEY (id_hogar_transito) REFERENCES dbo.hogar_transito (id_hogar_transito),
    CONSTRAINT FK_transito_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_transito_fechas CHECK (fecha_fin_real IS NULL OR fecha_fin_real >= fecha_inicio),
    CONSTRAINT CK_transito_estado CHECK (estado_actual IN ('En tránsito', 'Finalizado', 'Cancelado'))
);
GO

CREATE TABLE dbo.adopcion (
    id_adopcion     INT IDENTITY(1,1) NOT NULL,
    id_animal       INT NOT NULL,
    id_adoptante    INT NOT NULL,
    fecha_solicitud DATE NOT NULL CONSTRAINT DF_adopcion_fecha DEFAULT CAST(GETDATE() AS DATE),
    estado_actual   VARCHAR(25) NOT NULL CONSTRAINT DF_adopcion_estado DEFAULT 'Solicitada',
    CONSTRAINT PK_adopcion PRIMARY KEY (id_adopcion),
    CONSTRAINT FK_adopcion_animal FOREIGN KEY (id_animal) REFERENCES dbo.animal (id_animal),
    CONSTRAINT FK_adopcion_adoptante FOREIGN KEY (id_adoptante) REFERENCES dbo.adoptante (id_adoptante),
    CONSTRAINT CK_adopcion_estado CHECK (estado_actual IN ('Solicitada', 'En proceso', 'Aprobada', 'Rechazada', 'Concretada'))
);
GO

CREATE TABLE dbo.etapa_adopcion (
    id_etapa_adopcion INT IDENTITY(1,1) NOT NULL,
    id_adopcion       INT NOT NULL,
    id_refugio        INT NOT NULL,
    estado            VARCHAR(25) NOT NULL,
    fecha_inicio      DATE NOT NULL CONSTRAINT DF_etapa_inicio DEFAULT CAST(GETDATE() AS DATE),
    fecha_fin         DATE NULL,
    observaciones     VARCHAR(200) NULL,
    CONSTRAINT PK_etapa_adopcion PRIMARY KEY (id_etapa_adopcion),
    CONSTRAINT FK_etapa_adopcion FOREIGN KEY (id_adopcion) REFERENCES dbo.adopcion (id_adopcion),
    CONSTRAINT FK_etapa_refugio FOREIGN KEY (id_refugio) REFERENCES dbo.refugio (id_refugio),
    CONSTRAINT CK_etapa_estado CHECK (estado IN ('Solicitada', 'En proceso', 'Aprobada', 'Rechazada', 'Concretada')),
    CONSTRAINT CK_etapa_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);
GO

CREATE INDEX IX_historial_animal ON dbo.historial_medico (id_animal);
CREATE INDEX IX_ubicacion_animal ON dbo.ubicacion_animal (id_animal, es_actual);
CREATE INDEX IX_adopcion_estado ON dbo.adopcion (estado_actual);
CREATE INDEX IX_transito_estado ON dbo.transito (estado_actual);
GO
