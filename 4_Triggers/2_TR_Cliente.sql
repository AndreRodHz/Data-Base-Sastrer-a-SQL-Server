-- ==================================================================================================
---PARA QUE LOS TEXTOS INGRESADOS EN LA TABLA CLIENTE SEAN CAPITALIZADOS (NORMALIZACION DE DATOS)
-- ==================================================================================================
CREATE TRIGGER entrada_cliente
ON clientes
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE clientes
    SET nombre_c = dbo.Capitalizador(inserted.nombre_c),
        email_c =
            CASE 
                WHEN inserted.email_c IS NOT NULL AND CHARINDEX('@', inserted.email_c) > 0 THEN
                    (SUBSTRING(inserted.email_c, 1, CHARINDEX('@', inserted.email_c))) +
                    LOWER(SUBSTRING(inserted.email_c, CHARINDEX('@', inserted.email_c) + 1, LEN(inserted.email_c) - CHARINDEX('@', inserted.email_c) + 1))
                ELSE
                    inserted.email_c
            END
    FROM inserted
    WHERE clientes.id_cliente = inserted.id_cliente;
END;