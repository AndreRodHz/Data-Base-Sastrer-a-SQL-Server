USE Sastreria
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================

DECLARE @detalle_alquiler_a TABLE (id_producto_a VARCHAR(15), cantidad_alquiler_a INT)

INSERT INTO @detalle_alquiler_a VALUES 
    ('PRO-1', 2),
    ('PRO-4', 2)

DECLARE @can_proceed BIT;

-- Comprobar si todas las cantidades son mayores o iguales a la cantidad disponible
SET @can_proceed = (
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM @detalle_alquiler_a da
            JOIN productos p ON da.id_producto_a = p.id_producto
            WHERE da.cantidad_alquiler_a > p.stock_p
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
		DECLARE @temp_tabla_ta TABLE (ta_code VARCHAR(15))
		DECLARE @transac_code VARCHAR(15)

		INSERT INTO @temp_tabla_ta (ta_code)
		EXEC dbo.ultimo_codigo_transaccion;

		SELECT @transac_code = ta_code FROM @temp_tabla_ta

		INSERT INTO transacciones VALUES
			(@transac_code, 'Alquiler', CURRENT_TIMESTAMP)
--		=======================================================================================================================================
---		-INSERCION DE DATOS PARA LA TABLA **ALQUILER** - GENERACION DEL ALQUILER
--		=======================================================================================================================================
		DECLARE @temp_tabla_a TABLE(a_code VARCHAR(15))
		DECLARE	@alqui_code VARCHAR(15)

		INSERT INTO @temp_tabla_a (a_code)
		EXEC dbo.ultimo_codigo_alquiler;

		SELECT @alqui_code = a_code FROM @temp_tabla_a

		INSERT INTO alquileres VALUES
			(@alqui_code, (SELECT TOP 1 id_transac FROM transacciones ORDER BY fecha_t DESC),
			'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
--		=======================================================================================================================================
---		-INSERCION EN LA DE LOS PRODCTOS DE ALQUILER **DETALLE ALQUILER**
--		======================================================================================================================================= 
		INSERT INTO detalles_alquileres VALUES
			(@alqui_code, 'PRO-1', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-1'), 2),
			(@alqui_code, 'PRO-2', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-2'), 1)
--		=======================================================================================================================================
---		-ACTUALIZACION DE LA TABLA **ALQUILER** CON PRECIOS DEL DETALLE ALQUILER
--		======================================================================================================================================= 
		UPDATE alquileres
			SET precio_base_a =
			(
				SELECT SUM(precio_u * cantidad_alquiler)
				FROM detalles_alquileres
				WHERE detalles_alquileres.id_alquiler = alquileres.id_alquiler
			)
		WHERE alquileres.id_alquiler = @alqui_code;

		UPDATE alquileres
			SET impuesto_a = (SELECT precio_base_a FROM alquileres WHERE id_alquiler = @alqui_code) * 0.18,
				total_a = (SELECT precio_base_a FROM alquileres WHERE id_alquiler = @alqui_code) +
						  (SELECT precio_base_a FROM alquileres WHERE id_alquiler = @alqui_code) * 0.18
			WHERE alquileres.id_alquiler = @alqui_code;
--		=======================================================================================================================================
---		-INSERCION EN LA TABLA **RECIBO**
--		=======================================================================================================================================
		DECLARE @temp_tabla_ra TABLE(ra_code VARCHAR(15))
		DECLARE @recibo_code VARCHAR(15)

		INSERT INTO @temp_tabla_ra (ra_code)
		EXEC dbo.ultimo_codigo_recibo;

		SELECT @recibo_code = ra_code FROM @temp_tabla_ra

		DECLARE @id_compro VARCHAR(15)
		SET @id_compro = 'CMP-2'

		INSERT INTO recibos VALUES
			(@recibo_code, (SELECT TOP 1 id_transac FROM transacciones ORDER BY fecha_t DESC),@id_compro,
			(SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
			(SELECT precio_base_a FROM alquileres WHERE id_alquiler = (SELECT TOP 1 id_alquiler FROM alquileres ORDER BY fecha_a DESC)),
			(SELECT impuesto_a FROM alquileres WHERE id_alquiler = (SELECT TOP 1 id_alquiler FROM alquileres ORDER BY fecha_a DESC)),
			(SELECT total_a FROM alquileres WHERE id_alquiler = (SELECT TOP 1 id_alquiler FROM alquileres ORDER BY fecha_a DESC)), 'Pagado')
--		=======================================================================================================================================
---		-ACTUALIZACION DE PRODUCTOS EN LA TABLA **PRODUCTO**
--		======================================================================================================================================= 
		UPDATE productos
			SET stock_p = stock_p - detalles_alquileres.cantidad_alquiler
			FROM productos
			INNER JOIN detalles_alquileres ON productos.id_producto = detalles_alquileres.id_producto
			WHERE detalles_alquileres.id_alquiler = @alqui_code
	END
--==========================================================SEPARADOR DE IF====================================================================
ELSE -- Si todas las cantidades NO son mayores o iguales, forzamos el error
	BEGIN
		RAISERROR('No se pueden alquilar productos con cantidades insuficientes.', 16, 1);
	END
--=======================================================================================================================================
----REPOSICION DE STOCK DEL PRODUCTO ALQUILADO
--=======================================================================================================================================
		DECLARE @alquiler_repuesto varchar(15)
		SET @alquiler_repuesto = 'A-1'
		UPDATE productos
			SET stock_p = stock_p + detalles_alquileres.cantidad_alquiler
			FROM productos
			INNER JOIN detalles_alquileres ON productos.id_producto = detalles_alquileres.id_producto
			WHERE detalles_alquileres.id_alquiler = @alquiler_repuesto
-- =======================================================================================================================================
-- =======================================================================================================================================
-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- =======================================================================================================================================
SELECT alquileres.id_alquiler AS 'ID Alquiler', id_recibo AS 'ID Recibo', alquileres.id_transac AS 'ID Transaccion',
	   id_empleado AS 'ID Empleado', alquileres.id_cliente AS 'ID Cliente', num_doc_c AS 'N° Documento Cliente',
	   nombre_c AS 'Cliente', nombre_com AS 'Comprobante',  num_comprobante AS 'N° Comprobante',fecha_a AS 'Fecha',
	   precio_base_a AS 'Precio BASe', impuesto_a AS 'Impuesto', total_a AS 'Total'
FROM alquileres
INNER JOIN clientes ON alquileres.id_cliente = clientes.id_cliente
INNER JOIN recibos ON alquileres.id_transac = recibos.id_transac
INNER JOIN comprobantes ON recibos.id_comprobante = comprobantes.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(alquileres.id_alquiler, 3, LEN(alquileres.id_alquiler))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
SELECT * FROM transacciones ORDER BY fecha_t DESC
SELECT * FROM alquileres ORDER BY fecha_a DESC
SELECT * FROM detalles_alquileres
SELECT * FROM productos
SELECT * FROM recibos ORDER BY fecha_recibo DESC