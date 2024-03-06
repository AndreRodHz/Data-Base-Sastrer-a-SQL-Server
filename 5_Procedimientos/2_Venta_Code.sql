-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA VENTA
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_venta
CREATE PROCEDURE dbo.ultimo_codigo_venta
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM ventas)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_venta, 3, LEN(id_venta)))
			FROM ventas
			ORDER BY CONVERT(INT, SUBSTRING(id_venta, 3, LEN(id_venta))) DESC

			SET @salida = 'V-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'V-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_venta
GO