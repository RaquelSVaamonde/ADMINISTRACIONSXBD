USE master
GO

EXEC sp_configure 'show advanced options', 1 
GO

RECONFIGURE
GO

EXEC sp_configure 'contained database authentication', 1
GO

RECONFIGURE
GO

DROP DATABASE IF EXISTS Contenida_Aceite
GO

CREATE DATABASE Contenida_Aceite
CONTAINMENT=PARTIAL
GO

USE Contenida_Aceite
GO

DROP USER IF EXISTS Marta
GO

CREATE USER Marta
WITH PASSWORD='Abcd1234.',
DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE db_owner
ADD MEMBER Marta
GO

GRANT CONNECT TO Marta
GO

CREATE TABLE [dbo].[AceiteContenida](
	[Codigo] [nchar](10) NULL,
	[Lugar] [varchar] (25) NULL,
	[Litros] [nchar](10) NULL
) ON [PRIMARY]
GO