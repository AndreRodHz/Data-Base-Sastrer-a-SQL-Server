-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA CATEGORIAS
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_categoria
CREATE PROCEDURE dbo.ultimo_codigo_categoria
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM categorias)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_categoria, 5, LEN(id_categoria)))
			FROM categorias
			ORDER BY CONVERT(INT, SUBSTRING(id_categoria, 5, LEN(id_categoria))) DESC

			SET @salida = 'CTG-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'CTG-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_categoria
GO