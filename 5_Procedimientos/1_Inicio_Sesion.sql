USE SastreriaV1

SELECT * FROM empleados

DELETE empleados WHERE id_empleado LIKE 'E4'

INSERT INTO empleados VALUES
	('E3', 'ALEJANDro', 'G1', 'D1', '384873', '483722', 'Av. Torre 1', 'asAFFSas@HotMaiL.Ez', CONVERT(VARBINARY(255),'OrizONhshD', 0))
	--('E4', 'AlbertAA', 'G2', 'D1', '38442873', '412183722', 'Av. Solar 5', 'SolUYUw_@HotMaiL.ZzZ', CONVERT(VARBINARY(255),'gst4546rff', 0));


--DROP TRIGGER seguridad_contrase
--DROP TRIGGER entrada_cliente
--DROP TRIGGER entrada_empleado


--SELECT CONVERT(VARCHAR(255), password_e) FROM empleado


DECLARE @email VARCHAR(255);
SET @email = 'asAFFSas@HotMaiL.Ez'

DECLARE @contrasena VARCHAR(255);
SET @contrasena = 'OrizONhshD';

DECLARE	@valor VARBINARY(255);
SET @valor = CONVERT(VARBINARY(255), @contrasena, 0);

DECLARE @hash VARBINARY(255);
SET @hash = HASHBYTES('SHA2_512', @valor);

IF (SELECT password_e FROM empleados WHERE email_e = @email) LIKE @hash
	BEGIN
		PRINT 'Bienvenido Señor';
	END
ELSE
	BEGIN
		PRINT 'Atras Intruso';
	END


--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 
--DECLARE @cadena NVARCHAR(100);
--SET @cadena = 'Miiii';

--DECLARE @hash VARBINARY(255);
--SET @hash = HASHBYTES('SHA2_512', @cadena);

--SELECT @hash;