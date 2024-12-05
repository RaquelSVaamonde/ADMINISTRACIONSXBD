USE MulleresColleiteiras
GO

CREATE or ALTER PROC TotalAceite
AS

BEGIN
	SELECT SUM(Cantidad) AS [Total],
	'Transportado' AS [Aceite]
	FROM dbo.LitrosTransportados
	UNION ALL
	SELECT SUM(Cantidad) AS [Total],
	'Almacenado' AS [Aceite]
FROM dbo.LitrosAlmacenados
END
GO

EXEC TotalAceite
GO