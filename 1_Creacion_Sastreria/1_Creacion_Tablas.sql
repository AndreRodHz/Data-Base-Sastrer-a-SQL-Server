USE Sastreria

DROP TABLE recibos;
DROP TABLE detalles_ventas;
DROP TABLE detalles_alquileres;
DROP TABLE alquileres;
DROP TABLE ventas;
DROP TABLE detalles_pedidos;
DROP TABLE productos_pedidos;
DROP TABLE inferiores;
DROP TABLE superiores;
DROP TABLE pedidos;
DROP TABLE transacciones;
DROP TABLE comprobantes;
DROP TABLE empleados;
DROP TABLE clientes;
DROP TABLE documentos;
DROP TABLE generos;
DROP TABLE productos;
DROP TABLE condiciones;
DROP TABLE categorias;
DROP TABLE proveedores;

CREATE TABLE proveedores(
	id_proveedor VARCHAR(15) PRIMARY KEY,
	razon_social VARCHAR(50) NOT NULL,
	ruc_prov VARCHAR(15) NOT NULL,
	dir_prov VARCHAR(255),
	telef_prov VARCHAR(10),
	contacto VARCHAR(50),
	correo_prov VARCHAR(255),
	CONSTRAINT UQ_ruc_proveedor UNIQUE(ruc_prov)
)

CREATE TABLE categorias(
	id_categoria VARCHAR(15) PRIMARY KEY,
	nombre_cate VARCHAR(50) NOT NULL,
	descrip_cate VARCHAR(255)
)

CREATE TABLE condiciones(
	id_condicion VARCHAR(15) PRIMARY KEY,
	nombre_condi VARCHAR(50) NOT NULL,
	descrip_condi VARCHAR(255)
)

CREATE TABLE productos(
	id_producto VARCHAR(15) PRIMARY KEY,
	id_proveedor VARCHAR(15) NOT NULL	,
	nombre_p VARCHAR(50) NOT NULL,
	descrip_p VARCHAR(255),
	talla VARCHAR(15) NOT NULL,
	id_categoria VARCHAR(15) NOT NULL,
	id_condicion VARCHAR(15) NOT NULL,
	precio_p NUMERIC(18,2) NOT NULL,
	stock_p INT NOT NULL,
	FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
	FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
	FOREIGN KEY (id_condicion) REFERENCES condiciones(id_condicion),
	CONSTRAINT CK_precio_no_negativo CHECK(precio_p >= 0),
	CONSTRAINT CK_cantidad_no_negativo CHECK(stock_p >= 0)
)
	
CREATE TABLE generos(
	id_genero VARCHAR(15) PRIMARY KEY,
	nombre_gen VARCHAR(50) NOT NULL,
)

CREATE TABLE documentos(
	id_documento VARCHAR(15) PRIMARY KEY,
	nombre_doc VARCHAR(50) NOT NULL,
)

CREATE TABLE clientes(
	id_cliente VARCHAR(15) PRIMARY KEY,
	nombre_c VARCHAR(50) NOT NULL,
	id_genero VARCHAR(15) NOT NULL,
	id_documento VARCHAR(15) NOT NULL,
	num_doc_c VARCHAR(20) NOT NULL,
	telefono_c VARCHAR(15),
	email_c VARCHAR(255),
	FOREIGN KEY (id_genero) REFERENCES generos(id_genero),
	FOREIGN KEY (id_documento) REFERENCES documentos(id_documento),
	CONSTRAINT UQ_num_doc_cliente UNIQUE(num_doc_c)
)

CREATE TABLE empleados(
	id_empleado VARCHAR(15) PRIMARY KEY,
	tipo_e VARCHAR(20) NOT NULL,
	nombre_e VARCHAR(50) NOT NULL,
	id_genero VARCHAR(15) NOT NULL,
	id_documento VARCHAR(15) NOT NULL,
	num_doc_e VARCHAR(20) NOT NULL,
	telefono_e VARCHAR(15) NOT NULL,
	direccion_e VARCHAR(255),
	email_e VARCHAR(255) NOT NULL,
	password_e VARBINARY(255) NOT NULL,
	FOREIGN KEY (id_genero) REFERENCES generos(id_genero),
	FOREIGN KEY (id_documento) REFERENCES documentos(id_documento),
	CONSTRAINT UQ_num_doc_empleado UNIQUE(num_doc_e),
	CONSTRAINT UQ_email_empleado UNIQUE(email_e)
)

CREATE TABLE comprobantes(
	id_comprobante VARCHAR(15) PRIMARY KEY,
	nombre_com VARCHAR(50)
)

CREATE TABLE productos_pedidos(
	id_prod_pedi VARCHAR(15) PRIMARY KEY,
	nombre_pp VARCHAR(50) NOT NULL,
	descripcion_pp VARCHAR(255)
)

--											***********SEPARADOR*************
CREATE TABLE transacciones(
	id_transac VARCHAR(15) PRIMARY KEY,
	tipo_transac VARCHAR(25) NOT NULL,
	fecha_t DATETIME NOT NULL
)
--											***********SEPARADOR*************
CREATE TABLE pedidos(
	id_pedido VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_cliente VARCHAR(15) NOT NULL,
	id_empleado VARCHAR(15) NOT NULL,
	fecha_p DATETIME NOT NULL,
	descrip VARCHAR(255),
	precio_base_p NUMERIC(18,2) NOT NULL,
	impuesto_p NUMERIC(18,2) NOT NULL,
	total_p NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transacciones(id_transac),
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
	FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
	CONSTRAINT UQ_pedido_transaccion UNIQUE(id_transac)
)

CREATE TABLE detalles_pedidos(
	id_pedido VARCHAR(15) NOT NULL,
	id_prod_pedi VARCHAR(15) NOT NULL,
	descrip VARCHAR(255),
	precio_d_pp NUMERIC(18,3) NOT NULL,
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
	FOREIGN KEY (id_prod_pedi) REFERENCES productos_pedidos(id_prod_pedi)
)

CREATE TABLE superiores(
	id_pedido VARCHAR(15),
	cuello NUMERIC(18,2),
	longitud NUMERIC(18,2),
	hombros NUMERIC(18,2),
	sisa NUMERIC(18,2),
	biceps NUMERIC(18,2),
	pecho NUMERIC(18,2),
	brazos NUMERIC(18,2),
	largo_cha NUMERIC(18,2),
	largo_abri NUMERIC(18,2),
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
	CONSTRAINT UQ_superior_pedido UNIQUE(id_pedido)
)

CREATE TABLE inferiores(
	id_pedido VARCHAR(15),
	caderas NUMERIC(18,2),
	largo NUMERIC(18,2),
	tiro NUMERIC(18,2),
	posicion NUMERIC(18,2),
	muslos NUMERIC(18,2),
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
	CONSTRAINT UQ_inferior_pedido UNIQUE(id_pedido)
)

CREATE TABLE ventas(
	id_venta VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_cliente VARCHAR(15) NOT NULL,
	id_empleado VARCHAR(15) NOT NULL,
	fecha_v DATETIME NOT NULL,
	precio_base_v NUMERIC(18,2) NOT NULL,
	impuesto_v NUMERIC(18,2) NOT NULL,
	total_v NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transacciones(id_transac),
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
	FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
	CONSTRAINT UQ_venta_transaccion UNIQUE(id_transac)
)

CREATE TABLE alquileres(
	id_alquiler VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_cliente VARCHAR(15) NOT NULL,
	id_empleado VARCHAR(15) NOT NULL,
	fecha_a DATETIME NOT NULL,
	precio_base_a NUMERIC(18,2) NOT NULL,
	impuesto_a NUMERIC(18,2) NOT NULL,
	total_a NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transacciones(id_transac),
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
	FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
	CONSTRAINT UQ_alquiler_transaccion UNIQUE(id_transac)
)

CREATE TABLE detalles_alquileres(
	id_alquiler VARCHAR(15) NOT NULL,
	id_producto VARCHAR(15) NOT NULL,
	precio_u NUMERIC(18,2) NOT NULL,
	cantidad_alquiler INT NOT NULL,
	FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler),
	FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
)

CREATE TABLE detalles_ventas(
	id_venta VARCHAR(15) NOT NULL,
	id_producto VARCHAR(15) NOT NULL,
	precio_u NUMERIC(18,2) NOT NULL,
	cantidad_venta INT NOT NULL,
	FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
	FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
)

CREATE TABLE recibos(
	id_recibo VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_comprobante VARCHAR(15) NOT NULL,
	num_comprobante VARCHAR(20) NOT NULL,
	fecha_recibo DATETIME NOT NULL,
	base_rec NUMERIC(18,2) NOT NULL,
	impuesto_rec NUMERIC(18,2) NOT NULL,
	total_rec NUMERIC(18,2) NOT NULL,
	estado varchar(20) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transacciones(id_transac),
	FOREIGN KEY (id_comprobante) REFERENCES comprobantes(id_comprobante),
	CONSTRAINT UQ_recibo_num_comprobante UNIQUE(num_comprobante),
	CONSTRAINT UQ_recibo_num_transaccion UNIQUE(id_transac)
)