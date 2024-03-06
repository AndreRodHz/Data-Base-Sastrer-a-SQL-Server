-- =======================================================================================================================================
---FUNCION PARA EXTRAER EL NUMERO DE COMPROBANTE DE FORMA INDEPENDIENTE
-- =======================================================================================================================================
CREATE FUNCTION dbo.generar_num_comprobante (@inputString VARCHAR(5))
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @input_num_comp VARCHAR(20),
			@primera VARCHAR(4),
			@segunda VARCHAR(8),
			@seg_num INT,
			@seg_salida VARCHAR(8),
			@pri_salida_pos VARCHAR(3),
			@letra VARCHAR(1),
			@pri_digito INT,
			@return VARCHAR(13)

	SET @input_num_comp = (SELECT MAX(num_comprobante) FROM recibos WHERE num_comprobante LIKE ('%'+@inputString+'%'))
	SET	@primera = substring(@input_num_comp, 1, LEN(@input_num_comp)-9)
	SET @segunda = SUBSTRING(@input_num_comp, 6, LEN(@input_num_comp)-5)
	SET @seg_num = CONVERT(INT,@segunda, 0)

	IF @seg_num + 1 = 100000000
		BEGIN
			SET @letra = SUBSTRING(@primera, 1, 1)
			SET @pri_digito = CONVERT(INT,(SUBSTRING(@primera, 2, 3)), 0)
			SET @pri_salida_pos = (SELECT RIGHT(REPLICATE('0', 3-LEN(@pri_digito)) + CONVERT(VARCHAR(3), @pri_digito + 1), 3))
			SET @seg_salida = (SELECT RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), 1), 8))
			SET @return = @letra + @pri_salida_pos + '-' + @seg_salida
		END
	ELSE
		BEGIN
			SET @seg_salida = (SELECT RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), @seg_num + 1), 8))
			SET @return = @primera + '-' + @seg_salida
		END		
RETURN @return;
END;

--SELECT dbo.generar_num_comprobante('F')