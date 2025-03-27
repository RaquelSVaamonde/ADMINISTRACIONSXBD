--Encriptar SP

USE AdventureWorks2022
GO

DROP PROCEDURE IF EXISTS Tasa
GO

CREATE PROCEDURE [Tasa]
 @valor NUMERIC = 9.50
WITH ENCRYPTION
AS
 SELECT BusinessEntityID
 FROM HumanResources.EmployeePayHistory
 WHERE EmployeePayHistory.Rate = @valor
GO

EXECUTE [Tasa]
GO

EXECUTE [Tasa] 25.00
GO

SP_HELP [Tasa]
GO

SP_HELPTEXT [Tasa]
GO


--Encriptaci�n de columnas

USE master
GO

CREATE LOGIN JefaConductoras WITH PASSWORD = 'Abcd1234.'
GO

CREATE LOGIN JefaMozasAlmac�n WITH PASSWORD = 'Abcd1234.'
GO

USE MulleresColleiteiras
GO

DROP USER IF EXISTS JefaConductoras
GO

CREATE USER JefaConductoras FOR LOGIN JefaConductoras
GO

DROP USER IF EXISTS JefaMozasAlmac�n
GO

CREATE USER JefaMozasAlmac�n FOR LOGIN JefaMozasAlmac�n
GO

DROP TABLE IF EXISTS dbo.empleadas
go

SELECT DNI,Nombre,Apellidos,Tel�fono INTO dbo.empleadas
	   FROM dbo.EMPLEADOS
GO

ALTER TABLE dbo.empleadas ALTER COLUMN Tel�fono VARBINARY(MAX);
GO

GRANT SELECT, INSERT ON dbo.empleadas TO JefaConductoras;
GRANT SELECT, INSERT ON dbo.empleadas TO JefaMozasAlmac�n;
GO

DROP MASTER KEY
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Abcd1234.'
GO

SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO

CREATE CERTIFICATE JefaConductorasCert AUTHORIZATION JefaConductoras 
WITH subject = 'Abcd1234.' 
GO

CREATE CERTIFICATE JefaMozasAlmac�nCert AUTHORIZATION JefaMozasAlmac�n 
WITH subject = 'Abcd1234.'
GO

SELECT name CertName,
  certificate_id CertID,
  pvt_key_encryption_type_desc EncryptType,
  issuer_name Issuer
FROM sys.certificates;
GO

CREATE SYMMETRIC KEY JefaConductorasKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE JefaConductorasCert 
GO

CREATE SYMMETRIC KEY JefaMozasAlmac�nKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE JefaMozasAlmac�nCert 
GO

SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO

GRANT VIEW DEFINITION ON CERTIFICATE::JefaConductorasCert  TO JefaConductoras
GO

GRANT VIEW DEFINITION ON SYMMETRIC KEY::JefaConductorasKey TO JefaConductoras
GO

GRANT VIEW DEFINITION ON CERTIFICATE::JefaMozasAlmac�nCert  TO JefaMozasAlmac�n
GO

GRANT VIEW DEFINITION ON SYMMETRIC KEY::JefaMozasAlmac�nKey TO JefaMozasAlmac�n
GO

EXECUTE AS USER = 'JefaConductoras'
PRINT USER
GO

OPEN SYMMETRIC KEY JefaConductorasKey
	DECRYPTION BY CERTIFICATE JefaConductorasCert
GO

INSERT INTO dbo.empleadas
VALUES ('11223344A',
		'M�nica',
		'Garc�a Su�rez',
		Encryptbykey(Key_guid('JefaConductorasKey'), '666555444'))
GO

INSERT INTO dbo.empleadas
VALUES ('11123344B',
		'Manuela',
		'Cea Rodriguez',
		Encryptbykey(Key_guid('JefaConductorasKey'), '666777888'))
GO

SELECT * FROM dbo.empleadas
GO

CLOSE ALL SYMMETRIC KEYS
GO

REVERT
GO

EXECUTE AS USER = 'JefaMozasAlmac�n'
PRINT USER
GO

OPEN SYMMETRIC KEY JefaMozasAlmac�nKey
	DECRYPTION BY CERTIFICATE JefaMozasAlmac�nCert
GO

INSERT INTO dbo.empleadas
VALUES ('11222344C',
		'Elena',
		'Casal Ben�tez',
		Encryptbykey(Key_guid('JefaMozasAlmac�nKey'), '666111222'))
GO

INSERT INTO dbo.empleadas
VALUES ('11123334D',
		'Miriam',
		'Pastoriza Rodriguez',
		Encryptbykey(Key_guid('JefaMozasAlmac�nKey'), '666333444'))
GO

SELECT * FROM dbo.empleadas
GO

CLOSE ALL SYMMETRIC KEYS
GO

REVERT
GO

EXECUTE AS USER = 'JefaConductoras'
GO

OPEN SYMMETRIC KEY JefaConductorasKey DECRYPTION BY CERTIFICATE JefaConductorasCert
GO

SELECT DNI,
	   Nombre,
	   Apellidos,
	   CONVERT (VARCHAR, Decryptbykey (Tel�fono)) AS Tel�fono
FROM dbo.empleadas
GO

CLOSE ALL SYMMETRIC KEYS
GO

REVERT
GO

EXECUTE AS USER = 'JefaMozasAlmac�n'
GO

OPEN SYMMETRIC KEY JefaMozasAlmac�nKey DECRYPTION BY CERTIFICATE JefaMozasAlmac�nCert
GO

SELECT DNI,
	   Nombre,
	   Apellidos,
	   CONVERT (VARCHAR, Decryptbykey (Tel�fono)) AS Tel�fono
FROM dbo.empleadas
GO

CLOSE ALL SYMMETRIC KEYS
GO

REVERT
GO

EXECUTE AS USER = 'JefaMozasAlmac�n'
GO

SELECT DNI,
	   Nombre,
	   Apellidos,
	   CONVERT (VARCHAR, Decryptbykey (Tel�fono)) AS Tel�fono
FROM dbo.empleadas
GO

REVERT
GO


--Encriptar columna usando frase
--Primero voy a insertar un dato de n�mina

INSERT INTO dbo.EMPLEADOS
VALUES ('77777788M',
		'Dalia',
		'L�pez Gonz�lez',
		'Conductora',
		'7777',
		'Dalia@gmail.com',
		'C/Invisible,2,1�',
		'25')
GO

INSERT INTO dbo.N�MINA
VALUES ('1',
		'77777788M',
		'Dalia',
		'L�pez Gonz�lez',
		'2025-02-01',
		'15111',
		'1500',
		'77777788M')
GO

DROP TABLE IF EXISTS dbo.salarios
GO

SELECT Nombre, Apellidos, N_Seg_Soc
	INTO dbo.salarios
	FROM dbo.N�MINA
GO

ALTER TABLE dbo.salarios ALTER COLUMN N_Seg_Soc VARBINARY(MAX);
GO

SELECT * FROM dbo.salarios
GO

DECLARE @Passphrase NVARCHAR(128);
SET @Passphrase = 'Estamos en 2025';
GO

UPDATE dbo.salarios
SET N_Seg_Soc = ENCRYPTBYPASSPHRASE('@Passphrase', N_Seg_Soc)
GO

SELECT * FROM dbo.salarios
GO

SELECT Nombre, Apellidos,
	   DECRYPTBYPASSPHRASE('@Passphrase',N_Seg_Soc)
	   AS N_Seg_Soc
FROM dbo.salarios
GO


--Encriptar backup

USE master
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Abcd1234.'
GO

DROP CERTIFICATE [ContenidaAceiteBackupCertificado]
GO

CREATE CERTIFICATE [ContenidaAceiteBackupCertificado]
WITH SUBJECT = 'Certificado ContenidaAceite Encriptada';
GO

BACKUP CERTIFICATE [ContenidaAceiteBackupCertificado]
	TO FILE = 'C:\Backup\Certificados\ContenidaAceiteBackupCertificado.cert'
	WITH PRIVATE KEY (
					 FILE = 'C:\Backup\Certificados\ContenidaAceiteBackupCertificado.key',
					 ENCRYPTION BY PASSWORD = 'Abcd1234.'
					 );
GO

BACKUP DATABASE [Contenida_Aceite]
	TO DISK = 'C:\Backup\ContenidaAceiteEncryp.bak'
	WITH COMPRESSION, ENCRYPTION(ALGORITHM = AES_256,
	SERVER CERTIFICATE = [ContenidaAceiteBackupCertificado]);
GO

DROP DATABASE [Contenida_Aceite]
GO

CREATE CERTIFICATE BackupEncrypCertificado
FROM FILE = 'C:\Backup\Certificados\ContenidaAceiteBackupCertificado.cert'
WITH PRIVATE KEY 
(FILE = 'C:\Backup\Certificados\ContenidaAceiteBackupCertificado.key',
DECRYPTION BY PASSWORD = 'Abcd1234.'
);
GO

RESTORE DATABASE [Contenida_Aceite]
FROM DISK = 'C:\Backup\ContenidaAceiteEncryp.bak'
GO


--Encriptar TDE

USE master
GO

EXECUTE sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

EXECUTE sp_configure 'xp_cmdshell', 1;
GO

RECONFIGURE;
GO

EXEC xp_cmdshell 'rmdir C:\CERTIFICADOS'
GO

EXEC xp_cmdshell 'mkdir C:\CERTIFICADOS'
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'abcd1234.';
GO

CREATE CERTIFICATE TDECertificado
	WITH SUBJECT = 'Certificado TDE prueba';
GO

SELECT TOP 1 *
FROM sys.certificates
ORDER BY name DESC
GO

BACKUP CERTIFICATE TDECertificado
	TO FILE = 'C:\CERTIFICADOS\TDECertificado.cer'
	WITH PRIVATE KEY (
		FILE = 'C:\CERTIFICADOS\TDECertificado_key.pvk',
	ENCRYPTION BY PASSWORD = 'Abcd1234.'
	);
GO

EXEC xp_cmdshell 'DIR C:\CERTIFICADOS'
GO

USE Contenida_Aceite
GO

CREATE DATABASE ENCRYPTION KEY
	WITH ALGORITHM = AES_256
	ENCRYPTION BY SERVER CERTIFICATE TDECertificado;
GO

USE master
GO

ALTER DATABASE Contenida_Aceite SET ENCRYPTION ON;
GO

SELECT DB_NAME(database_id) AS 'Database', encryption_state
FROM sys.dm_database_encryption_keys;
GO

BACKUP DATABASE Contenida_Aceite
TO DISK = 'C:\CERTIFICADOS\Contenida_Aceite_Full.bak';
GO

BACKUP LOG Contenida_Aceite
TO DISK = 'C:\CERTIFICADOS\Contenida_Aceite_LOG.bak'
WITH NORECOVERY
GO

EXEC xp_cmdshell 'DIR C:\CERTIFICADOS'
GO

DROP DATABASE Contenida_Aceite
GO

RESTORE DATABASE Contenida_Aceite
	FROM DISK = 'C:\CERTIFICADOS\Contenida_Aceite_Full.bak'
GO


--Hashing

USE MulleresColleiteiras
GO

INSERT INTO dbo.COMPRADORES (NIF, Nombre, Direcci�n, Tel�fono, Correo_Electr�nico)
VALUES ('99996666L', 'Juan', 'C/Inventada, 3, 2�', '8054', 'Juanchi@gmail.com')
GO

SELECT * FROM dbo.COMPRADORES;
GO

CREATE OR ALTER TRIGGER Hash_Compradores 
ON dbo.COMPRADORES
INSTEAD OF INSERT
AS
DECLARE
    @salt VARCHAR(16), @hash VARCHAR(64),
    @plainPassword VARCHAR(80), @Direcci�nEnc VARCHAR(50),
	@NIF VARCHAR(10), @Nombre VARCHAR(25),
	@Tel�fono VARCHAR(20), @Correo_Electr�nico VARCHAR(30)
    SELECT @Nombre = ins.Nombre 
	FROM INSERTED ins;
BEGIN
	SET @plainPassword = (SELECT Direcci�n FROM inserted)
    SELECT @salt = CONVERT(VARCHAR(16), CRYPT_GEN_RANDOM(8),2)
    SET @hash = CONVERT(VARCHAR(64),HashBytes('SHA2_256', (@salt + @plainPassword)),2)
    SET @Direcci�nEnc = @salt + @hash;
	INSERT INTO dbo.COMPRADORES (NIF, Nombre, Direcci�n, Tel�fono, Correo_Electr�nico)
    VALUES (@NIF, @Nombre, @Direcci�nEnc, @Tel�fono, @Correo_Electr�nico)
END;
GO

INSERT INTO dbo.COMPRADORES (NIF, Nombre, Direcci�n, Tel�fono, Correo_Electr�nico)
VALUES ('77771111K', '�ngel', 'C/Imaginaria, 4, 1�', '1024', '�ngel@gmail.com')
GO

SELECT * FROM dbo.COMPRADORES;
GO

INSERT INTO dbo.empleadas (DNI, Nombre, Apellidos)
VALUES ('54543232P', 'Alba', 'Pareja Castro')
GO

SELECT * FROM dbo.empleadas;
GO

CREATE OR ALTER TRIGGER Hash_empleadas
ON dbo.empleadas
INSTEAD OF INSERT
AS
DECLARE 
    @salt VARCHAR(16),@hash VARCHAR(64),
    @plainPassword VARCHAR(80),@DNI_Enc VARCHAR(MAX),
	@DNI VARCHAR(10), @Nombre VARCHAR(25),@Apellidos VARCHAR(50)
    SELECT @Nombre = ins.Nombre
	FROM INSERTED ins;
BEGIN
    SET @plainPassword = (SELECT DNI FROM inserted)
    SELECT @salt = CONVERT(VARCHAR(16), CRYPT_GEN_RANDOM(8),2)
    SET @hash = CONVERT(VARCHAR(64),HashBytes('SHA2_256', (@salt + @plainPassword)),2)
    SET @DNI_Enc = @salt + @hash;
	INSERT INTO dbo.empleadas (DNI,Nombre,Apellidos)
    VALUES (@DNI_Enc,@Nombre,@Apellidos)
END;
GO

INSERT INTO dbo.empleadas (DNI, Nombre, Apellidos)
VALUES ('71712828R', 'Juana', 'Nito P�rez')
GO

SELECT * FROM dbo.empleadas;
GO


--Always encripted

INSERT INTO MC.EMPLEADAS (DNI, Nombre, Apellidos, Puesto, Tel�fono, Correo_electr�nico, Direcci�n)
VALUES ('12345678Q','Mercedes', 'Pastoriza', 'Repartidora', '777777777', 'Merchi@gmail.com', 'Av.Inexistente, 4, 2�'),
	   ('98765432W','Maricarmen', 'Fern�ndez', 'Moza de almac�n', '888888888', 'Mari@gmail.com', 'Av.Falsa, 8, 5�')
GO

SELECT * FROM MC.EMPLEADAS
GO


--Dynamic Data Masking

DROP TABLE IF EXISTS Datos_Jefas
GO

CREATE TABLE Datos_Jefas (
	ID int IDENTITY PRIMARY KEY,
	Nombre NVARCHAR(100) MASKED WITH (FUNCTION = 'default()') NULL,
	DNI NVARCHAR(20) MASKED WITH (FUNCTION = 'partial(1,"XX.XXX",1)') NULL,
	Email NVARCHAR(100) MASKED WITH (FUNCTION = 'email()') NULL,
	Salario DECIMAL(7,2) MASKED WITH (FUNCTION = 'random(3,6)') NULL,
	Fecha_de_nacimiento DATE MASKED WITH (FUNCTION = 'default()') NULL
);
GO

INSERT INTO Datos_Jefas (Nombre, DNI, Email, Salario, Fecha_de_nacimiento)
VALUES ('Carol', '85285285H', 'Carol@gmail.com', '2.500', '1985-06-14');
GO

DROP USER IF EXISTS UsuarioCom�n
GO

CREATE USER UsuarioCom�n WITHOUT LOGIN;
GO

GRANT SELECT ON Datos_Jefas TO UsuarioCom�n;
GO

EXECUTE AS USER = 'UsuarioCom�n'
GO

SELECT * FROM Datos_Jefas;
GO

REVERT
GO

DROP USER IF EXISTS UsuarioPrivilegiado
GO

CREATE USER UsuarioPrivilegiado WITHOUT LOGIN;
GO

GRANT UNMASK TO UsuarioPrivilegiado
GO

SELECT * FROM Datos_Jefas;
GO


--Row Level Security

DROP TABLE IF EXISTS dbo.Departamentos
GO

CREATE TABLE dbo.Departamentos
(
	IDEmpleada INT IDENTITY (1,1),
	Nombre NVARCHAR (25),
	Apellido NVARCHAR (50),
	Departamento SYSNAME
)
GO

INSERT INTO dbo.Departamentos (Nombre, Apellido, Departamento)
VALUES ('Victoria', 'Miramontes', 'Conductoras'),
	   ('Maribel', 'Moreno', 'Conductoras'),
	   ('Gabriela', 'Garc�a', 'Mozas'),
	   ('Elena', 'Mart�nez', 'Mozas')
GO

SELECT * FROM dbo.Departamentos
GO

CREATE USER Conductoras WITHOUT LOGIN
GO

CREATE USER Mozas WITHOUT LOGIN
GO

CREATE USER Administrador WITHOUT LOGIN
GO

GRANT SELECT,INSERT,UPDATE,DELETE ON Departamentos TO Conductoras
GRANT SELECT,INSERT,UPDATE,DELETE ON Departamentos TO Mozas
GRANT SELECT,INSERT,UPDATE,DELETE ON Departamentos TO Administrador
GO

DROP FUNCTION IF EXISTS dbo.FuncionDepartamentos
GO

CREATE OR ALTER FUNCTION dbo.FuncionDepartamentos
	(@Departamentos AS SYSNAME)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN  SELECT 1 AS AccessRight
    WHERE @Departamentos = USER_NAME() 
		OR USER_NAME() = 'Administrador'
GO

DROP SECURITY POLICY IF EXISTS Pol�ticaSeguridadDepartamentos
GO

CREATE SECURITY POLICY Pol�ticaSeguridadDepartamentos
ADD BLOCK PREDICATE dbo.FuncionDepartamentos(Departamento)
	ON dbo.Departamentos AFTER INSERT
WITH (STATE = ON)
GO

EXECUTE AS USER = 'Conductoras'
GO

SELECT * FROM dbo.Departamentos
GO

INSERT INTO dbo.Departamentos (Nombre, Apellido, Departamento)
VALUES ('Nuria', 'Romero', 'Mozas')
GO

INSERT INTO dbo.Departamentos (Nombre, Apellido, Departamento)
VALUES ('Henar', 'Mart�n', 'Conductoras')
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

EXECUTE AS USER = 'Administrador'
GO

INSERT INTO dbo.Departamentos (Nombre, Apellido, Departamento)
VALUES ('Carmen', 'Gutierrez', 'Mozas'),
	   ('Dolores', 'Vel�zquez', 'Conductoras')
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

ALTER SECURITY POLICY Pol�ticaSeguridadDepartamentos
ADD BLOCK PREDICATE dbo.FuncionDepartamentos(Departamento)
	ON dbo.Departamentos BEFORE UPDATE
GO

EXECUTE AS USER = 'Mozas'
GO

UPDATE dbo.Departamentos
SET Nombre = 'Gaby'
WHERE IDEmpleada = '3'
GO

SELECT * FROM dbo.Departamentos
WHERE IDEmpleada = '3'
GO

UPDATE dbo.Departamentos
SET Nombre = 'Vicky'
WHERE IDEmpleada = '1'
GO

REVERT
GO

EXECUTE AS USER = 'Administrador'
GO

UPDATE dbo.Departamentos
SET Nombre = 'Mary'
WHERE IDEmpleada = '2'
GO

UPDATE dbo.Departamentos
SET Nombre = 'Ely'
WHERE IDEmpleada = '4'
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

ALTER SECURITY POLICY Pol�ticaSeguridadDepartamentos
ADD FILTER PREDICATE dbo.FuncionDepartamentos(Departamento)
	ON dbo.Departamentos
GO

EXECUTE AS USER = 'Mozas'
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

EXECUTE AS USER = 'Conductoras'
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

EXECUTE AS USER = 'Administrador'
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

ALTER SECURITY POLICY Pol�ticaSeguridadDepartamentos
ADD BLOCK PREDICATE dbo.FuncionDepartamentos(Departamento)
	ON dbo.Departamentos BEFORE DELETE
GO

EXECUTE AS USER = 'Mozas'
GO

DELETE dbo.Departamentos
WHERE Nombre = 'Victoria'
GO

DELETE dbo.Departamentos
WHERE Nombre = 'Gaby'
GO

REVERT
GO

EXECUTE AS USER = 'Administrador'
GO

DELETE dbo.Departamentos
WHERE Nombre = 'Mary'
GO

DELETE dbo.Departamentos
WHERE Nombre = 'Ely'
GO

REVERT
GO

SELECT * FROM sys.security_policies
GO

SELECT NAME, OBJECT_ID, TYPE, TYPE_DESC, is_ms_shipped, is_enabled, is_schema_bound
FROM sys.security_policies
GO

SELECT * FROM sys.security_predicates
GO

ALTER SECURITY POLICY Pol�ticaSeguridadDepartamentos
WITH (STATE = OFF);
GO

EXECUTE AS USER = 'Mozas'
GO

SELECT * FROM dbo.Departamentos
GO

REVERT
GO

EXECUTE AS USER = 'Conductoras'
GO

SELECT * FROM dbo.Departamentos
GO


--Auditor�as

USE master
GO

CREATE SERVER AUDIT [AppLog_auditor�a]
	TO application_log
WITH
( queue_delay = 5000,
  on_failure = continue
)
GO

CREATE SERVER AUDIT [SeguridadLog_auditor�a]
	TO security_log
WITH
( queue_delay = 5000,
  on_failure = continue
)
GO

CREATE SERVER AUDIT [ArchivoLog_auditor�a]
TO FILE
( filepath = 'C:\Auditor�a\',
  maxsize = 0 mb,
  max_rollover_files = 2147483647,
  reserve_disk_space = off
)
WITH
( queue_delay = 5000,
  on_failure = continue
)
GO

ALTER SERVER AUDIT ArchivoLog_auditor�a WITH (STATE = ON)
GO

CREATE SERVER AUDIT specification [ArchivoInstanciasAuditor�as]
FOR SERVER AUDIT [ArchivoLog_auditor�a]
	ADD (server_state_change_group),
	ADD (backup_restore_group),
	ADD (dbcc_group)
WITH (STATE = ON)
GO

BACKUP DATABASE MulleresColleiteiras
	TO DISK = 'c:\Auditor�a\Mulleres.bak'
	WITH INIT;
GO

DBCC CHECKDB;
GO

DBCC CHECKDB (MulleresColleiteiras, NOINDEX);
GO

SELECT *
	FROM sys.fn_get_audit_file ('C:\Auditor�a\*',default,default);
GO

BACKUP DATABASE MulleresColleiteiras
	TO DISK = 'c:\Auditor�a\Contenida.bak'
	WITH INIT;
GO

SELECT *
	FROM sys.fn_get_audit_file ('C:\Auditor�a\*',default,default);
GO

USE MulleresColleiteiras
GO

SELECT * FROM [dbo].[empleadas]
GO

CREATE DATABASE AUDIT specification [Auditor�a empleadas MulleresColleiteiras]
FOR SERVER AUDIT [ArchivoLog_auditor�a]
ADD (SELECT ON OBJECT::[dbo].[empleadas] BY [dbo]),
ADD (INSERT ON OBJECT::[dbo].[empleadas] BY [dbo]),
ADD (UPDATE ON OBJECT::[dbo].[empleadas] BY [dbo]),
ADD (DELETE ON OBJECT::[dbo].[empleadas] BY [dbo])
GO

ALTER DATABASE AUDIT specification [Auditor�a empleadas MulleresColleiteiras]
WITH (STATE = ON) 
GO

DELETE [dbo].[empleadas]
WHERE Nombre = 'Manuela'
GO

SELECT *
	FROM sys.fn_get_audit_file ('C:\Auditor�a\*.sqlaudit',default,default);
GO

ALTER DATABASE AUDIT specification [Auditor�a empleadas MulleresColleiteiras]
WITH (STATE = OFF) 
GO


--Ledger

USE master
GO

DROP DATABASE IF EXISTS MuCoSegura
GO

CREATE DATABASE MuCoSegura
GO

ALTER DATABASE MuCoSegura
	SET ALLOW_SNAPSHOT_ISOLATION ON;
GO

USE MuCoSegura
GO

DROP TABLE IF EXISTS TrabajadorasDepartamentos
GO

CREATE TABLE TrabajadorasDepartamentos
(
	IDEmpleada INT IDENTITY PRIMARY KEY,
	DNI VARCHAR(12),
	Nombre NVARCHAR (25),
	Apellido NVARCHAR (50),
	Departamento VARCHAR (20)
)
WITH
(
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.TrabajadorasDepartamentosHist),
	LEDGER = ON
);
GO

INSERT INTO TrabajadorasDepartamentos (DNI, Nombre, Apellido, Departamento)
VALUES ('11111111V', 'Victoria', 'Miramontes', 'Conductoras'),
	   ('22222222M', 'Maribel', 'Moreno', 'Conductoras'),
	   ('33333333G', 'Gabriela', 'Garc�a', 'Mozas'),
	   ('44444444E', 'Elena', 'Mart�nez', 'Mozas')
GO

SELECT * FROM TrabajadorasDepartamentos
GO

SELECT [ledger_start_transaction_id],
       [ledger_end_transaction_id],
       [ledger_start_sequence_number],
       [ledger_end_sequence_number]
  FROM TrabajadorasDepartamentos
GO

SELECT * FROM sys.database_ledger_transactions
GO

SELECT * FROM sys.database_ledger_blocks
GO

UPDATE TrabajadorasDepartamentos
	SET Nombre = 'Vicky' 
	WHERE Apellido = 'Miramontes' AND Nombre = 'Victoria'
GO
DELETE FROM TrabajadorasDepartamentos
WHERE Apellido = 'Mart�nez' AND Nombre = 'Elena'
GO

SELECT [ledger_start_transaction_id],
       [ledger_end_transaction_id],
       [ledger_start_sequence_number],
       [ledger_end_sequence_number]
  FROM TrabajadorasDepartamentos
GO

SELECT * FROM sys.database_ledger_transactions
GO

SELECT * FROM sys.database_ledger_blocks
GO

DROP TABLE IF EXISTS PagoSalarios
GO

CREATE TABLE PagoSalarios
(
	IDPago INT IDENTITY PRIMARY KEY,
	IDEmpleada INT FOREIGN KEY REFERENCES TrabajadorasDepartamentos,
	Cantidad MONEY
)
WITH
	(LEDGER = ON (APPEND_ONLY = ON));
GO

INSERT PagoSalarios (IDEmpleada, Cantidad)
VALUES (1, 1700)
GO

UPDATE PagoSalarios
SET Cantidad = 1800
WHERE IDPago = 1
GO

DELETE PagoSalarios
WHERE IDPago = 1
GO

SELECT * , [ledger_start_transaction_id]
         ,[ledger_start_sequence_number]
FROM PagoSalarios
GO

EXECUTE sp_generate_database_ledger_digest
GO

-- {"database_name":"MuCoSegura","block_id":0,"hash":"0x94C90E86EF2272E6F1BD9CC33D04A9557C0F71E937819A56F9B69A008175644C","last_transaction_commit_time":"2025-03-24T23:39:24.0566667","digest_time":"2025-03-24T22:47:11.1869808"}


SELECT * FROM sys.database_ledger_blocks
GO

EXECUTE sp_verify_database_ledger N'
[
	{"database_name":"MuCoSegura","block_id":0,"hash":"0x94C90E86EF2272E6F1BD9CC33D04A9557C0F71E937819A56F9B69A008175644C","last_transaction_commit_time":"2025-03-24T23:39:24.0566667","digest_time":"2025-03-24T22:47:11.1869808"}
]';

SELECT sys.fn_PhysLocFormatter(%%physloc%%) as [Physical RID], * 
FROM dbo.PagoSalarios
GO

DBCC TRACEON(3604)
GO

DBCC PAGE (MuCoSegura,1,584,0)
GO

SELECT CONVERT (VARBINARY(33),'1700')
GO

--0x31373030

SELECT CONVERT (VARBINARY(33),'1800')
GO

-- 0x31383030

ALTER DATABASE MuCoSegura SET PAGE_VERIFY NONE
GO

ALTER DATABASE MuCoSegura SET SINGLE_USER
GO

DBCC WRITEPAGE ('MuCoSegura',1,584,104,4,0x31383030,0)
GO

ALTER DATABASE MuCoSegura SET MULTI_USER
GO

ALTER DATABASE MuCoSegura SET PAGE_VERIFY CHECKSUM
GO

SELECT * FROM PagoSalarios
GO

EXECUTE sp_verify_database_ledger N'
[
	{"database_name":"MuCoSegura","block_id":0,"hash":"0x94C90E86EF2272E6F1BD9CC33D04A9557C0F71E937819A56F9B69A008175644C","last_transaction_commit_time":"2025-03-24T23:39:24.0566667","digest_time":"2025-03-24T22:47:11.1869808"}
]';

