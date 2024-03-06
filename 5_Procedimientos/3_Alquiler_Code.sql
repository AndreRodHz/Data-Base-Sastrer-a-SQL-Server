-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA ALQUILER
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_alquiler
CREATE PROCEDURE dbo.ultimo_codigo_alquiler
AS
	SET NOCOUNT ON;

	DECLARE	@salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM alquileres)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_alquiler, 3, LEN(id_alquiler)))
			FROM alquileres
			ORDER BY CONVERT(INT, SUBSTRING(id_alquiler, 3, LEN(id_alquiler))) DESC

			SET @salida = 'A-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'A-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_alquiler
GO