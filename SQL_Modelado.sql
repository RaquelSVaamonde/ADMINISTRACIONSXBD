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



--Filestream

USE master
GO

EXEC sp_configure filestream_access_level, 2;
RECONFIGURE;

DROP DATABASE IF EXISTS ImagenesMC;
GO

CREATE DATABASE ImagenesMC
ON
PRIMARY ( NAME = Arch1,
    FILENAME = 'C:\ImagenesMC_FILESTREAM\archdat1.mdf'),
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM ( NAME = Arch3,
    FILENAME = 'C:\ImagenesMC_FILESTREAM\filestream1')
LOG ON  ( NAME = Archlog1,
    FILENAME = 'C:\ImagenesMC_FILESTREAM\archlog1.ldf')
GO

USE ImagenesMC;
GO

ALTER DATABASE ImagenesMC
	ADD FILEGROUP [ImagenesMC_FILESTREAM]
	CONTAINS FILESTREAM
GO

DROP TABLE IF EXISTS Imagen_MuCo
GO

CREATE TABLE Imagen_MuCo
	(
	ID UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	imageFile VARBINARY (MAX) FILESTREAM
	);
GO

INSERT INTO Imagen_MuCo (id,imageFile)
SELECT NEWID(), BulkColumn
FROM OPENROWSET(BULK N'C:\ImagenesMC_FILESTREAM\MuCO.png', SINGLE_BLOB) AS f;
GO

SELECT *
FROM Imagen_MuCo;
GO



--Particiones

CREATE PARTITION FUNCTION myRangePF1 (datetime2(0))
    AS RANGE RIGHT FOR VALUES ('2024-04-01', '2024-05-01', '2024-06-01') ;
GO

CREATE PARTITION SCHEME myRangePS1
    AS PARTITION myRangePF1
    ALL TO ('PRIMARY') ;
GO

CREATE TABLE dbo.PartitionTable (col1 datetime2(0) PRIMARY KEY, col2 char(10))
    ON myRangePS1 (col1) ;
GO



--Tablas temporales del sistema

CREATE SCHEMA HistorialPR;
GO

ALTER TABLE PUNTOS_DE_RECOGIDA ADD
ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
    CONSTRAINT DF_PUNTOS_DE_RECOGIDA_ValidFrom DEFAULT SYSUTCDATETIME(),
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
    CONSTRAINT DF_PUNTOS_DE_RECOGIDA_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME(ValidFrom, ValidTo);
GO

ALTER TABLE PUNTOS_DE_RECOGIDA
    SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = HistorialPR.PUNTOS_DE_RECOGIDA));
GO

DROP TABLE IF EXISTS RecursosHumanos
GO

CREATE TABLE RecursosHumanos
(
	ID_Punto SMALLINT NOT NULL PRIMARY KEY, 
    Nombre VARCHAR (25), 
    Tipo_localización BIT NOT NULL, 
    Dirección VARCHAR NOT NULL, 
    Periodo_Recogida VARCHAR (15) NOT NULL,
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PUNTOS_DE_RECOGIDA));
GO



--Tablas in memory

USE master
GO 

ALTER DATABASE MulleresColleiteiras
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;
GO

ALTER DATABASE MulleresColleiteiras
ADD FILEGROUP EasyTutorials_MOD CONTAINS MEMORY_OPTIMIZED_DATA;
GO

ALTER DATABASE MulleresColleiteiras
ADD FILE (name = 'EjercicioMemo', filename = 'C:\EjercicioMemo') 
TO FILEGROUP EasyTutorials_MOD
GO

USE MulleresColleiteiras;
GO

CREATE TABLE MiTablaMemo
    (
      ID INTEGER NOT NULL IDENTITY PRIMARY KEY NONCLUSTERED,
      Elemento INTEGER NOT NULL,
      Fecha DATETIME NOT NULL
     )
     WITH
     (MEMORY_OPTIMIZED = ON,
     DURABILITY = SCHEMA_AND_DATA);
GO


