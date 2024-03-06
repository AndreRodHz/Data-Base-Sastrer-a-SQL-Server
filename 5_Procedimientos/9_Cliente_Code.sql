-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA CLIENTE
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_cliente
CREATE PROCEDURE dbo.ultimo_codigo_cliente
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM clientes)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_cliente, 5, LEN(id_cliente)))
			FROM clientes
			ORDER BY CONVERT(INT, SUBSTRING(id_cliente, 5, LEN(id_cliente))) DESC

			SET @salida = 'CLI-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'CLI-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_cliente
GO