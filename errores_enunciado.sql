-- Eliminar tablas si ya existen
DROP TABLE IF EXISTS DetallesDePedidos;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;

-- Crear tablas con datos de ejemplo
CREATE TABLE Clientes (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(50)
);
 
CREATE TABLE Productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    categoria VARCHAR(50),
    precio DECIMAL(10,2),
    stock INT,
    descripcion TEXT
);
 
CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    total DECIMAL(10,2),
    estado VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id)
);
 
CREATE TABLE DetallesDePedidos (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    descuento DECIMAL(5,2),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id),
    FOREIGN KEY (id_producto) REFERENCES Productos(id)
);
 
INSERT INTO Clientes (id, nombre, direccion, telefono, email)
VALUES
    (1, 'Juan Perez', 'Calle Falsa 123', '123456789', 'juan.perez@example.com'),
    (2, 'Maria Gomez', 'Avenida Siempre Viva 456', '987654321', 'maria.gomez@example.com'),
    (3, 'Carlos Ruiz', 'Boulevard de los Sueños 789', '555555555', 'carlos.ruiz@example.com');

INSERT INTO Productos (id, nombre, categoria, precio, stock, descripcion)
VALUES
    (1, 'Televisor', 'Electrónica', 500.00, 10, 'Televisor de 50 pulgadas'),
    (2, 'Lavadora', 'Electrodomésticos', 300.00, 5, 'Lavadora de carga frontal'),
    (3, 'Microondas', 'Electrodomésticos', 150.00, 8, 'Microondas con grill'),
    (4, 'Aspiradora', 'Hogar', 200.00, 7, 'Aspiradora sin bolsa'),
    (5, 'Heladera', 'Hogar', 1000.00, 3, 'Nevera con congelador');

INSERT INTO Pedidos (id, id_cliente, fecha, total, estado)
VALUES
    (1, 1, '2020-04-01', 1300.00, 'Completado'),
    (2, 2, '2020-04-15', 150.00, 'Completado'),
    (3, 3, '2020-04-20', 200.00, 'Completado'),
    (4, 1, '2020-04-25', 1000.00, 'Pendiente'),
    (5, 2, '2020-04-28', 1000.00, 'Pendiente');

INSERT INTO DetallesDePedidos (id_pedido, id_producto, cantidad, precio_unitario, descuento)
VALUES
    (1, 1, 1, 500.00, 0.00),
    (1, 2, 2, 300.00, 0.00),
    (2, 3, 1, 150.00, 0.00),
    (3, 4, 1, 200.00, 0.00),
    (4, 1, 2, 500.00, 0.00),
    (5, 5, 1, 1000.00, 0.00);
    
-- 1.  Muestra el nombre del cliente y el total de ventas, ordenando por total de ventas en orden descendente
SELECT nombre, SUM(precio_unitario * cantidad) AS total_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY nombre
ORDER BY total_ventas DESC
WHERE total_ventas > 1000;

-- 2. Muestra el nombre del cliente y el total de ventas, agrupando por nombre y total de ventas, ordenando por total de ventas en orden descendente
SELECT nombre, SUM(precio_unitario * cantidad) AS total_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY nombre, total_ventas
ORDER BY total_ventas DESC;

-- 3. Muestra el nombre del cliente y el total de ventas, agrupando por nombre y fecha, ordenando por total de ventas en orden descendente
SELECT c.nombre, SUM(dp.precio_unitario * dp.cantidad) AS total_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY c.nombre
HAVING total_ventas > 1000
ORDER BY total_ventas DESC;


-- 4. Muestra el nombre del cliente y el total de ventas, agrupando por nombre, ordenando por total de ventas en orden descendente y filtrando por total de ventas mayor a 1000
SELECT c.nombre, COUNT(p.id) AS numero_pedidos
FROM Clientes c
JOIN Pedidos p ON c.id = p.id_cliente
GROUP BY c.nombre
ORDER BY numero_pedidos;


-- 5. Muestra la fecha del pedido y el total de ventas, agrupando por fecha, ordenando por total de ventas en orden descendente y filtrando por total de ventas mayor a 500
SELECT c.nombre, AVG(SUM(dp.precio_unitario * dp.cantidad)) AS promedio_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY c.nombre
ORDER BY promedio_ventas DESC;

-- 6. Muestra el estado del pedido y el total de pedidos, agrupando por estado, ordenando por total de pedidos en orden descendente
SELECT c.nombre, SUM(dp.precio_unitario * dp.cantidad) AS total_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY c.nombre
HAVING total_ventas > 1000
ORDER BY total_ventas DESC;

-- 7. Muestra el nombre del cliente y el número de pedidos, agrupando por nombre, ordenando por número de pedidos en orden ascendente
SELECT p.fecha, SUM(dp.precio_unitario * dp.cantidad) AS total_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
GROUP BY p.fecha
ORDER BY total_ventas DESC
WHERE total_ventas > 500;

-- 8. Muestra el nombre del cliente y el número de productos diferentes comprados, agrupando por nombre, ordenando por número de productos diferentes en orden descendente
SELECT p.estado, COUNT(p.id) AS total_pedidos
FROM Pedidos p
GROUP BY p.estado
ORDER total_pedidos DESC;

-- 9. Muestra el nombre del cliente y el total de ingresos, agrupando por nombre, ordenando por total de ingresos en orden descendente
SELECT c.nombre, COUNT(DISTINCT dp.id_producto) AS productos_diferentes
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY c.nombre
ORDER BY productos_diferentes;


-- 10. Muestra el nombre del cliente y el total de ventas, cruzando las tablas Pedidos y DetallesDePedidos de manera errónea
SELECT c.nombre, SUM(dp.precio_unitario * dp.cantidad) AS total_ventas
FROM DetallesDePedidos dp
JOIN Pedidos p ON dp.id_pedido = p.id_pedido
JOIN Clientes c ON p.id_cliente = c.id
GROUP BY c.nombre
ORDER BY total_ventas DESC;