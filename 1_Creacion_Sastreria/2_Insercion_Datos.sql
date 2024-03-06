USE Sastreria

--DROP TABLE recibos;
--DROP TABLE detalles_ventas;
--DROP TABLE detalles_alquileres;
--DROP TABLE alquileres;
--DROP TABLE ventas;
--DROP TABLE detalles_pedidos;
--DROP TABLE productos_pedidos;
--DROP TABLE inferiores;
--DROP TABLE superiores;
--DROP TABLE pedidos;
--DROP TABLE transacciones;
--DROP TABLE comprobantes;
--DROP TABLE empleados;
--DROP TABLE clientes;
--DROP TABLE documentos;
--DROP TABLE generos;
--DROP TABLE productos;
--DROP TABLE condiciones;
--DROP TABLE categorias;
--DROP TABLE telas;
--DROP TABLE proveedores;

--Insercion de datos para la tabla proveedor
INSERT INTO proveedores VALUES
	('PRV-1', 'Telas Diluna', '74926483', 'La Victoria', '987127366', 'Rocio', 'rocio@diluna.com'),
	('PRV-2', 'Telas Lafayette Lima', '67926371', 'Surquillo', '947420958', 'Javier', 'javier@lafayette.com'),
	('PRV-3', 'Camisa Rey', '98026590', 'Santiago de Surco', '949217304', 'Ricardo', 'ricardo@camisa.com'),
	('PRV-4', 'Del Cuero', '12354729', 'Lurin', '849217666', 'Jose', 'jose@delcuero.com'),
	('PRV-5', 'Viste Bien', '38364900', 'San Juan', '200023947', 'Ana', 'ana@vistebien.com');

--Insercion de datos para la tabla documento
INSERT INTO documentos VALUES
	('DOC-1', 'DNI'),
	('DOC-2', 'Carnet de Extranjeria');

--Insercion de datos para la tabla genero
INSERT INTO generos VALUES
	('GEN-1', 'Masculino'),
	('GEN-2', 'Femenino'),
	('GEN-3', 'Otro');

--Insercion de datos para la tabla condicion
INSERT INTO condiciones VALUES 
	('CDN-1', 'Nuevo', 'Producto estreno'),
	('CDN-2', 'Usado', 'Producto para alquiler');

--Insercion de datos para la tabla categoria
INSERT INTO categorias VALUES
	('CTG-1', 'Terno Conjunto', 'Producto que se vende con el conjunto completo'),
	('CTG-2', 'Saco de Terno', 'Producto que se vende solo el saco'),
	('CTG-3', 'Camisa', 'Producto de camisa unica'),
	('CTG-4', 'Corbata', 'Producto de corbata unica'),
	('CTG-5', 'Correa', 'Producto de corbata unica'),
	('CTG-6', 'Zapato', 'Producto par de zapato');

--Insercion de datos para la tabla empleado
INSERT INTO empleados VALUES
	('EMP-1', 'Administrador','Andre Rodriguez', 'GEN-1', 'DOC-1', '72670549', '922047577', 'Av. Los Alamos 437', 'andre601@outlook.es', CONVERT(varbinary(255), 'kiro01', 0)),
	('EMP-2', 'Usuario','Christian Angeles', 'GEN-1', 'DOC-1', '05497267', '757792204', 'Av. Alamos 437', 'andre520sif@outlook.es', CONVERT(varbinary(255), 'benito01', 0));

--Insercion de datos para la tabla cliente
INSERT INTO clientes VALUES
	('CLI-1', 'Jair Lopez', 'GEN-1', 'DOC-1', '12345676', '99999999', 'lopez@gmail.com'),
	('CLI-2', 'Mercedes Pesantes', 'GEN-2', 'DOC-1', '12386676', '88888888', 'mercedes@gmail.com'),
	('CLI-3', 'Anjali Angeles', 'GEN-2', 'DOC-1', '34345676', '99977999', 'lopez626@gmail.com')

--Insercion de datos para la tabla producto
INSERT INTO productos VALUES
	('PRO-1', 'PRV-5','Saco Normal', 'Saco rojo talla S', 'S','CTG-2', 'CDN-1', 300, 10),
	('PRO-2', 'PRV-5', 'Camisa Morada Bersh', 'Morada doble cuello', 'L','CTG-3', 'CDN-1', 190, 10),
	('PRO-3', 'PRV-3', 'Corbata Mega Azul', '', 'M','CTG-4', 'CDN-1', 87, 10),
	('PRO-4', 'PRV-3', 'Terno azul entero', 'Usado anteriormente', 'M','CTG-3', 'CDN-2', 200, 10)

--Insercion de datos para la tabla comprobante
INSERT INTO comprobantes VALUES
	('CMP-1', 'Boleta'),
	('CMP-2', 'Factura')
--											***********SEPARADOR*************
--											***********SEPARADOR*************
INSERT INTO transacciones VALUES
	('T-1', 'Venta', CURRENT_TIMESTAMP)
--											***********SEPARADOR*************
--Insercion de datos para la tabla venta
INSERT INTO ventas VALUES
	('V-1', 'T-1','CLI-1', 'EMP-1', CURRENT_TIMESTAMP, 50 , 50 * 0.18, 50*0.18 + 50)

--Insercion de datos para la tabla detalle_venta
INSERT INTO detalles_ventas VALUES
	('V-1', 'PRO-2', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-2'), 1)

--Para modificar con los precios reales del detalle_venta hacia la tabla venta
UPDATE ventas
SET precio_base_v = (
    SELECT SUM(precio_u * cantidad_venta)
    FROM detalles_ventas
    WHERE detalles_ventas.id_venta = ventas.id_venta
)
WHERE ventas.id_venta = 'V-1';

--Para modificar la columna del impuesto de la tabla venta
UPDATE ventas
SET impuesto_v = (SELECT precio_base_v FROM ventas WHERE id_venta= 'V-1')*0.18
WHERE ventas.id_venta = 'V-1';

--Para modificar la columna del total de la tabla venta
UPDATE ventas
SET total_v = (
	(SELECT precio_base_v) + (SELECT impuesto_v)
)
WHERE ventas.id_venta = 'V-1';

--Insercion de precios para la tabla recibo despues de venta
INSERT INTO recibos VALUES
	('R-1', 'T-1', 'CMP-2', 'VVVV-VVVVVVVV', CURRENT_TIMESTAMP,
	(SELECT total_v FROM ventas WHERE id_venta = 'V-1'), (SELECT total_v FROM ventas WHERE id_venta = 'V-1')*0.18,
	(SELECT total_v FROM ventas WHERE id_venta = 'V-1')*0.18 + (SELECT total_v FROM ventas WHERE id_venta = 'V-1'), 'Pagado')

--											***********SEPARADOR*************
--											***********SEPARADOR*************
INSERT INTO transacciones VALUES
	('T-2', 'Alquiler', CURRENT_TIMESTAMP)
--											***********SEPARADOR*************
--Insercion de datos para la tabla alquiler
INSERT INTO alquileres VALUES
	('A-1', 'T-2','CLI-3', 'EMP-1', CURRENT_TIMESTAMP, 10, 10 * 0.18, 10 * 0.18 + 10)

--Insercion de datos para la tabla detalle_alquiler
INSERT INTO detalles_alquileres VALUES
	('A-1', 'PRO-1', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-1'), 1),
	('A-1', 'PRO-2', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-2'), 1),
	('A-1', 'PRO-4', (SELECT precio_p FROM productos WHERE id_producto = 'PRO-4'), 1)

--Para modificar con los precios reales del detalle_alquiler hacia la tabla alquiler
UPDATE alquileres
SET precio_base_a = (
    SELECT SUM(precio_u * cantidad_alquiler)
    FROM detalles_alquileres
    WHERE detalles_alquileres.id_alquiler = alquileres.id_alquiler
)
WHERE alquileres.id_alquiler = 'A-1';

--Para modificar la columna del impuesto de la tabla alquiler
UPDATE alquileres
SET impuesto_a = (SELECT precio_base_a FROM alquileres WHERE id_alquiler = 'A-1')*0.18
WHERE alquileres.id_alquiler = 'A-1';

--Para modificar la columna del total de la tabla alquiler
UPDATE alquileres
SET total_a = (
	(SELECT precio_base_a) + (SELECT impuesto_a)
)
WHERE alquileres.id_alquiler = 'A-1';

--Insercion de datos para la tabla recibo despues de alquiler
INSERT INTO recibos VALUES
	('R-2', 'T-2', 'CMP-2', 'AAAA-AAAAAAAA', CURRENT_TIMESTAMP,
	(SELECT total_a FROM alquileres WHERE id_alquiler = 'A-1'), (SELECT total_a FROM alquileres WHERE id_alquiler = 'A-1')*0.18,
	(SELECT total_a FROM alquileres WHERE id_alquiler = 'A-1')*0.18 + (SELECT total_a FROM alquileres WHERE id_alquiler = 'A-1'), 'Pagado')

--											***********SEPARADOR*************
--											***********SEPARADOR*************
INSERT INTO transacciones VALUES
	('T-3', 'Pedido', CURRENT_TIMESTAMP)
--											***********SEPARADOR*************
--insercion de tipos de productos para la tabla producto_pedido
INSERT INTO productos_pedidos VALUES
	('PRP-1', 'Chaleco', 'Prenda para torso'),
	('PRP-2', 'Blazer', 'Prenda estilo abrigo formal'),
	('PRP-3', 'Pantalon', 'Prenda formal para el inferior')

--Insercion de datos para la tabla pedido
INSERT INTO pedidos VALUES
	('P-1', 'T-3','CLI-3', 'EMP-2', CURRENT_TIMESTAMP, 'Para niño de 10 años', 600, 600*0.18, 600+600*0.18)

--Insercion de datos para la tabla detalle pedido
INSERT INTO detalles_pedidos VALUES
	('P-1', 'PRP-1', 'Con doble raya', 90),
	('P-1', 'PRP-2', 'Tricolor', 960)

--Insercion de datos para la tabla superior
INSERT INTO superiores VALUES 
	('P-1', 10, 60, 35, 19, 15, 60, 90, 100, 120)

--Insercion de datos para la tabla inferior
INSERT INTO inferiores VALUES 
	('P-1', 80, 80, 30, 30, 40)

	
--Insercion de datos para la tabla recibo despues de pedido
INSERT INTO recibos VALUES
	('R-3', 'T-3', 'CMP-1', 'PPPP-PPPPPPPP', CURRENT_TIMESTAMP,
	(SELECT total_p FROM pedidos WHERE id_pedido = 'P-1'), (SELECT total_p FROM pedidos WHERE id_pedido = 'P-1')*0.18,
	(SELECT total_p FROM pedidos WHERE id_pedido = 'P-1')*0.18 + (SELECT total_p FROM pedidos WHERE id_pedido = 'P-1'), 'Pagado')