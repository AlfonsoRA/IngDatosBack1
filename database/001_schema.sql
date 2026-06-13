-- PatitasUnidas - Sprint 1: refugio + animal
-- Servidor: RICARDO\SQLEXPRESS02
-- Base: Patitas Unidas

USE [Patitas Unidas];
GO

IF OBJECT_ID(N'dbo.animal', N'U') IS NOT NULL
    DROP TABLE dbo.animal;
IF OBJECT_ID(N'dbo.refugio', N'U') IS NOT NULL
    DROP TABLE dbo.refugio;
GO

CREATE TABLE dbo.refugio (
    id               BIGINT IDENTITY(1,1) NOT NULL,
    nombre           NVARCHAR(120)        NOT NULL,
    domicilio        NVARCHAR(200)        NOT NULL,
    capacidad_maxima INT                  NOT NULL,
    responsable      NVARCHAR(100)        NOT NULL,
    CONSTRAINT PK_refugio PRIMARY KEY (id),
    CONSTRAINT CK_refugio_capacidad CHECK (capacidad_maxima >= 1)
);
GO

CREATE TABLE dbo.animal (
    id             BIGINT IDENTITY(1,1) NOT NULL,
    nombre         NVARCHAR(120)        NOT NULL,
    especie        NVARCHAR(50)         NOT NULL,
    raza           NVARCHAR(80)         NULL,
    sexo           NVARCHAR(10)         NOT NULL,
    fecha_ingreso  DATE                 NOT NULL,
    estado         NVARCHAR(30)         NOT NULL,
    refugio_id     BIGINT               NOT NULL,
    CONSTRAINT PK_animal PRIMARY KEY (id),
    CONSTRAINT FK_animal_refugio FOREIGN KEY (refugio_id)
        REFERENCES dbo.refugio (id),
    CONSTRAINT CK_animal_sexo CHECK (sexo IN ('MACHO', 'HEMBRA')),
    CONSTRAINT CK_animal_estado CHECK (estado IN (
        'EN_RESCUARDO',
        'EN_PROCESO_ADOPCION',
        'ADOPTADO',
        'FALLECIDO'
    ))
);
GO

CREATE INDEX IX_animal_refugio_id ON dbo.animal (refugio_id);
CREATE INDEX IX_animal_estado ON dbo.animal (estado);
GO

SET IDENTITY_INSERT dbo.refugio ON;

INSERT INTO dbo.refugio (id, nombre, domicilio, capacidad_maxima, responsable) VALUES
(1, N'Patitas Norte',  N'Av. del Libertador 4500, Vicente López', 80, N'María González'),
(2, N'Patitas Sur',    N'Calle 14 y 65, La Plata',                 60, N'Juan Pérez'),
(3, N'Patitas Oeste',  N'Ruta 8 km 32, Morón',                     70, N'Ana Rodríguez'),
(4, N'Patitas Centro', N'Av. Corrientes 3200, CABA',               50, N'Carlos Méndez');

SET IDENTITY_INSERT dbo.refugio OFF;
GO

SET IDENTITY_INSERT dbo.animal ON;

INSERT INTO dbo.animal (id, nombre, especie, raza, sexo, fecha_ingreso, estado, refugio_id) VALUES
(1, N'Luna',  N'Perro', N'Mestizo',  N'HEMBRA', '2024-03-12', N'EN_RESCUARDO',          1),
(2, N'Rocky', N'Perro', N'Labrador', N'MACHO',  '2024-05-01', N'EN_PROCESO_ADOPCION', 1),
(3, N'Michi', N'Gato',  N'Siames',   N'MACHO',  '2024-01-20', N'EN_RESCUARDO',          2),
(4, N'Nina',  N'Gato',  N'Mestizo',  N'HEMBRA', '2023-11-08', N'ADOPTADO',              2),
(5, N'Toby',  N'Perro', N'Beagle',   N'MACHO',  '2024-06-15', N'EN_RESCUARDO',          3),
(6, N'Cleo',  N'Gato',  N'Persa',    N'HEMBRA', '2024-02-28', N'EN_RESCUARDO',          4);

SET IDENTITY_INSERT dbo.animal OFF;
GO
