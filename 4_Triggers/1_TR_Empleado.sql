-- ==================================================================================================
---PARA QUE LOS TEXTOS INGRESADOS EN LA TABLA EMPLEADO SEAN CAPITALIZADOS (NORMALIZACION DE DATOS)
-- ==================================================================================================
CREATE TRIGGER entrada_empleado
ON empleados
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @password VARBINARY(255);
	SELECT @password = password_e FROM inserted;

    UPDATE empleados

    SET nombre_e = dbo.Capitalizador(inserted.nombre_e),
		password_e = HASHBYTES('SHA2_512', @password),
        email_e =
            CASE 
                WHEN inserted.email_e IS NOT NULL AND CHARINDEX('@', inserted.email_e) > 0 THEN
                    (SUBSTRING(inserted.email_e, 1, CHARINDEX('@', inserted.email_e))) +
                    LOWER(SUBSTRING(inserted.email_e, CHARINDEX('@', inserted.email_e) + 1, LEN(inserted.email_e) - CHARINDEX('@', inserted.email_e) + 1))
                ELSE
                    inserted.email_e
            END

    FROM inserted
    WHERE empleados.id_empleado = inserted.id_empleado;
END;