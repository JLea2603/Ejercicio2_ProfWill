
DROP DATABASE if EXISTS db_LibroExpress;

CREATE DATABASE db_LibroExpress;

USE db_LibroExpress;

CREATE TABLE tb_clientes(
id_cliente BINARY(36) PRIMARY KEY DEFAULT UUID(),
nombre_cliente VARCHAR(50) NOT NULL,
email_cliente VARCHAR(100) NOT NULL,
telefono VARCHAR(10)
);

-- restriccion para la tabla tb_clientes

ALTER TABLE tb_clientes ADD 
CONSTRAINT unique_email
UNIQUE (email_cliente);

ALTER TABLE tb_clientes ADD 
CONSTRAINT unique_telefono
UNIQUE (telefono);

CREATE TABLE tb_prestamos(
id_prestamo BINARY(36) PRIMARY KEY DEFAULT UUID(),
id_cliente BINARY(36),
CONSTRAINT fk_id_cliente 
FOREIGN KEY (id_cliente)
REFERENCES tb_clientes(id_cliente),
fecha_inicio DATE,
fecha_devolucion DATE,
estado ENUM('Activo','inactivo')
);

CREATE TABLE tb_generos_libros(
id_genero_libro BINARY(36) PRIMARY KEY DEFAULT UUID(),
nombre_genero_libro VARCHAR(50)
);

CREATE TABLE tb_libros(
id_libro BINARY(36) PRIMARY KEY DEFAULT UUID(),
titulo_libro VARCHAR(50),
anio_publicacion DATE,
id_genero_libro BINARY,
CONSTRAINT fk_id_genero_libro
FOREIGN KEY (id_genero_libro)
REFERENCES tb_generos_libros(id_genero_libro),
estado ENUM('Disponible','Prestado')
);

CREATE TABLE tb_detalle_prestamos(
id_detalle_prestamo BINARY(36) PRIMARY KEY DEFAULT UUID(),
id_prestamo BINARY(36),
CONSTRAINT fk_id_prestamo
FOREIGN KEY (id_prestamo)
REFERENCES tb_prestamos(id_prestamo),
id_libro BINARY(36),
CONSTRAINT fk_id_libro
FOREIGN KEY (id_libro)
REFERENCES tb_libros(id_libro)
);


-- creacion de TRIGGER

DELIMITER //
CREATE TRIGGER actualizar_estado_libro
AFTER INSERT ON tb_prestamos
FOR EACH ROW
BEGIN
    UPDATE tb_libros
    SET estado = 'Prestado'
    WHERE id_libro = id_libro;
END//
DELIMITER ;

-- creacion de procedimiento almacenado para poder insertar datos en la tabla de clientes
DELIMITER // 
CREATE PROCEDURE insertar_datos_cliente(
    IN nombre_cliente VARCHAR(50),
    IN email_cliente VARCHAR(100),
    IN telefono VARCHAR(10)
)
BEGIN
    INSERT INTO tb_clientes (nombre_cliente, email_cliente, telefono)
    VALUES (nombre_cliente, email_cliente, telefono);
END//
DELIMITER ;

CALL insertar_datos_cliente ('Mumble','patito@gmail.com','6126-8595');
CALL insertar_datos_cliente ('Axel','Axelito@gmail.com','8525-2521');
CALL insertar_datos_cliente ('Robert','IronMan@gmail.com','1212-1212');
CALL insertar_datos_cliente ('Samuel','vegetta777@gmail.com','1111-1111');
CALL insertar_datos_cliente ('Veronica','Veronica@gmail.com','1234-6874');
CALL insertar_datos_cliente ('Leandro','Leandro@gmail.com','9876-5432');
CALL insertar_datos_cliente ('Alejandro','Alejandro@gmail.com','7485-9685');
CALL insertar_datos_cliente ('Samantha','riversgg@gmail.com','2225-5555');
CALL insertar_datos_cliente ('Trevinio','Samantha@gmail.com','2121-2828');
CALL insertar_datos_cliente ('Luis','Luis@gmail.com','7878-7878');
CALL insertar_datos_cliente ('Roberto','Roberto@gmail.com','5689-9652');
CALL insertar_datos_cliente ('Sonia','Sonia@gmail.com','3333-3333');
CALL insertar_datos_cliente ('Liseth','Liseth@gmail.com','2603-20022');
CALL insertar_datos_cliente ('Lucas','Lucas@gmail.com','3101-2006');
CALL insertar_datos_cliente ('Benjamin','Benjamin@gmail.com','2008-1998');
CALL insertar_datos_cliente ('Alejandra','Alejandra@gmail.com','2412-2009');

-- DELETE FROM tb_clientes WHERE nombre_cliente = 'Treviño';

SELECT * FROM tb_clientes;


-- creacion de procedimiento almacenado para poder insertar datos en la tabla de prestamos
DELIMITER // 
CREATE PROCEDURE insertar_datos_prestamo(nombreCliente VARCHAR(50),fecha_inicio DATE,fecha_devolucion DATE,estado ENUM('Activo','inactivo'))
BEGIN
	DECLARE clienteID BINARY(36);
	
	SET clienteID = (SELECT id_cliente FROM tb_clientes WHERE nombre_cliente = nombreCliente LIMIT 1);

    INSERT INTO tb_prestamos (id_cliente, fecha_inicio, fecha_devolucion, estado)
    VALUES (clienteID, fecha_inicio, fecha_devolucion,estado );
END//
DELIMITER ;


CALL insertar_datos_prestamo ('Samuel','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Mumble','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Axel','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Robert','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Veronica','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Leandro','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Alejandra','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Samantha','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Trevinio','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Luis','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Roberto','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Sonia','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Liseth','2022-03-26','2022-03-30','Activo');
CALL insertar_datos_prestamo ('Lucas','2022-03-26','2022-03-30','inactivo');
CALL insertar_datos_prestamo ('Benjamin','2022-03-26','2022-03-30','Activo');

SELECT * FROM tb_prestamos;


-- creacion de procedimiento almacenado para poder insertar datos en la tabla de generos_libros

DELIMITER // 
CREATE PROCEDURE insertar_datos_tabla_generos(
    IN nombre_genero_libro VARCHAR(50)
)
BEGIN
    INSERT INTO tb_generos_libros (nombre_genero_libro)
    VALUES (nombre_genero_libro);
END//
DELIMITER ;

CALL insertar_datos_tabla_generos('Cuentos');
CALL insertar_datos_tabla_generos('Epopeya');
CALL insertar_datos_tabla_generos('Novela');
CALL insertar_datos_tabla_generos('Poema epico');
CALL insertar_datos_tabla_generos('Ficcion');
CALL insertar_datos_tabla_generos('Accion');
CALL insertar_datos_tabla_generos('Aventuras');
CALL insertar_datos_tabla_generos('Misterios');
CALL insertar_datos_tabla_generos('Terror');
CALL insertar_datos_tabla_generos('Thriller');
CALL insertar_datos_tabla_generos('Ciencia ficcion');
CALL insertar_datos_tabla_generos('Infantiles');
CALL insertar_datos_tabla_generos('Juveniles');
CALL insertar_datos_tabla_generos('Historicos');
CALL insertar_datos_tabla_generos('Horror');

SELECT * FROM tb_generos_libros;


-- creacion de procedimiento almacenado para poder insertar datos en la tabla de libros

DELIMITER //
CREATE PROCEDURE insertar_datos_libros(
    IN nombreGeneroParam VARCHAR(50),
    IN titulo_libro VARCHAR(50),
    IN anio_publicacion DATE,
    IN estado ENUM('Disponible', 'Prestado')
)
BEGIN 
    DECLARE id_genero_libro BINARY(36);
    
    SET id_genero_libro = (SELECT id_genero_libro FROM tb_generos_libros WHERE nombre_genero_libro = nombreGeneroParam LIMIT 1);
    
    INSERT INTO tb_libros (id_genero_libro, titulo_libro, anio_publicacion, estado)
    VALUES (id_genero_libro, titulo_libro, anio_publicacion, estado);
END//
DELIMITER ;


CALL insertar_datos_libros('Aventuras', 'Muerte en el nilo', '1937-11-01', 'Disponible');

SELECT * FROM tb_libros;

-- creacion de procedimiento almacenado para poder ver los valores de la tabla detalle_prestamos
DELIMITER //
CREATE PROCEDURE AgregarDetallesPrestamo(nombre_cliente VARCHAR(50), tituloLibro VARCHAR(100))
BEGIN
  DECLARE cliente_id BINARY(36);
  DECLARE prestamo_id BINARY(36);
  DECLARE libros_id BINARY(36);
    
    -- Encierra la consulta SELECT entre paréntesis
   SET cliente_id = (SELECT id_cliente FROM tb_clientes WHERE nombre_cliente = nombre_cliente);
   SET prestamo_id = (SELECT id_prestamo FROM tb_prestamos WHERE id_cliente = cliente_id);
   
   SET libros_id = (SELECT id_libros FROM tb_libros WHERE titulo_libro = tituloLibro);
   
 
   INSERT INTO tb_detalles_prestamos(id_prestamo, id_libros) VALUES (prestamo_id, libros_id);
 
END //
DELIMITER ;

-- Llamada al procedimiento para generar un nuevo detalle de préstamo
CALL AgregarDetallesPrestamo('Samuel', 'Muerte en el nilo');

-- Verificar los datos en la tabla tb_detalle_prestamos
SELECT * FROM tb_detalle_prestamos;
