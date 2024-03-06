-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA PRODUCTO PEDIDO
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_producto_pedido
CREATE PROCEDURE dbo.ultimo_codigo_producto_pedido
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM productos_pedidos)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_prod_pedi, 5, LEN(id_prod_pedi)))
			FROM productos_pedidos
			ORDER BY CONVERT(INT, SUBSTRING(id_prod_pedi, 5, LEN(id_prod_pedi))) DESC

			SET @salida = 'PRP-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'PRP-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_producto_pedido
GO