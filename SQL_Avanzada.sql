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



CREATE TABLE ALMAC�N 
    (
     IDEntrada NUMERIC (25) NOT NULL , 
     Litros_aceite INTEGER NOT NULL 
    )
GO

ALTER TABLE ALMAC�N ADD CONSTRAINT ALMAC�N_PK PRIMARY KEY CLUSTERED (IDEntrada)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE COMPRADORES 
    (
     NIF VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (25) NOT NULL , 
     Direcci�n VARCHAR (50) NOT NULL , 
     Tel�fono SMALLINT , 
     Correo_Electr�nico VARCHAR (30) 
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
     Tel�fono SMALLINT , 
     Correo_electr�nico VARCHAR (25) , 
     Direcci�n VARCHAR (50) , 
     ALMAC�N_IDEntrada NUMERIC (25) NOT NULL 
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
     Direcci�n VARCHAR (50) NOT NULL , 
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

CREATE TABLE N�MINA 
    (
     ID_Factura SMALLINT NOT NULL , 
     DNI VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (25) NOT NULL , 
     Apellidos VARCHAR (50) NOT NULL , 
     Periodo_Liquidaci�n DATE NOT NULL , 
     N_Seg_Soc SMALLINT NOT NULL , 
     Salario SMALLINT NOT NULL , 
     EMPLEADOS_DNI VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE N�MINA ADD CONSTRAINT N�mina_PK PRIMARY KEY CLUSTERED (ID_Factura)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE PUNTOS_DE_RECOGIDA 
    (
     ID_Punto SMALLINT NOT NULL , 
     Nombre VARCHAR (25) , 
     Tipo_localizaci�n BIT NOT NULL , 
     Direcci�n VARCHAR NOT NULL , 
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
     Direcci�n VARCHAR (75) NOT NULL , 
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
    ADD CONSTRAINT EMPLEADOS_ALMAC�N_FK FOREIGN KEY 
    ( 
     ALMAC�N_IDEntrada
    ) 
    REFERENCES ALMAC�N 
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

ALTER TABLE N�MINA 
    ADD CONSTRAINT N�MINA_EMPLEADOS_FK FOREIGN KEY 
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
   , Direcci�n
   , Tel�fono
   , Correo_Electr�nico )
 AS SELECT
    NIF
   , Nombre
   , Direcci�n
   , Tel�fono
   , Correo_Electr�nico
 FROM 
    COMPRADORES 
GO

CREATE VIEW V_EMPLEADOS ( DNI
   , Nombre
   , Apellidos
   , Puesto
   , Tel�fono
   , Correo_electr�nico
   , Direcci�n )
 AS SELECT
    DNI
   , Nombre
   , Apellidos
   , Puesto
   , Tel�fono
   , Correo_electr�nico
   , Direcci�n
 FROM 
    EMPLEADOS 
GO

CREATE VIEW V_FACTURA ( N_Factura
   , Empresa
   , Fecha
   , Direcci�n
   , Litros_aceite
   , Pago
   , Compradores_NIF )
 AS SELECT
    N_Factura
   , Empresa
   , Fecha
   , Direcci�n
   , Litros_aceite
   , Pago
   , Compradores_NIF
 FROM 
    FACTURA 
GO

CREATE VIEW V_N�MINA ( ID_Factura
   , DNI
   , Nombre
   , Apellidos
   , Periodo_Liquidaci�n
   , N_Seg_Soc
   , Salario
   , Empleados_DNI )
 AS SELECT
    ID_Factura
   , DNI
   , Nombre
   , Apellidos
   , Periodo_Liquidaci�n
   , N_Seg_Soc
   , Salario
   , Empleados_DNI
 FROM 
    N�MINA 
GO

CREATE VIEW V_PUNTOS_DE_RECOGIDA ( ID_Punto
   , Nombre
   , Tipo_localizaci�n
   , Direcci�n
   , Periodo_Recogida )
 AS SELECT
    ID_Punto
   , Nombre
   , Tipo_localizaci�n
   , Direcci�n
   , Periodo_Recogida
 FROM 
    PUNTOS_DE_RECOGIDA 
GO

CREATE VIEW V_RECIBO_ENTREGA ( ID_Recibo
   , Fecha
   , Litros_recogidos
   , NIF
   , Nombre_Empresa
   , Direcci�n
   , Puntos_de_Recogida_ID_Punto )
 AS SELECT
    ID_Recibo
   , Fecha
   , Litros_recogidos
   , NIF
   , Nombre_Empresa
   , Direcci�n
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
	Tel�fono VARCHAR(10),
	Correo_electr�nico VARCHAR(25),
	Direcci�n VARCHAR(50)
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
   ( DNI, Nombre, Apellidos, Puesto, Tel�fono, Correo_electr�nico, Direcci�n )
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

SELECT DNI, Nombre, Apellidos, Puesto, Tel�fono, Correo_electr�nico, Direcci�n
FROM MC.EMPLEADAS;
GO


--Transacciones expl�citas

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

EXEC usp_ImportImage 'MuCo','C:\Im�genes','MuCo.png'
GO

SELECT * FROM Imagenes
GO
