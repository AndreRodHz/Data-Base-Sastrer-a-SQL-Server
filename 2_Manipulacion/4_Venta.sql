USE Sastreria
-- =======================================================================================================================================
----CREACION DEL VERIFICADOR CON RESPECTO AL **STOCK DE LOS PRODUCTOS**
-- =======================================================================================================================================
DECLARE @detalle_venta_v TABLE (id_producto_v VARCHAR(15), cantidad_venta_v INT)

INSERT INTO @detalle_venta_v VALUES 
    ('PRO-2', 1),
    ('PRO-3', 2)

DECLARE @can_proceed BIT;

-- Comprobar si todas las cantidades son mayores o iguales a la cantidad disponible
SET @can_proceed = (
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM @detalle_venta_v dv
            JOIN productos p ON dv.id_producto_v = p.id_producto
            WHERE dv.cantidad_venta_v > p.stock_p
        ) THEN 1
        ELSE 0
    END
);

-- Si todas las cantidades son mayores o iguales, iniciar la secuencia de venta
IF @can_proceed = 1
	BEGIN
--		=======================================================================================================================================
---		-CREACION DEL IDENTIFICADOR **TRANSACCION**
--		=======================================================================================================================================
		DECLARE @temp_tabla_tv TABLE (tv_code VARCHAR(15))
		DECLARE @transac_code VARCHAR(15)

		INSERT INTO @temp_tabla_tv (tv_code)
		EXEC dbo.ultimo_codigo_transaccion;

		SELECT @transac_code = tv_code FROM @temp_tabla_tv

		INSERT INTO transacciones VALUES
			(@transac_code, 'Venta', CURRENT_TIMESTAMP)
--		=======================================================================================================================================
---		-INSERCION DE DATOS PARA LA TABLA **VENTA** - GENERACION DE LA VENTA
--		=======================================================================================================================================
		DECLARE @temp_tabla_v TABLE(v_code VARCHAR(15))
		DECLARE	@venta_code VARCHAR(15)

		INSERT INTO @temp_tabla_v (v_code)
		EXEC dbo.ultimo_codigo_venta;

		SELECT @venta_code = v_code FROM @temp_tabla_v	
	
		INSERT INTO ventas VALUES
			(@venta_code, (SELECT TOP 1 id_transac FROM transacciones ORDER BY fecha_t DESC),
			'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
--		=======================================================================================================================================
---		-INSERCION EN LA DE LOS PRODCTOS DE VENTA **DETALLE VENTA**
--		======================================================================================================================================= 
		INSERT INTO detalles_ventas VALUES
			(@venta_code, 'PRO-2', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-2'), 1),
			(@venta_code, 'PRO-3', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-3'), 2)
--		=======================================================================================================================================
---		-ACTUALIZACION DE LA TABLA **VENTA** CON PRECIOS DEL DETALLE VENTA
--		======================================================================================================================================= 
		UPDATE ventas
			SET precio_base_v =
				(
				SELECT SUM(precio_u * cantidad_venta)
				FROM detalles_ventas
				WHERE detalles_ventas.id_venta = ventas.id_venta
				)
			WHERE ventas.id_venta = @venta_code;

		UPDATE ventas
			SET impuesto_v = (SELECT precio_base_v FROM ventas WHERE id_venta = @venta_code) * 0.18,
					total_v = (SELECT precio_base_v FROM ventas WHERE id_venta = @venta_code) +
							  (SELECT precio_base_v FROM ventas WHERE id_venta = @venta_code) * 0.18
			WHERE ventas.id_venta = @venta_code;
--		=======================================================================================================================================
---		-INSERCION EN LA TABLA **RECIBO**
--		======================================================================================================================================= 
		DECLARE @temp_tabla_rv TABLE(rv_code VARCHAR(15))
		DECLARE @recibo_code VARCHAR(15)

		INSERT INTO @temp_tabla_rv (rv_code)
		EXEC dbo.ultimo_codigo_recibo;

		SELECT @recibo_code = rv_code FROM @temp_tabla_rv

		DECLARE @id_compro VARCHAR(15)
		SET @id_compro = 'CMP-2'

		INSERT INTO recibos VALUES
			(@recibo_code, (SELECT TOP 1 id_transac FROM transacciones ORDER BY fecha_t DESC), @id_compro,
			(SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
			(SELECT precio_base_v FROM ventas WHERE id_venta = (SELECT TOP 1 id_venta FROM ventas ORDER BY fecha_v DESC)), 
			(SELECT impuesto_v FROM ventas WHERE id_venta = (SELECT TOP 1 id_venta FROM ventas ORDER BY fecha_v DESC)), 
			(SELECT total_v FROM ventas WHERE id_venta = (SELECT TOP 1 id_venta FROM ventas ORDER BY fecha_v DESC)), 'Pagado')
--		=======================================================================================================================================
---		-ACTUALIZACION DE PRODUCTOS EN LA TABLA **PRODUCTO**
--		======================================================================================================================================= 
		UPDATE productos
			SET stock_p = stock_p - detalles_ventas.cantidad_venta
			FROM productos
			INNER JOIN detalles_ventas ON productos.id_producto = detalles_ventas.id_producto
			WHERE detalles_ventas.id_venta = @venta_code
	END
--==========================================================SEPARADOR DE IF====================================================================
ELSE -- Si todas las cantidades NO son mayores o iguales, forzamos el error
	BEGIN
		RAISERROR('No se pueden vender productos con cantidades insuficientes.', 16, 1);
	END
-- =======================================================================================================================================
-- SELECT PARA OBTENER MATRIZ DE CARA AL USUARIO
-- =======================================================================================================================================
SELECT ventas.id_venta AS 'ID Venta', id_recibo AS 'ID Recibo', ventas.id_transac AS 'ID Transaccion',
	   id_empleado AS 'ID Empleado', ventas.id_cliente AS 'ID Cliente', num_doc_c AS 'N° Documento Cliente',
	   nombre_c AS 'Cliente', nombre_com AS 'Comprobante', num_comprobante AS 'N° Comprobante',fecha_v AS 'Fecha',
	   precio_base_v AS 'Precio BASe', impuesto_v AS 'Impuesto', total_v AS 'Total'
FROM ventas
INNER JOIN clientes ON ventas.id_cliente = clientes.id_cliente
INNER JOIN recibos ON ventas.id_transac = recibos.id_transac
INNER JOIN comprobantes ON recibos.id_comprobante = comprobantes.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(ventas.id_venta, 3, LEN(ventas.id_venta))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
SELECT * FROM transacciones ORDER BY fecha_t DESC
SELECT * FROM ventas ORDER BY fecha_v DESC
SELECT * FROM detalles_ventas WHERE id_venta = @venta_code
SELECT * FROM productos
SELECT * FROM recibos ORDER BY fecha_recibo DESC