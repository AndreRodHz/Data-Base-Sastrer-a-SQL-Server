USE SastreriaV1

--PARA AGREGAR UN NUEVO EMPLEADO
INSERT INTO empleados VALUES
	('EMP-90', 'Nombre', 'GEN-0', 'DOC-0', '1234567', '987654321', 'Domicilio', 'correo@yopmail.com', CONVERT(VARBINARY(255), 'contraseña', 0));
--   Codigo, Nombre, Genero, Documento, NumDoc, Telefono,  Direccion,    Correo,             Constraseña


--PARA MODIFICAR UN EMPLEADO
UPDATE empleados
	SET id_empleado = '',
		nombre_e = '',
		id_genero = '',
		id_documento = '',
		num_doc_e = '',
		telefono_e = '',
		direccion_e = '',
		email_e = '',
		pASsword_e = ''
	WHERE id_empleado = 'EMP-1';


--PARA ELIMINAR UN EMPLEADO
delete empleados WHERE id_empleado = 'EMP-90'


--PARA VER LISTA DE EMPLEADOS
SELECT id_empleado AS 'ID Empleado', nombre_e AS 'Nombre', nombre_gen AS 'Genero', nombre_doc AS 'Documento',
	   num_doc_e AS 'N° Documento', telefono_e AS 'Telefono', direccion_e AS 'Domicilio', email_e AS 'Email'
FROM empleados
INNER JOIN generos ON empleados.id_genero = generos.id_genero
INNER JOIN documentos ON empleados.id_documento = documentos.id_documento
