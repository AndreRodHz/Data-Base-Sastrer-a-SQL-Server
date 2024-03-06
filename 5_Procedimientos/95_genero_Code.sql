-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA GENERO
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_genero
CREATE PROCEDURE dbo.ultimo_codigo_genero
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM generos)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_genero, 5, LEN(id_genero)))
			FROM generos
			ORDER BY CONVERT(INT, SUBSTRING(id_genero, 5, LEN(id_genero))) DESC

			SET @salida = 'GEN-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'GEN-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_genero
GO