-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA COMPROBANTES
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_comprobante
CREATE PROCEDURE dbo.ultimo_codigo_comprobante
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM comprobantes)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_comprobante, 5, LEN(id_comprobante)))
			FROM comprobantes
			ORDER BY CONVERT(INT, SUBSTRING(id_comprobante, 5, LEN(id_comprobante))) DESC

			SET @salida = 'CMP-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'CMP-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_comprobante
GO