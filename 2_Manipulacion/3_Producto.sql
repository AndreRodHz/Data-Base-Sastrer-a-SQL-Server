USE SastreriaV1


--PARA AGREGAR UN NUEVO PRODUCTO
INSERT INTO productos VALUES
	('PRO-000', 'PRV-0000','nombre', 'descripcion', 'talla', 'categoria', 'condicion', precio, stock)
  -- Codigo,     proveedor ,Nombre,   Descripcion,   Talla,   Categoria,   Conmdicion, Precio, Stock


--PARA MODIFICAR UN PRODUCTO
UPDATE productos
	SET id_producto = '',
		nombre_p = '',
		descrip_p = '',
		talla = '',
		id_categoria = '',
		id_condicion = '',
		precio_p = 00,
		stock_p = 00
	WHERE id_producto = 'PRO-000';


--PARA ELIMINAR UN PRODUCTO
DELETE productos WHERE id_producto = 'PRO-000'


--PARA VER LA LISTA DE PRODUCTOS
SELECT id_producto AS 'ID Producto', id_proveedor AS 'Proveedor', nombre_p AS 'Nombre', descrip_p AS 'Descripcion', talla AS 'Talla',
	   nombre_cate AS 'Categoria', nombre_condi AS 'Condicion', precio_p AS 'Precio', stock_p AS 'Stock'
FROM productos
INNER JOIN categorias ON productos.id_categoria = categorias.id_categoria
INNER JOIN condiciones ON productos.id_condicion = condiciones.id_condicion