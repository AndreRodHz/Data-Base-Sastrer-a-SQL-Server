-- =======================================================================================================================================
---FUNCION PARA COLOCAR LA PRIMERA LETRA EN MAYUSCULA DE CADA ORACION
-- =======================================================================================================================================
CREATE FUNCTION dbo.Capitalizador (@inputString VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @outputString VARCHAR(255) = '';
    DECLARE @capitalizeNext BIT = 1;
    
    SET @inputString = LOWER(LTRIM(RTRIM(@inputString))) + ' ';
    
    DECLARE @i INT = 1;
    WHILE @i <= LEN(@inputString)
    BEGIN
        DECLARE @char CHAR(1) = SUBSTRING(@inputString, @i, 1);
        
        IF @capitalizeNext = 1 AND @char LIKE '[a-z]'
        BEGIN
            SET @outputString += UPPER(@char);
            SET @capitalizeNext = 0;
        END
        ELSE IF @char = ' '
        BEGIN
            SET @outputString += ' ';
            SET @capitalizeNext = 1;
        END
        ELSE
        BEGIN
            SET @outputString += @char;
        END
        
        SET @i += 1;
    END
    
    RETURN @outputString;
END;