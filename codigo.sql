-- Categorías de Platos
CREATE TABLE categorias_tb (
    categoriaID INT PRIMARY KEY,
	postre varchar(200),
    entrada VARCHAR(200),
	platoPrincipal varchar(200) not NULL 
);

-- Menús
CREATE TABLE Menu_tb (
    menuId serial PRIMARY KEY,
    nombre VARCHAR(100) not NULL, 
    precio double precision Not NULL,
    descripcion TEXT not NULL,
    categoria_ID INT not NULL,
    FOREIGN KEY (categoria_ID) REFERENCES categorias_tb(categoriaID) on delete cascade
);

-- Clientes
CREATE TABLE clientes_tb (
    clienteID serial PRIMARY KEY,
    nombre VARCHAR(100) not NULL,
    direccion TEXT not NULL,
    informacionContacto VARCHAR(100)
);

-- Pedidos
CREATE TABLE pedido_tb (
    pedidoID serial PRIMARY KEY,
    fecha DATE not NULL,
    hora TIME not NULL,
    estadoPedido VARCHAR(50) not NULL,
    cliente_ID INT not NULL,
	menu_id INT not NULL,
    FOREIGN KEY (cliente_ID) REFERENCES clientes_tb(clienteID) on delete restrict,
	FOREIGN KEY (menu_id) REFERENCES Menu_tb(menuId) on delete restrict
);

-- Sucursales
CREATE TABLE sucursal_tb (
    sucursalID serial PRIMARY KEY,
    direccion TEXT not NULL,
   	horarioAtencion VARCHAR(50) not NULL,
    capacidad INT not NULL check (capacidad<=30)
);

-- Empleados
CREATE TABLE empleados_tb (
    empleadoID serial PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    horario VARCHAR(50) NOT NULL,
    sucursal_ID INT NOT NULL,
    FOREIGN KEY (Sucursal_ID) REFERENCES sucursal_tb(sucursalID) on delete cascade
);

-- Ingredientes
CREATE TABLE ingredientes_tb (
    ingredienteID serial PRIMARY KEY,
    nombre VARCHAR(100) not NULL,
    proveedor VARCHAR(100),
    costo double precision NOT NULL
);
create table ingreXplatos_tb(
	ingreXplatos serial PRIMARY KEY,
	menu_id int,
	ingrediente_id int,
	foreign key (menu_id) references Menu_tb(menuid) on delete restrict,
	foreign key (ingrediente_id) references ingredientes_tb(ingredienteID) on delete restrict

);

-- Reservas
CREATE TABLE Reservas_tb (
    reservaID serial PRIMARY KEY,
    fecha DATE not NULL,
    hora TIME not NULL,
    cliente_ID INT,
    sucursal_ID INT,
    FOREIGN KEY (cliente_ID) REFERENCES clientes_tb(clienteID) on delete restrict,
    FOREIGN KEY (sucursal_ID) REFERENCES sucursal_tb(sucursalID) on delete restrict
);
-- esta funcion verifica que la capacidad de las sucursales no haya sido sobrepasada 
CREATE FUNCTION verificarCapacidad() 
RETURNS TRIGGER AS $$
DECLARE
    total INT; --declaramos dos variables total sera el total de reservas
    capacidadT int; -- y capacidad sera la capacidad que admite la sucursal
BEGIN
-- aqui llenamos la variable total haciendo un conteo de todas las reservas de la misma sucursal y que coincida la fecha y la hora
    SELECT COUNT(*) INTO total 
    FROM Reservas_tb 
    WHERE sucursal_ID = NEW.sucursal_ID 
    AND hora = NEW.hora 
    AND fecha = NEW.fecha;
-- y aqui llenamos la variable capacidadT de la sucursal mencionada
    SELECT capacidad into capacidadT from sucursal_tb WHERE NEW.sucursal_ID=sucursalID;
    -- si el total es mayor que la capacidad lanzamos una exepcion cancelando la inserción o actualizacion
	IF total >= capacidadT THEN
        RAISE EXCEPTION 'Reservas agotadas';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- llamamos a esa funcion en este trigger
CREATE TRIGGER comprobarReservas
BEFORE INSERT OR UPDATE ON Reservas_tb
FOR EACH ROW
EXECUTE FUNCTION verificarCapacidad();
-- creamos una vista materializada que muestre la cantidad de reservas de los clientes 
CREATE MATERIALIZED VIEW ReservasPorCliente AS
SELECT c.clienteID, c.nombre, COUNT(r.reservaID) AS cantidad_reservas
FROM clientes_tb c
LEFT JOIN Reservas_tb r ON c.clienteID = r.cliente_ID
GROUP BY c.clienteID, c.nombre order by c.clienteid, c.nombre;

-- Crear usuarios
CREATE ROLE gerente LOGIN PASSWORD 'gerente123';
CREATE ROLE chef LOGIN PASSWORD 'bestoChef';
CREATE ROLE trabajador LOGIN PASSWORD 'trabajador123';

-- Asignar permisos al gerente
GRANT ALL PRIVILEGES ON DATABASE cadenaRestaurante TO gerente;

-- Asignar permisos al chef
GRANT SELECT, INSERT ON TABLE Menu_tb TO chef;
GRANT SELECT, INSERT ON TABLE pedido_tb TO chef;
GRANT SELECT, INSERT ON TABLE ingreXplatos_tb TO chef;

-- Asignar permisos al trabajador
GRANT SELECT, UPDATE ON TABLE ingredientes_tb  TO trabajador;
GRANT SELECT, INSERT, UPDATE ON TABLE Reservas_tb TO trabajador;
GRANT SELECT, INSERT ON TABLE pedido_tb TO trabajador;
-- llenado de las tablas
--cliente:
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES
('Juan Pérez', '123 Calle Ficticia, Ciudad Imaginaria, 45678', 'juan.perez@example.com'),
('Ana Gómez', '456 Avenida Inventada, Pueblo Inventado, 12345', 'ana.gomez@example.com'),
('Luis Ramírez', '789 Ronda de Ejemplo, Villa Ejemplar, 67890', 'luis.ramirez@example.com');

INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES
('Carlos Martínez', '1010 Calle de la Luz, Ciudad Solar, 11223', 'carlos.martinez@example.com'),
('Isabel Sanz', '2020 Avenida del Río, Pueblo Fluvial, 22446', 'isabel.sanz@example.com'),
('Miguel Ángel Torres', '3030 Camino de la Montaña, Villa Altura, 33669', 'miguel.torres@example.com'),
('Sofía Navarro', '4040 Vía Láctea, Ciudad Estelar, 44882', 'sofia.navarro@example.com'),
('Ricardo Núñez', '5050 Ruta del Sol, Pueblo Solar, 55095', 'ricardo.nunez@example.com'),
('Elena Prieto', '6060 Calle de la Luna, Ciudad Lunar, 66308', 'elena.prieto@example.com'),
('Jorge Vázquez', '7070 Paseo de los Cometas, Villa Cósmica, 77521', 'jorge.vazquez@example.com'),
('Laura García', '8080 Sendero del Bosque, Pueblo Verde, 88734', 'laura.garcia@example.com'),
('Óscar Gutiérrez', '9090 Camino de la Playa, Villa Marina, 99047', 'oscar.gutierrez@example.com'),
('Teresa Fernández', '10010 Ronda de la Aurora, Ciudad Boreal, 101010', 'teresa.fernandez@example.com');

INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES
('Roberto López', '1111 Calle del Mar, Ciudad Costera, 12121', 'roberto.lopez@example.com'),
('Patricia Molina', '2222 Avenida de los Árboles, Pueblo Forestal, 23232', 'patricia.molina@example.com'),
('Francisco Vidal', '3333 Camino de la Colina, Villa Colinas, 34343', 'francisco.vidal@example.com'),
('Lucía Méndez', '4444 Paseo de la Cascada, Ciudad Fluvial, 45454', 'lucia.mendez@example.com'),
('Sergio Pinto', '5555 Ruta de la Sierra, Pueblo Montañoso, 56565', 'sergio.pinto@example.com'),
('Carmen Ruiz', '6666 Callejón del Valle, Villa del Valle, 67676', 'carmen.ruiz@example.com'),
('Fernando Castillo', '7777 Avenida del Puerto, Ciudad Portuaria, 78787', 'fernando.castillo@example.com'),
('Diana Jiménez', '8888 Sendero de la Aurora, Pueblo Boreal, 89898', 'diana.jimenez@example.com'),
('Álvaro Domínguez', '9999 Camino de la Estrella, Villa Estelar, 90909', 'alvaro.dominguez@example.com'),
('Mónica Sancho', '101010 Vía de la Galaxia, Ciudad Galáctica, 101212', 'monica.sancho@example.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Mario Bros', '123 Reino Champiñón', 'mario@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Luigi Bros', '124 Reino Champiñón', 'luigi@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Peach Toadstool', '1 Castillo de Peach', 'princesapeach@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Toad', '221 Calle Toad', 'toad@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Yoshi', '302 Isla Yoshi', 'yoshi@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Bowser', '666 Valle Koopa', 'bowser@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Donkey Kong', '408 Jungla DK', 'dk@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Wario', '777 Montaña Wario', 'wario@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Waluigi', '778 Montaña Wario', 'waluigi@nintendo.com');
INSERT INTO clientes_tb (nombre, direccion, informacionContacto) VALUES ('Daisy', '2 Castillo de Peach', 'princesadaisy@nintendo.com');
-- sucursal:
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('123 Calle Ficticia', '08:00 - 22:00', 25);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('456 Avenida Imaginaria', '10:00 - 20:00', 30);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('789 Bulevar Inventado', '11:00 - 23:00', 20);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('321 Callejón Secreto', '09:00 - 21:00', 15);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('654 Plaza Central', '07:00 - 19:00', 30);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('987 Camino Escondido', '12:00 - 00:00', 22);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('246 Ruta del Sabor', '06:00 - 18:00', 18);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('135 Avenida del Sol', '10:00 - 22:00', 28);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('864 Calle de la Luna', '13:00 - 01:00', 30);
INSERT INTO sucursal_tb (direccion, horarioAtencion, capacidad) VALUES ('753 Parque de las Delicias', '08:00 - 20:00', 24);
-- reservas:
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-10', '18:00', 1, 1);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-11', '19:00', 2, 2);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-12', '20:00', 3, 3);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-13', '21:00', 4, 4);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-14', '17:00', 5, 5);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-15', '16:00', 6, 6);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-16', '15:00', 7, 7);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-17', '14:00', 8, 8);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-18', '13:00', 9, 9);
INSERT INTO Reservas_tb (fecha, hora, cliente_ID, sucursal_ID) VALUES ('2024-04-19', '12:00', 10, 10);


