
SELECT * FROM recibos;
SELECT * FROM detalles_ventas;
SELECT * FROM detalles_alquileres;
SELECT * FROM alquileres;
SELECT * FROM transacciones;
SELECT * FROM ventas;
SELECT * FROM detalles_pedidos;
SELECT * FROM productos_pedidos;
SELECT * FROM inferiores;
SELECT * FROM superiores;
SELECT * FROM pedidos;
SELECT * FROM comprobantes;
SELECT * FROM empleados;
SELECT * FROM clientes;
SELECT * FROM documentos;
SELECT * FROM generos;
SELECT * FROM productos;
SELECT * FROM condiciones;
SELECT * FROM categorias;
SELECT * FROM telas;
SELECT * FROM proveedores;

--DECLARE @detalle_venta_v TABLE (id_producto_v varchar(15), cantidad_venta_v int)
--INSERT INTO @detalle_venta_v VALUES 
--	('PRO-1', 1),
--	('PRO-2', 2)

--SELECT cantidad_venta_v, p.stock_p
--FROM @detalle_venta_v dvv
--JOIN producto p ON dvv.id_producto_v = p.id_producto
	
-- ============================================================================================

--DECLARE @detalle_venta_v TABLE (id_producto_v varchar(15), cantidad_venta_v int)
--INSERT INTO @detalle_venta_v VALUES 
--    ('PRO-1', 1),
--    ('PRO-2', 2);

--SELECT 
--    dvv.id_producto_v,
--    dvv.cantidad_venta_v,
--    p.stock_p,
--    CASE WHEN dvv.cantidad_venta_v > p.stock_p THEN 'Exceso' ELSE 'OK' END AS estado
--FROM @detalle_venta_v dvv
--JOIN producto p ON dvv.id_producto_v = p.id_producto;


SELECT * FROM productos
INNER JOIN detalles_ventas ON productos.id_producto = detalles_ventas.id_producto
WHERE detalles_ventas.cantidad_venta <= productos.stock_p


-- ============================================================================================

DECLARE @detalle_venta_v TABLE (id_producto_v varchar(15), cantidad_venta_v int)
INSERT INTO @detalle_venta_v VALUES 
    ('PRO-3', 1),
    ('PRO-2', 2),
	('PRO-1', 2)

DECLARE @can_proceed bit;

-- Comprobar si todas las cantidades son mayores o iguales a la cantidad disponible
SET @can_proceed = (
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM @detalle_venta_v dv
            JOIN productos p ON dv.id_producto_v = p.id_producto
            WHERE dv.cantidad_venta_v <= p.stock_p
        ) THEN 1
        ELSE 0
    END
);
-- Si todas las cantidades son mayores o iguales, iniciar la secuencia de venta
IF @can_proceed = 1
BEGIN
    PRINT 'Se puede proceder con la venta.';
END
-- Si todas las cantidades NO son mayores o iguales, forzamos el error
ELSE
BEGIN
	RAISERROR('No se pueden vender productos con cantidades insuficientes.', 16, 1);
END




SELECT * FROM productos
INNER JOIN detalles_ventas ON productos.id_producto = detalles_ventas.id_producto
WHERE detalles_ventas.cantidad_venta <= productos.stock_p

SELECT * FROM detalles_ventas