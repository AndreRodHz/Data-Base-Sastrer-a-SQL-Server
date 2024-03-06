-- ==========================================================================================================
---PARA QUE NO SEA POSIBLE GUARDAR UN ID_TRANSACCION QUE YA ESTE EN RECIBO - PARA GARANTIZAR LA INTEGRIDAD
-- ==========================================================================================================
CREATE TRIGGER venta_vereficacion_id_transaccion
ON ventas
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
			  SELECT 1 FROM Recibos R
			  JOIN inserted I ON R.id_transac = I.id_transac
			  )
    BEGIN
        RAISERROR('No se permite ingresar un id_transaccion que ya existe en la tabla Recibo.', 16, 1);
        ROLLBACK TRANSACTION; -- Revertir la inserción
    END
END;