-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA CONDCIONES
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_condicion
CREATE PROCEDURE dbo.ultimo_codigo_condicion
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM condiciones)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_condicion, 5, LEN(id_condicion)))
			FROM condiciones
			ORDER BY CONVERT(INT, SUBSTRING(id_condicion, 5, LEN(id_condicion))) DESC

			SET @salida = 'CDN-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'CDN-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_condicion
GO