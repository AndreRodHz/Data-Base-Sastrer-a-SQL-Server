USE Sastreria
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================
DECLARE @temp_tabla_tp TABLE (tp_code VARCHAR(15))
DECLARE @transac_code VARCHAR(15)

INSERT INTO @temp_tabla_tp (tp_code)
EXEC dbo.ultimo_codigo_transaccion;

SELECT @transac_code = tp_code FROM @temp_tabla_tp

INSERT INTO transacciones VALUES
	(@transac_code, 'Pedido	', CURRENT_TIMESTAMP)
-- =======================================================================================================================================
----INSERCION DE DATOS PARA LA TABLA **PEDIDO** - GENERACION DEL PEDIDO
-- ======================================================================================================================================= 
DECLARE @temp_tabla TABLE(ped_code VARCHAR(15))
DECLARE	@pedido_code VARCHAR(15)

INSERT INTO @temp_tabla (ped_code)
EXEC dbo.ultimo_codigo_pedido;

SELECT @pedido_code = ped_code FROM @temp_tabla

INSERT INTO pedidos VALUES
	(@pedido_code, (SELECT TOP 1 id_transac FROM transacciones ORDER BY fecha_t DESC),
	'CLI-2', 'EMP-1', CURRENT_TIMESTAMP, 'Para niño de 10 años', 0, 0, 0)
-- =======================================================================================================================================
----INSERCION EN LA DE LOS PRODUCTOS DE PEDIDO **DETALLE PEDIDO**
-- ======================================================================================================================================= 
INSERT INTO detalles_pedidos VALUES
	(@pedido_code, 'PRP-1', 'Croma', 100),
	(@pedido_code, 'PRP-2', 'Laraga roja', 265),
	(@pedido_code, 'PRP-3', 'Raya triple', 130)
-- =======================================================================================================================================
----ACTUALIZACION DE LA TABLA **PEDIDO** CON PRECIOS DEL DETALLE PEDIDO
-- ======================================================================================================================================= 
UPDATE pedidos
	SET precio_base_p =
	(
		SELECT SUM(precio_d_pp)
		FROM detalles_pedidos
		WHERE detalles_pedidos.id_pedido = pedidos.id_pedido
	)
WHERE pedidos.id_pedido = @pedido_code;

UPDATE pedidos
	SET impuesto_p = (SELECT precio_base_p FROM pedidos WHERE id_pedido = @pedido_code) * 0.18,
		total_p = (SELECT precio_base_p FROM pedidos WHERE id_pedido = @pedido_code) +
				  (SELECT precio_base_p FROM pedidos WHERE id_pedido = @pedido_code) * 0.18
	WHERE pedidos.id_pedido = @pedido_code;
-- =======================================================================================================================================
----INSERCION EN LA TABLA **RECIBO**
-- =======================================================================================================================================
DECLARE @temp_tabla_rp TABLE(rp_code VARCHAR(15))
DECLARE @recibo_code VARCHAR(15)

INSERT INTO @temp_tabla_rp (rp_code)
EXEC dbo.ultimo_codigo_recibo;

SELECT @recibo_code = rp_code FROM @temp_tabla_rp

DECLARE @id_compro VARCHAR(15)
SET @id_compro = 'CMP-1'

INSERT INTO recibos VALUES
(
	@recibo_code, (SELECT TOP 1 id_transac FROM transacciones ORDER BY fecha_t DESC),
	@id_compro, (SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
	(SELECT precio_base_p FROM pedidos WHERE id_pedido = (SELECT TOP 1 id_pedido FROM pedidos ORDER BY fecha_p DESC)),
	(SELECT impuesto_p FROM pedidos WHERE id_pedido = (SELECT TOP 1 id_pedido FROM pedidos ORDER BY fecha_p DESC)),
	(SELECT total_p FROM pedidos WHERE id_pedido = (SELECT TOP 1 id_pedido FROM pedidos ORDER BY fecha_p DESC)), 'Pagado'
)
-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- =======================================================================================================================================
SELECT pedidos.id_pedido AS 'ID Pedido', id_recibo AS 'ID Recibo',  pedidos.id_transac AS 'ID Transaccion', id_empleado AS 'ID Empleado',
	   pedidos.id_cliente AS 'ID Cliente', num_doc_c AS 'N° Documento Cliente', nombre_c AS 'Cliente', nombre_com AS 'Comprobante',
	   num_comprobante AS 'N° Comprobante', fecha_p AS 'Fecha', DESCrip AS 'Descripcion', precio_base_p AS 'Precio BASe',
	   impuesto_p AS 'Impuesto', total_p AS 'Total'
FROM pedidos
INNER JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
INNER JOIN recibos ON pedidos.id_transac = recibos.id_transac
INNER JOIN comprobantes ON recibos.id_comprobante = comprobantes.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(pedidos.id_pedido, 3, LEN(pedidos.id_pedido))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
SELECT * FROM transacciones ORDER BY fecha_t DESC
SELECT * FROM pedidos ORDER BY fecha_p DESC
SELECT * FROM detalles_pedidos WHERE id_pedido = @pedido_code
SELECT * FROM recibos ORDER BY fecha_recibo DESC