-- ==================================================================================================
---PARA CREAR EL IDENTIFICADOR DE LA TABLA TRANSACCION
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_transaccion
CREATE PROCEDURE dbo.ultimo_codigo_transaccion
AS
	SET NOCOUNT ON;

	DECLARE	@salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM transacciones)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_transac, 3, LEN(id_transac)))
			FROM transacciones
			ORDER BY CONVERT(INT, SUBSTRING(id_transac, 3, LEN(id_transac))) DESC

			SET @salida = 'T-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'T-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_transaccion
GO