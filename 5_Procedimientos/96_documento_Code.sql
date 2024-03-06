-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA DOCUMENTO
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_documento
CREATE PROCEDURE dbo.ultimo_codigo_documento
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM documentos)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_documento, 5, LEN(id_documento)))
			FROM documentos
			ORDER BY CONVERT(INT, SUBSTRING(id_documento, 5, LEN(id_documento))) DESC

			SET @salida = 'DOC-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'DOC-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_documento
GO