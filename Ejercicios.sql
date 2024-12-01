DROP DATABASE IF EXISTS MulleresColleiteiras;
GO

CREATE DATABASE MulleresColleiteiras;
GO

USE MulleresColleiteiras;
GO

-- Generado por Oracle SQL Developer Data Modeler 24.3.0.240.1210
--   en:        2024-11-30 12:17:36 CET
--   sitio:      SQL Server 2012
--   tipo:      SQL Server 2012



CREATE TABLE ALMACÉN 
    (
     IDEntrada NUMERIC (25) NOT NULL , 
     Litros_aceite INTEGER NOT NULL 
    )
GO

ALTER TABLE ALMACÉN ADD CONSTRAINT ALMACÉN_PK PRIMARY KEY CLUSTERED (IDEntrada)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE COMPRADORES 
    (
     NIF VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (25) NOT NULL , 
     Dirección VARCHAR (50) NOT NULL , 
     Teléfono SMALLINT , 
     Correo_Electrónico VARCHAR (30) 
    )
GO

ALTER TABLE COMPRADORES ADD CONSTRAINT Compradores_PK PRIMARY KEY CLUSTERED (NIF)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE EMPLEADOS 
    (
     DNI VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (25) NOT NULL , 
     Apellidos VARCHAR (50) NOT NULL , 
     Puesto VARCHAR (25) NOT NULL , 
     Teléfono SMALLINT , 
     Correo_electrónico VARCHAR (25) , 
     Dirección VARCHAR (50) , 
     ALMACÉN_IDEntrada NUMERIC (25) NOT NULL 
    )
GO

ALTER TABLE EMPLEADOS ADD CONSTRAINT Empleados_PK PRIMARY KEY CLUSTERED (DNI)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE FACTURA 
    (
     N_Factura SMALLINT NOT NULL , 
     Empresa VARCHAR (25) NOT NULL , 
     Fecha DATE NOT NULL , 
     Dirección VARCHAR (50) NOT NULL , 
     Litros_aceite SMALLINT NOT NULL , 
     Pago SMALLINT NOT NULL , 
     COMPRADORES_NIF VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE FACTURA ADD CONSTRAINT Factura_PK PRIMARY KEY CLUSTERED (N_Factura)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE NÓMINA 
    (
     ID_Factura SMALLINT NOT NULL , 
     DNI VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (25) NOT NULL , 
     Apellidos VARCHAR (50) NOT NULL , 
     Periodo_Liquidación DATE NOT NULL , 
     N_Seg_Soc SMALLINT NOT NULL , 
     Salario SMALLINT NOT NULL , 
     EMPLEADOS_DNI VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE NÓMINA ADD CONSTRAINT Nómina_PK PRIMARY KEY CLUSTERED (ID_Factura)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE PUNTOS_DE_RECOGIDA 
    (
     ID_Punto SMALLINT NOT NULL , 
     Nombre VARCHAR (25) , 
     Tipo_localización BIT NOT NULL , 
     Dirección VARCHAR NOT NULL , 
     Periodo_Recogida VARCHAR (15) NOT NULL 
    )
GO

ALTER TABLE PUNTOS_DE_RECOGIDA ADD CONSTRAINT Puntos_de_Recogida_PK PRIMARY KEY CLUSTERED (ID_Punto)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE RECIBO_ENTREGA 
    (
     ID_Recibo SMALLINT NOT NULL , 
     Fecha DATE NOT NULL , 
     Litros_recogidos SMALLINT NOT NULL , 
     NIF VARCHAR (10) NOT NULL , 
     Nombre_Empresa VARCHAR (30) NOT NULL , 
     Dirección VARCHAR (75) NOT NULL , 
     PUNTOS_DE_RECOGIDA_ID_Punto SMALLINT NOT NULL 
    )
GO

ALTER TABLE RECIBO_ENTREGA ADD CONSTRAINT Recibo_Entrega_PK PRIMARY KEY CLUSTERED (ID_Recibo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Recogen 
    (
     Empleados_DNI VARCHAR (10) NOT NULL , 
     Puntos_de_Recogida_ID_Punto SMALLINT NOT NULL 
    )
GO

ALTER TABLE Recogen ADD CONSTRAINT Recogen_PK PRIMARY KEY CLUSTERED (Empleados_DNI, Puntos_de_Recogida_ID_Punto)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Venden 
    (
     Compradores_NIF VARCHAR (10) NOT NULL , 
     Empleados_DNI VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE Venden ADD CONSTRAINT Venden_PK PRIMARY KEY CLUSTERED (Compradores_NIF, Empleados_DNI)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE EMPLEADOS 
    ADD CONSTRAINT EMPLEADOS_ALMACÉN_FK FOREIGN KEY 
    ( 
     ALMACÉN_IDEntrada
    ) 
    REFERENCES ALMACÉN 
    ( 
     IDEntrada 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FACTURA 
    ADD CONSTRAINT FACTURA_COMPRADORES_FK FOREIGN KEY 
    ( 
     COMPRADORES_NIF
    ) 
    REFERENCES COMPRADORES 
    ( 
     NIF 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE NÓMINA 
    ADD CONSTRAINT NÓMINA_EMPLEADOS_FK FOREIGN KEY 
    ( 
     EMPLEADOS_DNI
    ) 
    REFERENCES EMPLEADOS 
    ( 
     DNI 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE RECIBO_ENTREGA 
    ADD CONSTRAINT RECIBO_ENTREGA_PUNTOS_DE_RECOGIDA_FK FOREIGN KEY 
    ( 
     PUNTOS_DE_RECOGIDA_ID_Punto
    ) 
    REFERENCES PUNTOS_DE_RECOGIDA 
    ( 
     ID_Punto 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Recogen 
    ADD CONSTRAINT Recogen_Empleados_FK FOREIGN KEY 
    ( 
     Empleados_DNI
    ) 
    REFERENCES EMPLEADOS 
    ( 
     DNI 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Recogen 
    ADD CONSTRAINT Recogen_Puntos_de_Recogida_FK FOREIGN KEY 
    ( 
     Puntos_de_Recogida_ID_Punto
    ) 
    REFERENCES PUNTOS_DE_RECOGIDA 
    ( 
     ID_Punto 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Venden 
    ADD CONSTRAINT Venden_Compradores_FK FOREIGN KEY 
    ( 
     Compradores_NIF
    ) 
    REFERENCES COMPRADORES 
    ( 
     NIF 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Venden 
    ADD CONSTRAINT Venden_Empleados_FK FOREIGN KEY 
    ( 
     Empleados_DNI
    ) 
    REFERENCES EMPLEADOS 
    ( 
     DNI 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

CREATE VIEW V_COMPRADORES ( NIF
   , Nombre
   , Dirección
   , Teléfono
   , Correo_Electrónico )
 AS SELECT
    NIF
   , Nombre
   , Dirección
   , Teléfono
   , Correo_Electrónico
 FROM 
    COMPRADORES 
GO

CREATE VIEW V_EMPLEADOS ( DNI
   , Nombre
   , Apellidos
   , Puesto
   , Teléfono
   , Correo_electrónico
   , Dirección )
 AS SELECT
    DNI
   , Nombre
   , Apellidos
   , Puesto
   , Teléfono
   , Correo_electrónico
   , Dirección
 FROM 
    EMPLEADOS 
GO

CREATE VIEW V_FACTURA ( N_Factura
   , Empresa
   , Fecha
   , Dirección
   , Litros_aceite
   , Pago
   , Compradores_NIF )
 AS SELECT
    N_Factura
   , Empresa
   , Fecha
   , Dirección
   , Litros_aceite
   , Pago
   , Compradores_NIF
 FROM 
    FACTURA 
GO

CREATE VIEW V_NÓMINA ( ID_Factura
   , DNI
   , Nombre
   , Apellidos
   , Periodo_Liquidación
   , N_Seg_Soc
   , Salario
   , Empleados_DNI )
 AS SELECT
    ID_Factura
   , DNI
   , Nombre
   , Apellidos
   , Periodo_Liquidación
   , N_Seg_Soc
   , Salario
   , Empleados_DNI
 FROM 
    NÓMINA 
GO

CREATE VIEW V_PUNTOS_DE_RECOGIDA ( ID_Punto
   , Nombre
   , Tipo_localización
   , Dirección
   , Periodo_Recogida )
 AS SELECT
    ID_Punto
   , Nombre
   , Tipo_localización
   , Dirección
   , Periodo_Recogida
 FROM 
    PUNTOS_DE_RECOGIDA 
GO

CREATE VIEW V_RECIBO_ENTREGA ( ID_Recibo
   , Fecha
   , Litros_recogidos
   , NIF
   , Nombre_Empresa
   , Dirección
   , Puntos_de_Recogida_ID_Punto )
 AS SELECT
    ID_Recibo
   , Fecha
   , Litros_recogidos
   , NIF
   , Nombre_Empresa
   , Dirección
   , Puntos_de_Recogida_ID_Punto
 FROM 
    RECIBO_ENTREGA 
GO

CREATE VIEW V_Recogen ( Empleados_DNI
   , Puntos_de_Recogida_ID_Punto )
 AS SELECT
    Empleados_DNI
   , Puntos_de_Recogida_ID_Punto
 FROM 
    Recogen 
GO

CREATE VIEW V_Venden ( Compradores_NIF
   , Empleados_DNI )
 AS SELECT
    Compradores_NIF
   , Empleados_DNI
 FROM 
    Venden 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             9
-- CREATE INDEX                             0
-- ALTER TABLE                             17
-- CREATE VIEW                              8
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0






--Cadena de Propiedad:

DROP SCHEMA IF EXISTS MC;
GO

CREATE SCHEMA MC;
GO

DROP TABLE IF EXISTS MC.EMPLEADAS;
GO

CREATE TABLE MC.EMPLEADAS
(
	DNI VARCHAR(10) NOT NULL,
	Nombre VARCHAR(25) NOT NULL,
	Apellidos VARCHAR(50) NOT NULL,
	Puesto VARCHAR(25) NOT NULL,
	Teléfono VARCHAR(10),
	Correo_electrónico VARCHAR(25),
	Dirección VARCHAR(50)
);
GO

SELECT * FROM MC.EMPLEADAS;
GO

DROP VIEW IF EXISTS MC.ConsultarEmpleadas;
GO

CREATE VIEW MC.ConsultarEmpleadas
AS
SELECT
	DNI, Nombre, Apellidos, Puesto
FROM MC.EMPLEADAS;
GO

DROP ROLE IF EXISTS Administradora;
GO

CREATE ROLE Administradora;
GO

GRANT SELECT ON MC.ConsultarEmpleadas TO Administradora;
GO

DROP USER IF EXISTS Julia;
GO

CREATE USER Julia WITHOUT LOGIN;
GO

ALTER ROLE Administradora
ADD MEMBER Julia;
GO

EXECUTE AS USER = 'Julia';
GO

PRINT USER;
GO

SELECT * FROM MC.ConsultarEmpleadas;
GO

REVERT;
GO

PRINT USER;
GO

CREATE OR ALTER PROC MC.RecursosHumanos
	@DNI VARCHAR(10),
	@Nombre VARCHAR(25),
	@Apellidos VARCHAR(50),
	@Puesto VARCHAR(25),
	@Telefono VARCHAR(10),
	@Correo_electronico VARCHAR(25),
	@Direccion VARCHAR(50)
AS
BEGIN
   INSERT INTO MC.EMPLEADAS
   ( DNI, Nombre, Apellidos, Puesto, Teléfono, Correo_electrónico, Dirección )
   VALUES
   ( @DNI, @Nombre, @Apellidos, @Puesto, @Telefono, @Correo_electronico, @Direccion )
END;
GO 

DROP ROLE IF EXISTS Entrevistadora;
GO

CREATE ROLE Entrevistadora;
GO

GRANT EXECUTE ON SCHEMA::[MC] TO Entrevistadora;
GO

DROP USER IF EXISTS Paula;
GO

CREATE USER Paula WITHOUT LOGIN;
GO

ALTER ROLE Entrevistadora
ADD MEMBER Paula;
GO

EXECUTE AS USER = 'Paula';
GO

EXEC MC.RecursosHumanos 
      @DNI = '33344455D', 
      @Nombre = 'Diana', 
      @Apellidos = 'Miramontes', 
      @Puesto = 'Vendedora',
	  @Telefono = '699999999', 
      @Correo_electronico = 'DianaM@correo.com', 
      @Direccion = 'Calle Falsa 7';
GO

PRINT USER;
GO

REVERT;
GO

PRINT USER;
GO

SELECT DNI, Nombre, Apellidos, Puesto, Teléfono, Correo_electrónico, Dirección
FROM MC.EMPLEADAS;
GO


--Transacciones explícitas

DROP TABLE IF EXISTS LitrosTransportados
GO

CREATE TABLE dbo.LitrosTransportados
(
	ID INT NOT NULL,
	cantidad DECIMAL (20, 2) NOT NULL,
	Fecha DATE NOT NULL
);
GO

DROP TABLE IF EXISTS LitrosAlmacenados
GO

CREATE TABLE dbo.LitrosAlmacenados
(
	ID INT NOT NULL,
	Cantidad DECIMAL(20, 2) NOT NULL,
	Fecha DATETIME NOT NULL
);
GO

INSERT INTO dbo.LitrosTransportados
(
	ID,
	cantidad,
	Fecha
)
VALUES
(1, 50.50, GETDATE());
GO

INSERT INTO dbo.LitrosAlmacenados
(
	ID,
	cantidad,
	Fecha
)
VALUES
(1, 1000.00, GETDATE());
GO

SELECT SUM(Cantidad) AS [Total],
	'Transportado' AS [Aceite]
FROM dbo.LitrosTransportados
UNION ALL
SELECT SUM(Cantidad) AS [Total],
	'Almacenado' AS [Aceite]
FROM dbo.LitrosAlmacenados;
GO

SET XACT_ABORT ON;

BEGIN TRANSACTION;

INSERT INTO dbo.LitrosTransportados
(
	ID,
	cantidad,
	Fecha
)
VALUES
(2, -50.50, GETDATE());
GO

INSERT INTO dbo.LitrosAlmacenados
(
	ID,
	cantidad,
	Fecha
)
VALUES
(2, 50.50, GETDATE());
GO

COMMIT TRANSACTION;

SELECT SUM(Cantidad) AS [Total],
	'Transportado' AS [Aceite]
FROM dbo.LitrosTransportados
UNION ALL
SELECT SUM(Cantidad) AS [Total],
	'Almacenado' AS [Aceite]
FROM dbo.LitrosAlmacenados;
GO

--Importar imagen

DROP TABLE IF EXISTS Imagenes
GO

CREATE TABLE Imagenes
(
	PictureName NVARCHAR(40) PRIMARY KEY NOT NULL,
	PicFileName NVARCHAR(100),
	PictureData VARBINARY(max)
);
GO

Use master
go

EXEC sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'Ole Automation Procedures', 1;
GO

RECONFIGURE;
GO

ALTER SERVER ROLE [bulkadmin] ADD MEMBER [RaquelSV\Raquel]
GO

USE MulleresColleiteiras
GO

CREATE OR ALTER PROC usp_ImportImage
(
	@PicName NVARCHAR(100),
	@ImageFolderPath NVARCHAR(1000),
	@Filename NVARCHAR(1000)
)
AS

BEGIN
	DECLARE @Path2OutFile NVARCHAR(2000);
	DECLARE @tsql NVARCHAR(2000);
	SET NOCOUNT ON
	SET @Path2OutFile = CONCAT (
		@ImageFolderPath,
		'\',
		@Filename);
	SET @tsql = 'insert into Imagenes (PictureName, PicFileName, PictureData) ' +
               ' SELECT ' + '''' + @PicName + '''' + ',' + '''' + @Filename + '''' + ', * ' + 
               'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
	EXEC (@tsql)
	SET NOCOUNT OFF
END
GO

EXEC usp_ImportImage 'MuCo','C:\Imágenes','MuCo.png'
GO

SELECT * FROM Imagenes
GO