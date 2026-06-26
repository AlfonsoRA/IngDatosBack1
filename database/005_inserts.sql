-- =============================================================================
-- PatitasUnidas V2 — Datos iniciales enriquecidos (10 filas por tabla)
-- Ejecutar DESPUÉS de 004_triggers_vistas
--
-- ESTADO FINAL ESPERADO DE ANIMALES (tras triggers de tránsito + etapas):
--   En refugio (4): Luna, Nina, Simba, Coco
--   En tránsito (3): Milo, Toby, Kira
--   Adoptado   (3): Max, Mora, Rocky
--
-- ADOPCIONES — cubre los 5 estados: Solicitada, En proceso, Aprobada,
--   Rechazada, Concretada
-- TRÁNSITOS — cubre: En tránsito, Finalizado, Cancelado
-- HISTORIAL MÉDICO — vacunas VENCIDA, PRÓXIMA A VENCER y VIGENTE
-- =============================================================================

USE [Patitas Unidas];
GO

INSERT INTO dbo.codigo_postal (nombre_calle, localidad, partido, provincia, altura_desde, altura_hasta, paridad, codigo_postal)
VALUES
('San Martin','Avellaneda','Avellaneda','BUENOS AIRES',1,1000,'AMBOS','1870    '),
('Belgrano','Lanus','Lanus','BUENOS AIRES',1,800,'AMBOS','1824    '),
('Mitre','Quilmes','Quilmes','BUENOS AIRES',1,1200,'AMBOS','1878    '),
('Rivadavia','Lomas','Lomas de Zamora','BUENOS AIRES',1,1500,'AMBOS','1832    '),
('Sarmiento','Banfield','Lomas de Zamora','BUENOS AIRES',1,900,'AMBOS','1828    '),
('Independencia','Wilde','Avellaneda','BUENOS AIRES',1,700,'AMBOS','1875    '),
('Italia','Bernal','Quilmes','BUENOS AIRES',1,1100,'AMBOS','1876    '),
('Colon','Temperley','Lomas de Zamora','BUENOS AIRES',1,600,'AMBOS','1834    '),
('Yrigoyen','Gerli','Avellaneda','BUENOS AIRES',1,950,'AMBOS','1869    '),
('Alsina','Escalada','Lanus','BUENOS AIRES',1,1000,'AMBOS','1826    ');
GO

INSERT INTO dbo.direccion (cpa_id, nombre, altura, localidad, partido, provincia)
VALUES
(1,'San Martin',120,'Avellaneda','Avellaneda','BUENOS AIRES'),
(2,'Belgrano',300,'Lanus','Lanus','BUENOS AIRES'),
(3,'Mitre',450,'Quilmes','Quilmes','BUENOS AIRES'),
(4,'Rivadavia',800,'Lomas','Lomas de Zamora','BUENOS AIRES'),
(5,'Sarmiento',200,'Banfield','Lomas de Zamora','BUENOS AIRES'),
(6,'Independencia',150,'Wilde','Avellaneda','BUENOS AIRES'),
(7,'Italia',600,'Bernal','Quilmes','BUENOS AIRES'),
(8,'Colon',350,'Temperley','Lomas de Zamora','BUENOS AIRES'),
(9,'Yrigoyen',700,'Gerli','Avellaneda','BUENOS AIRES'),
(10,'Alsina',500,'Escalada','Lanus','BUENOS AIRES');
GO

-- Todos arrancan "En refugio"; los triggers fijan el estado real al cargar tránsito y etapas
INSERT INTO dbo.animal (especie, raza, nombre, fecha_nacimiento_estimada, estado, sexo, castrado, fecha_ingreso)
VALUES
('Perro','Labrador','Luna','2022-01-10','En refugio','F',1,'2024-11-01'),
('Perro','Pitbull','Max','2021-06-20','En refugio','M',1,'2024-08-15'),
('Gato','Siames','Milo','2023-03-15','En refugio','M',0,'2025-01-10'),
('Perro','Mestizo','Nina','2022-11-05','En refugio','F',1,'2024-12-20'),
('Gato','Persa','Toby','2023-01-01','En refugio','M',0,'2025-02-05'),
('Perro','Beagle','Simba','2020-12-12','En refugio','M',1,'2024-09-01'),
('Gato','Mestizo','Mora','2021-09-09','En refugio','F',1,'2024-07-22'),
('Perro','Golden','Rocky','2020-07-07','En refugio','M',1,'2024-06-10'),
('Gato','Siamés','Kira','2022-02-02','En refugio','F',1,'2024-10-05'),
('Perro','Bulldog','Coco','2021-05-05','En refugio','M',1,'2025-03-18');
GO

INSERT INTO dbo.refugio (id_direccion, nombre, telefono, email, capacidad, responsable)
VALUES
(1,'Patitas Norte','11111111','norte@patitasunidas.org',20,'Ana Perez'),
(2,'Huellitas','22222222','huellitas@patitasunidas.org',10,'Juan Gomez'),
(3,'Refugio Esperanza','33333333','esperanza@patitasunidas.org',30,'Laura Diaz'),
(4,'Refugio Oeste','44444444','oeste@patitasunidas.org',35,'Carlos Ruiz'),
(5,'Nuevo Hogar','55555555','nuevo@patitasunidas.org',28,'Sofia Lopez'),
(6,'Amigos Peludos','66666666','amigos@patitasunidas.org',25,'Martin Diaz'),
(7,'Casa Animal','77777777','casa@patitasunidas.org',12,'Lucia Torres'),
(8,'Patitas Sur','88888888','sur@patitasunidas.org',15,'Diego Fernandez'),
(9,'Refugio San Martin','99999999','sanmartin@patitasunidas.org',18,'Elena Garcia'),
(10,'Patitas Felices','00000000','felices@patitasunidas.org',22,'Pablo Silva');
GO

-- adoptante_previo: 5 con historial previo, 5 primerizos
INSERT INTO dbo.adoptante (id_direccion, dni, nombre, apellido, telefono, email, adoptante_previo)
VALUES
(1,'40100111','Mario','Lopez','1111111111','mario@gmail.com',1),
(2,'40200222','Ana','Gomez','2222222222','ana@gmail.com',0),
(3,'40300333','Luis','Perez','3333333333','luis@gmail.com',0),
(4,'40400444','Sofia','Martinez','4444444444','sofia@gmail.com',1),
(5,'40500555','Diego','Ruiz','5555555555','diego@gmail.com',0),
(6,'40600666','Laura','Diaz','6666666666','laura@gmail.com',0),
(7,'40700777','Pedro','Sosa','7777777777','pedro@gmail.com',1),
(8,'40800888','Valeria','Acosta','8888888888','valeria@gmail.com',0),
(9,'40900999','Javier','Mendez','9999999999','javier@gmail.com',0),
(10,'41001010','Camila','Fernandez','1010101010','camila@gmail.com',1);
GO

-- Hogares: perros solo, gatos solo, ambos; capacidades distintas
INSERT INTO dbo.hogar_transito (id_direccion, dni, nombre, apellido, telefono, email, capacidad_aceptada, acepta_perros, acepta_gatos)
VALUES
(1,'5001','Rosa','Lopez','111','rosa@gmail.com',2,1,1),
(2,'5002','Carlos','Perez','222','carlos@gmail.com',1,1,0),
(3,'5003','Ana','Diaz','333','ana2@gmail.com',3,1,1),
(4,'5004','Jose','Ruiz','444','jose@gmail.com',2,1,1),
(5,'5005','Marta','Sosa','555','marta@gmail.com',1,0,1),
(6,'5006','Luis','Gomez','666','luis2@gmail.com',2,1,1),
(7,'5007','Elena','Torres','777','elena@gmail.com',1,1,0),
(8,'5008','Pedro','Lopez','888','pedro2@gmail.com',2,1,1),
(9,'5009','Lucia','Fernandez','999','lucia@gmail.com',3,1,1),
(10,'5010','Martin','Acosta','101','martin@gmail.com',2,1,1);
GO

-- Historial médico enriquecido: VENCIDA / PRÓXIMA A VENCER / VIGENTE / controles / castración
INSERT INTO dbo.historial_medico (id_animal, fecha, tipo_intervencion, diagnostico, medicamento, nombre_veterinaria, tipo_vacuna, fecha_vencimiento, observacion)
VALUES
-- Luna (1): vacuna vencida + control reciente
(1,'2024-06-01','Vacunacion','OK','Vacuna antirrabica','Vet Norte','Antirrabica','2025-05-01','Refuerzo anual vencido'),
(1,'2026-05-20','Control','Sano',NULL,'Vet Norte',NULL,NULL,'Pendiente nueva vacuna'),
-- Max (2): adoptado, historial completo
(2,'2025-01-10','Vacunacion','OK',NULL,'Vet Sur','Sextuple','2027-01-10','Vigente'),
(2,'2025-08-01','Castracion','OK',NULL,'Vet Sur',NULL,NULL,'Postoperatorio normal'),
-- Milo (3): en tránsito, vacuna próxima a vencer
(3,'2025-09-01','Vacunacion','OK',NULL,'Vet Centro','Triple felina','2026-07-05','Proxima a vencer'),
(3,'2026-04-01','Control','Resfrio','Antibiotico 7 dias','Vet Centro',NULL,NULL,'Recuperado en hogar transito'),
-- Nina (4): adopción rechazada, vacuna vigente
(4,'2025-11-01','Vacunacion','OK',NULL,'Vet Norte','Antirrabica','2027-11-01','Vigente'),
(4,'2026-02-15','Control','Sano',NULL,'Vet Norte',NULL,NULL,'Lista para nueva solicitud'),
-- Toby (5): en tránsito, sin vacunas
(5,'2026-03-10','Control','Herida leve','Antiseptico','Vet Oeste',NULL,NULL,'Curacion en transito'),
-- Simba (6): en proceso de adopción
(6,'2025-04-10','Vacunacion','OK',NULL,'Vet Sur','Sextuple','2026-04-10','Vencida'),
(6,'2026-05-01','Control','Sano',NULL,'Vet Sur',NULL,NULL,'Requiere revacunacion'),
-- Mora (7): adoptada
(7,'2024-12-01','Vacunacion','OK',NULL,'Vet Norte','Antirrabica','2026-12-01','Vigente'),
(7,'2025-06-01','Castracion','OK',NULL,'Vet Norte',NULL,NULL,'Esterilizada'),
-- Rocky (8): adoptado
(8,'2025-02-15','Vacunacion','OK',NULL,'Vet Centro','Antirrabica','2027-02-15','Vigente'),
(8,'2025-10-01','Control','Displasia leve','Antiinflamatorio','Vet Centro',NULL,NULL,'Seguimiento mensual'),
-- Kira (9): en tránsito + adopción aprobada
(9,'2025-08-15','Vacunacion','OK',NULL,'Vet Oeste','Triple felina','2026-08-15','Proxima a vencer'),
(9,'2026-05-28','Control','Sano',NULL,'Vet Oeste',NULL,NULL,'Pre-adopcion'),
-- Coco (10): en proceso
(10,'2025-12-01','Vacunacion','OK',NULL,'Vet Sur','Sextuple','2027-12-01','Vigente'),
(10,'2026-06-01','Control','Sano',NULL,'Vet Sur',NULL,NULL,'Entrevista adoptante pendiente');
GO

-- Ubicaciones: historial de traslados + ocupación variada (Huellitas 2/10)
INSERT INTO dbo.ubicacion_animal (id_animal, id_refugio, fecha_ingreso, fecha_salida, motivo_traslado, es_actual)
VALUES
-- Luna: ingreso y queda en Patitas Norte
(1,1,'2024-11-01',NULL,'Ingreso rescatado',1),
-- Max: pasó por 2 refugios, queda en Huellitas (adoptado)
(2,3,'2024-08-15','2024-10-01','Ingreso',0),
(2,2,'2024-10-02',NULL,'Traslado por cupo',1),
-- Milo: en Refugio Esperanza (en tránsito ahora)
(3,3,'2025-01-10',NULL,'Ingreso',1),
-- Nina: traslado entre refugios, queda en Oeste
(4,1,'2024-12-20','2025-03-01','Ingreso',0),
(4,4,'2025-03-02',NULL,'Traslado por adopcion fallida',1),
-- Toby: Nuevo Hogar (en tránsito)
(5,5,'2025-02-05',NULL,'Ingreso',1),
-- Simba: Huellitas (alta ocupación del refugio)
(6,2,'2024-09-01',NULL,'Ingreso',1),
-- Mora: adoptada, quedó registrada en Patitas Sur
(7,7,'2024-07-22','2025-05-01','Ingreso',0),
(7,8,'2025-05-02',NULL,'Reubicacion pre-adopcion',1),
-- Rocky: adoptado desde San Martin
(8,9,'2024-06-10',NULL,'Ingreso',1),
-- Kira: traslado a Esperanza
(9,10,'2024-10-05','2025-06-01','Ingreso',0),
(9,3,'2025-06-02',NULL,'Traslado por campaña adopcion',1),
-- Coco: Amigos Peludos + otros en Huellitas para ocupación
(10,6,'2025-03-18',NULL,'Ingreso',1);
GO

-- Tránsitos: 3 activos, 4 finalizados, 3 cancelados
INSERT INTO dbo.transito (id_animal, id_hogar_transito, id_refugio, fecha_inicio, estado_actual, fecha_fin_estimada, fecha_fin_real, observaciones)
VALUES
-- ACTIVOS (trigger → En tránsito)
(3,1,3,'2026-05-15','En tránsito','2026-07-15',NULL,'Gato joven en hogar Rosa Lopez'),
(5,5,5,'2026-05-01','En tránsito','2026-06-30',NULL,'Recuperacion post-herida'),
(9,9,3,'2026-04-20','En tránsito','2026-06-20',NULL,'Pre-adopcion en hogar Lucia'),
-- FINALIZADOS (trigger → En refugio)
(2,2,2,'2025-11-01','Finalizado','2025-12-01','2025-11-25','Post-cirugia castracion'),
(4,4,4,'2025-08-01','Finalizado','2025-09-01','2025-08-28','Socializacion previa a adopcion'),
(6,6,2,'2026-01-15','Finalizado','2026-02-15','2026-02-10','Cuarentena sanitaria'),
(7,7,8,'2025-09-01','Finalizado','2025-10-01','2025-09-20','Cuidado post-operatorio'),
-- CANCELADOS (trigger → En refugio)
(1,3,1,'2026-03-01','Cancelado','2026-04-01','2026-03-05','Hogar no pudo continuar'),
(8,8,9,'2025-12-01','Cancelado','2026-01-01','2025-12-08','Animal regreso antes de lo previsto'),
(10,10,6,'2026-02-01','Cancelado','2026-03-01','2026-02-12','Fin anticipado sin inconvenientes');
GO

-- Adopciones: las 5 variantes de estado_actual
INSERT INTO dbo.adopcion (id_animal, id_adoptante, fecha_solicitud, estado_actual)
VALUES
(1,1,'2026-05-01','Solicitada'),          -- Luna: recién iniciada
(2,2,'2025-12-10','Concretada'),           -- Max: adoptado
(3,3,'2026-03-15','Aprobada'),             -- Milo: aprobada + en tránsito
(4,4,'2026-01-08','Rechazada'),            -- Nina: rechazada
(5,5,'2026-06-01','Solicitada'),           -- Toby: solicitada + en tránsito
(6,6,'2026-04-05','En proceso'),           -- Simba: en evaluación
(7,7,'2025-10-20','Concretada'),           -- Mora: adoptada
(8,8,'2026-02-14','Concretada'),           -- Rocky: adoptado
(9,9,'2026-04-01','Aprobada'),             -- Kira: aprobada + en tránsito
(10,10,'2026-05-20','En proceso');          -- Coco: en evaluación
GO

-- Etapas de adopción (trigger Concretada/Rechazada actualiza animal y adopción)
INSERT INTO dbo.etapa_adopcion (id_adopcion, id_refugio, estado, fecha_inicio, fecha_fin, observaciones)
VALUES
-- Adopción 1 Luna — Solicitada (sin cierre)
(1,1,'Solicitada','2026-05-01',NULL,'Formulario recibido, pendiente revision'),
-- Adopción 2 Max — Concretada → Adoptado
(2,2,'Solicitada','2025-12-10','2025-12-12','Primera consulta'),
(2,2,'En proceso','2025-12-13','2026-01-05','Visita domiciliaria OK'),
(2,2,'Aprobada','2026-01-06','2026-01-15','Documentacion completa'),
(2,2,'Concretada','2026-01-16',NULL,'Adopcion exitosa Max'),
-- Adopción 3 Milo — Aprobada (activa)
(3,3,'Solicitada','2026-03-15','2026-03-18','Solicitud recibida'),
(3,3,'En proceso','2026-03-19','2026-04-10','Entrevista y referencias'),
(3,3,'Aprobada','2026-04-11',NULL,'Esperando fin de transito'),
-- Adopción 4 Nina — Rechazada → vuelve En refugio
(4,4,'Solicitada','2026-01-08','2026-01-10','Inicio'),
(4,4,'En proceso','2026-01-11','2026-01-20','Evaluacion domicilio'),
(4,4,'Rechazada','2026-01-21',NULL,'Espacio insuficiente en vivienda'),
-- Adopción 5 Toby — Solicitada (activa, en tránsito)
(5,5,'Solicitada','2026-06-01',NULL,'Solicitud mientras esta en hogar transito'),
-- Adopción 6 Simba — En proceso
(6,2,'Solicitada','2026-04-05','2026-04-07','Recibida'),
(6,2,'En proceso','2026-04-08',NULL,'Segunda entrevista programada'),
-- Adopción 7 Mora — Concretada → Adoptado
(7,8,'Solicitada','2025-10-20','2025-10-25','Inicio'),
(7,8,'En proceso','2025-10-26','2025-11-10','Evaluacion'),
(7,8,'Concretada','2025-11-11',NULL,'Adopcion finalizada Mora'),
-- Adopción 8 Rocky — Concretada → Adoptado
(8,9,'Solicitada','2026-02-14','2026-02-16','Solicitud'),
(8,9,'En proceso','2026-02-17','2026-03-01','Visitas'),
(8,9,'Concretada','2026-03-02',NULL,'Rocky adoptado'),
-- Adopción 9 Kira — Aprobada (activa, en tránsito)
(9,3,'Solicitada','2026-04-01','2026-04-03','Inicio'),
(9,3,'En proceso','2026-04-04','2026-05-15','Evaluacion completa'),
(9,3,'Aprobada','2026-05-16',NULL,'Pendiente retiro post-transito'),
-- Adopción 10 Coco — En proceso
(10,6,'Solicitada','2026-05-20','2026-05-22','Recibida'),
(10,6,'En proceso','2026-05-23',NULL,'Documentacion en revision');
GO

-- Verificación rápida (opcional, comentar si no se desea output)
SELECT estado, COUNT(*) AS cantidad FROM dbo.animal GROUP BY estado ORDER BY estado;
SELECT estado_actual, COUNT(*) AS cantidad FROM dbo.adopcion GROUP BY estado_actual ORDER BY estado_actual;
SELECT estado_actual, COUNT(*) AS cantidad FROM dbo.transito GROUP BY estado_actual ORDER BY estado_actual;
GO
