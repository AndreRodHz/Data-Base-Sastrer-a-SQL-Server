USE SastreriaV1


--PARA AGREGAR UN NUEVO CLIENTE
INSERT INTO clientes VALUES
	('CLI-90', 'Nombre', 'GEN-0', 'DOC-0', '1234567', '987654321', 'correo@yopmail.com')
  -- Codigo, Nombre, Genero, Documento, NumeroDoc, Telefono, Correo


--PARA MODIFICAR UN CLIENTE
UPDATE clientes 
	SET id_cliente = '',
		nombre_c = '',
		id_genero = '',
		id_documento = '',
		num_doc_c = '',
		telefono_c = '',
		email_c = ''
	WHERE id_cliente = 'CLI-90';


--PARA ELIMINAR UN CLIENTE
DELETE clientes WHERE id_cliente = 'CLI-90'


--PARA VER LA LISTA DE CLIENTES
SELECT id_cliente AS 'ID Cliente', nombre_c AS 'Nombre', nombre_gen AS 'Genero', nombre_doc AS 'Documento',
	   num_doc_c AS 'N° Documento', telefono_c AS 'Telefono', email_c AS 'Email'
FROM clientes
INNER JOIN generos ON clientes.id_genero = generos.id_genero
INNER JOIN documentos ON clientes.id_documento = documentos.id_documento
