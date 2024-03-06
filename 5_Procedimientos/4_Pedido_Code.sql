-- ==================================================================================================
---PARA CREAR EL IDENTIFICADOR DE LA TABLA PEDIDO
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_pedido
CREATE PROCEDURE dbo.ultimo_codigo_pedido
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM pedidos)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_pedido, 3, LEN(id_pedido)))
			FROM pedidos
			ORDER BY CONVERT(INT, SUBSTRING(id_pedido, 3, LEN(id_pedido))) DESC
			
			SET @salida = 'P-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'P-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_pedido
GO