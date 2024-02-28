
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

SELECT * FROM tb_clientes;


-- creacion de procedimiento almacenado para poder insertar datos en la tabla de prestamos
DELIMITER // 
CREATE PROCEDURE insertar_datos_prestamo(
	 IN nombre_cliente VARCHAR(50),
    IN fecha_inicio DATE,
    IN fecha_devolucion DATE,
    IN estado ENUM('Activo','inactivo')
)
BEGIN
	DECLARE id_cliente BINARY(36);
	
	SET id_cliente = (SELECT id_cliente FROM tb_clientes WHERE nombre_cliente = nombre_cliente LIMIT 1);

    INSERT INTO tb_prestamos (id_cliente, fecha_inicio, fecha_devolucion, estado)
    VALUES (id_cliente, fecha_inicio, fecha_devolucion,estado );
END//
DELIMITER ;

INSERT INTO tb_prestamos (id_cliente, fecha_inicio, fecha_devolucion, estado)
    VALUES ('7573ae86-d662-11ee-9216-b04f130833dc', '2022-03-26', '2022-03-30','Activo' );
    
CALL insertar_datos_prestamo ('Samuel','2022-03-26','2022-03-30','Activo');

SELECT * FROM tb_prestamos;

