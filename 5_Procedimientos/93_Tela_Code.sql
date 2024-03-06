-- ==================================================================================================
---PARA GENERAR EL IDENTIFICADOR DE LA TABLA TELAS
-- ==================================================================================================
--DROP PROCEDURE dbo.ultimo_codigo_tela
CREATE PROCEDURE dbo.ultimo_codigo_tela
AS
	SET NOCOUNT ON;

	DECLARE @salida VARCHAR(15)

	IF EXISTS (SELECT 1 FROM telas)
		BEGIN
		-- ==========================================================================================
			DECLARE @ultimo_num INT

			SELECT TOP 1 @ultimo_num = CONVERT(INT, SUBSTRING(id_tela, 5, LEN(id_tela)))
			FROM telas
			ORDER BY CONVERT(INT, SUBSTRING(id_tela, 5, LEN(id_tela))) DESC

			SET @salida = 'TLA-' + CAST(@ultimo_num + 1 AS VARCHAR(15))
		-- ==========================================================================================
		END
	ELSE
		BEGIN
		-- ==========================================================================================
			SET @salida = 'TLA-1'
		-- ==========================================================================================
		END
	SELECT @salida
GO
-- ==================================================================================================
-- ==================================================================================================
EXECUTE dbo.ultimo_codigo_tela
GO