-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA PRODUCTO
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_producto
CREATE PROCEDURE dbo.ultimo_codigo_producto
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM productos)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_producto, 5, LEN(id_producto)))
			FROM productos
			ORDER BY CONVERT(INT, SUBSTRING(id_producto, 5, LEN(id_producto))) DESC

			SET @salida = 'PRO-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'PRO-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_producto
GO