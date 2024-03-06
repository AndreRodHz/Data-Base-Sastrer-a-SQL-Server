-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA PROVEEDORES
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_proveedor
CREATE PROCEDURE dbo.ultimo_codigo_proveedor
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM proveedores)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_proveedor, 5, LEN(id_proveedor)))
			FROM proveedores
			ORDER BY CONVERT(INT, SUBSTRING(id_proveedor, 5, LEN(id_proveedor))) DESC

			SET @salida = 'PRV-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'PRV-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_proveedor
GO