-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA RECIBO
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_recibo
CREATE PROCEDURE dbo.ultimo_codigo_recibo
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM recibos)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT
			
			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_recibo, 3, LEN(id_recibo)))
			FROM recibos
			ORDER BY CONVERT(INT, SUBSTRING(id_recibo, 3, LEN(id_recibo))) DESC

			SET @salida = 'R-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'R-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_recibo
GO