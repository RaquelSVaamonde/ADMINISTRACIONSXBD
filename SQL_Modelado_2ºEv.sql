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



--BLOB sin Filestream

USE master
GO

EXECUTE sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

DROP DATABASE IF EXISTS BLOB_MC;
GO

CREATE DATABASE BLOB_MC;
GO

USE BLOB_MC;
GO

DROP TABLE IF EXISTS DBO.Imagenes;
GO

CREATE TABLE DBO.Imagenes (ID INT IDENTITY,
		Nombre VARCHAR(255),
		Contenido VARBINARY(MAX),
		Extension CHAR(4)
		 )
GO

INSERT INTO DBO.Imagenes (Nombre,Contenido,Extension)
	SELECT 'MuCo', BULKCOLUMN,'PNG'
	FROM OPENROWSET(BULK N'C:\ImagenesMC_FILESTREAM\MuCo.PNG', SINGLE_BLOB) AS DOCUMENT
GO

INSERT INTO DBO.Imagenes (Nombre,Contenido,Extension)
	SELECT 'CoAc', BULKCOLUMN,'JPEG'
	FROM OPENROWSET(BULK N'C:\ImagenesMC_FILESTREAM\CoAc.JPEG', SINGLE_BLOB) AS DOCUMENT
GO

SELECT * FROM DBO.Imagenes; 
GO



--Filestream

USE master
GO

EXEC sp_configure filestream_access_level, 2;
RECONFIGURE;
GO

DROP DATABASE IF EXISTS ImagenesMC;
GO

CREATE DATABASE ImagenesMC;
GO

USE ImagenesMC;
GO

ALTER DATABASE ImagenesMC
	ADD FILEGROUP [ImagenesMC_FILESTREAM]
	CONTAINS FILESTREAM
GO

ALTER DATABASE ImagenesMC
	ADD FILE ( NAME = 'ImagenesMC_FS', 
	FILENAME = 'C:\ImagenesMC_FS') 
	TO FILEGROUP [ImagenesMC_FILESTREAM]
GO

DROP TABLE IF EXISTS DBO.Multimedia
GO

CREATE TABLE DBO.Multimedia
	(
	ID INT IDENTITY,
	ID2 UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	Nombre VARCHAR(255),
	Contenido VARBINARY(MAX) FILESTREAM,
	Extension CHAR(4)
	);
GO

INSERT INTO DBO.Multimedia (ID2,Nombre,Contenido,Extension)
	SELECT NEWID(), 'MuCo', BULKCOLUMN,'PNG'
	FROM OPENROWSET(BULK 'C:\ImagenesMC_FILESTREAM\MuCO.png', 	SINGLE_BLOB) AS Document;
GO

INSERT INTO DBO.Multimedia (ID2,Nombre,Contenido,Extension)
	SELECT NEWID(), 'CoAc', BULKCOLUMN,'JPEG'
	FROM OPENROWSET(BULK 'C:\ImagenesMC_FILESTREAM\CoAc.JPEG', 	SINGLE_BLOB) AS Document;
GO

SELECT *
FROM DBO.Multimedia;
GO



--Filetable

USE master
GO

ALTER DATABASE ImagenesMC
SET FILESTREAM (DIRECTORY_NAME = 'Multimedia')
WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE ImagenesMC
	SET FILESTREAM (NON_TRANSACTED_ACCESS = FULL,
	DIRECTORY_NAME = 'Multimedia')
	WITH ROLLBACK IMMEDIATE
GO

USE ImagenesMC
GO

DROP TABLE IF EXISTS CarpetaMultimedia
GO

CREATE TABLE CarpetaMultimedia AS FileTable
WITH
(
	FileTable_Directory ='CarpetaMultimedia',
	FileTable_Collate_Filename = database_default,
	FILETABLE_STREAMID_UNIQUE_CONSTRAINT_NAME = UQ_stream_id);
GO

SELECT * FROM [dbo].[CarpetaMultimedia]
GO



--Power BI

USE MulleresColleiteiras
GO

DROP TABLE IF EXISTS Logo
GO

CREATE TABLE Logo
(
	LogoId int,
	LogoNombre varchar(255),
	LogoImagen VARBINARY(MAX)
)
GO

INSERT INTO dbo.Logo
(
	LogoId,
	LogoNombre,
	LogoImagen
)
SELECT 1,'MuCo',
	* FROM OPENROWSET
	(BULK 'C:\Imágenes\MuCo.png',SINGLE_BLOB) AS ImageFile
GO

SELECT * FROM Logo
GO



--Particiones

USE master 
go

EXECUTE sp_configure 'xp_cmdshell', 1;
GO

RECONFIGURE;
GO

exec master..xp_cmdshell 'mkdir C:\Particiones\'
GO

xp_cmdshell 'dir C:\P*'
GO

DROP DATABASE IF EXISTS [Colleiteiras_Particiones]
GO

CREATE DATABASE [Colleiteiras_Particiones]
	ON PRIMARY (NAME = 'Colleiteiras_Particiones' ,
		FILENAME = 'C:\Particiones\Colleiteiras_Particiones_Fijo.mdf' ,
		SIZE = 15360KB, MAXSIZE = UNLIMITED, FILEGROWTH = 0)
	LOG ON (NAME = 'Colleiteiras_Particiones_log',
		FILENAME = 'C:\Particiones\Colleiteiras_Particiones_log.lgf' ,
		SIZE = 10176KB, MAXSIZE = 2048GB, FILEGROWTH = 10%)
GO

USE Colleiteiras_Particiones
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILEGROUP [FG_Archivo]
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILEGROUP [FG_2022]
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILEGROUP [FG_2023]
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILEGROUP [FG_2024]
GO

SELECT * FROM sys.filegroups
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILE ( NAME = 'Recogidas_Archivo', FILENAME = 'C:\Particiones\Recogidas_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo] 
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILE ( NAME = 'Recogidas_2022', FILENAME = 'C:\Particiones\Recogidas_2022.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2022] 
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILE ( NAME = 'Recogidas_2023', FILENAME = 'C:\Particiones\Recogidas_2023.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2023] 
GO

ALTER DATABASE [Colleiteiras_Particiones] ADD FILE ( NAME = 'Recogidas_2024', FILENAME = 'C:\Particiones\Recogidas_2024.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2024] 
GO

SELECT * FROM sys.filegroups
GO

SELECT * FROM sys.database_files
GO

SELECT file_id, name, physical_name FROM sys.database_files
GO

CREATE PARTITION FUNCTION FN_Recogidas_fecha (datetime)
AS RANGE RIGHT FOR VALUES ('2022-01-01','2023-01-01')
GO

CREATE PARTITION SCHEME Recogidas_fecha
AS PARTITION FN_Recogidas_fecha TO (FG_Archivo,FG_2022,FG_2023,FG_2024)
GO

DROP TABLE IF EXISTS Recogida_Aceite
GO

CREATE TABLE Recogida_Aceite
	(id_recogida int identity (1,1),
	lugar varchar(25),
	litros nchar (10),
	fecha_recogida datetime)
	ON Recogidas_fecha
		(fecha_recogida)
GO

INSERT INTO Recogida_Aceite
	VALUES ('Orzán 91', '150', '2021-01-01'),
		   ('Socorro 25', '225', '2021-06-04'),
		   ('Torreiro 11', '284', '2021-09-06')
GO

SELECT *,$Partition.FN_Recogidas_fecha(fecha_recogida) AS Partition
FROM Recogida_Aceite
GO

SELECT NAME, create_date, VALUE FROM sys.partition_functions f 
INNER JOIN sys.partition_range_values rv 
ON f.function_id=rv.function_id 
WHERE f.NAME = 'FN_Recogidas_fecha'
GO

SELECT p.partition_number, p.rows FROM sys.partitions p 
INNER JOIN sys.tables t 
ON p.object_id=t.object_id AND t.name = 'Recogida_Aceite' 
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

INSERT INTO Recogida_Aceite
	VALUES ('Orzán 91', '150', '2022-05-01'),
		   ('Socorro 25', '225', '2022-08-04'),
		   ('Torreiro 11', '284', '2022-11-06')
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

INSERT INTO Recogida_Aceite
	VALUES ('Orzán 91', '150', '2023-05-15'),
		   ('Socorro 25', '225', '2023-08-23'),
		   ('Torreiro 11', '284', '2023-11-18')
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

INSERT INTO Recogida_Aceite
	VALUES ('Orzán 91', '170', '2024-02-15'),
		   ('Socorro 25', '205', '2024-06-23'),
		   ('Torreiro 11', '184', '2024-10-18')
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--SPLIT

ALTER PARTITION FUNCTION FN_Recogidas_fecha()
	SPLIT RANGE ('2024-01-01');
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--MERGE

ALTER PARTITION FUNCTION FN_Recogidas_fecha()
	MERGE RANGE ('2022-01-01');
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--SWITCH

USE master
GO

ALTER DATABASE [Colleiteiras_Particiones] REMOVE FILE Recogidas_2022
GO

ALTER DATABASE [Colleiteiras_Particiones] REMOVE FILEGROUP FG_2022
GO

SELECT * FROM sys.filegroups
GO

SELECT * FROM sys.database_files
GO

USE Colleiteiras_Particiones
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

DROP TABLE IF EXISTS Archivo_Recogidas
GO

CREATE TABLE Archivo_Recogidas
	(id_recogida int identity (1,1),
	lugar varchar(25),
	litros nchar (10),
	fecha_recogida datetime)
	ON FG_Archivo
GO

ALTER TABLE Recogida_Aceite
	SWITCH Partition 1 to Archivo_Recogidas
GO

SELECT * FROM Recogida_Aceite
GO

SELECT * FROM Archivo_Recogidas
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--TRUNCATE


TRUNCATE TABLE Recogida_Aceite
	WITH (PARTITIONS (3));
GO

SELECT * FROM Recogida_Aceite
GO

DECLARE @TableName NVARCHAR(200) = N'Recogida_Aceite' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO



--Tablas temporales del sistema

USE MulleresColleiteiras
GO

DROP TABLE IF EXISTS Recursos_Humanos
GO

CREATE TABLE Recursos_Humanos
	(Num_empleado int IDENTITY (1,1) PRIMARY KEY,
	 DNI VARCHAR (10) NOT NULL,
     Nombre VARCHAR (25) NOT NULL,
     Puesto VARCHAR (25) NOT NULL,
	 ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	 ValidTo DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	 PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo))
	 WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Recursos_Humanos_HISTÓRICO)
	 )
GO

SELECT * FROM [dbo].[Recursos_Humanos]
GO

SELECT * FROM [dbo].[Recursos_Humanos_HISTÓRICO]
GO

INSERT INTO Recursos_Humanos (DNI, Nombre, Puesto)
VALUES ('11223344A','Claudia','Conductora'), 
	('11123344B','Matilde','Conductora'),
	('11222344C','Cristina','Conductora'),
	('11223334D','Inés','Conductora'),
	('12233444E','Beatriz','Conductora')
GO

SELECT * FROM [dbo].[Recursos_Humanos]
GO

SELECT * FROM [dbo].[Recursos_Humanos_HISTÓRICO]
GO

UPDATE Recursos_Humanos
	SET Puesto = 'Moza de almacén'
	WHERE Num_empleado = '1'
GO

SELECT * FROM [dbo].[Recursos_Humanos]
GO

SELECT * FROM [dbo].[Recursos_Humanos_HISTÓRICO]
GO

DELETE FROM Recursos_Humanos
		WHERE Num_empleado = '5'
GO

SELECT * FROM [dbo].[Recursos_Humanos]
GO

SELECT * FROM [dbo].[Recursos_Humanos_HISTÓRICO]
GO

SELECT * FROM Recursos_Humanos
FOR SYSTEM_TIME ALL
GO

SELECT * FROM Recursos_Humanos
FOR SYSTEM_TIME AS OF '2025-03-20 19:54:47'
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

DROP TABLE IF EXISTS MiTablaMemo
GO 

CREATE TABLE MiTablaMemo
    (
      ID INTEGER NOT NULL IDENTITY PRIMARY KEY NONCLUSTERED,
      Elemento INTEGER DEFAULT 13,
      Fecha DATE DEFAULT GETDATE() NOT NULL
     )
     WITH
     (MEMORY_OPTIMIZED = ON,
     DURABILITY = SCHEMA_AND_DATA);
GO

INSERT MiTablaMemo
VALUES (DEFAULT,DEFAULT)
GO 500

SELECT * FROM MiTablaMemo 
GO

SELECT * FROM MiTablaMemo WHERE ID=1
GO

SELECT * FROM MiTablaMemo WHERE Elemento = 13
GO
