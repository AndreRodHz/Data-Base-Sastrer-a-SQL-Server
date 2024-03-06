Hola, bienvenido!

El presente proyecto es el primero que estoy realizando para mi portafolio.
En esta ocasión estoy usando SQL y Transact SQL en el gestor de Microsoft, SQL Server.
A continuación podrá ver funciones, triggers, procedimientos almacenados, vistas, entre otras.

Explicaré el contexto de esta base de datos.
Está pensado en torno a una Sastrería, un lugar comercial donde se vende, alquila y se aceptan pedidos a medida de vestimentas formales para varones.
El proceso que considero el núcleo de esta base de datos, está en la relación de las tablas Venta, Alquiler y Pedido con la tabla Recibo.
Al momento de realizar cualquiera de estas acciones (Venta, Alquiler o Pedido), se genera un identificador previamente en la tabla Transacción.
Luego, dicha tabla Transacción se vincula con la tabla recibo. 
De esta forma aseguramos la integridad de los datos insertados en estas tablas.

Le invito que dé un vistazo a las diferentes querys con Transact-SQL, enfocándose en la automatización de procesos.
Saludos.