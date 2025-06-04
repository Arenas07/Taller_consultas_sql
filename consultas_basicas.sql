USE ejercicios_consultas;
ALTER DATABASE ejercicios_consultas
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

ALTER TABLE productos   
CONVERT TO CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

SHOW TABLE STATUS FROM ejercicios_consultas;



-- 1. Consulta todos los datos de la tabla `usuarios` para ver la lista completa de clientes.
SELECT * 
FROM usuarios 
WHERE tipo_id = 1;

-- 2. Muestra los nombres y correos electrónicos de todos los clientes que residen en la ciudad de Madrid.

SELECT nombre, email 
FROM usuarios 
WHERE ciudad = 'Madrid' AND tipo_id = 1;

-- 3. Obtén una lista de productos con un precio mayor a $100.000, mostrando solo el nombre y el precio.

SELECT nombre, precio 
FROM productos 
WHERE precio > 100000;

-- 4. Encuentra todos los empleados que tienen un salario superior a $2.500.000, mostrando su nombre, puesto y salario.

SELECT * FROM empleados AS e
INNER JOIN usuarios AS u ON u.usuario_id = e.usuario_id
WHERE salario > 2500000 AND u.tipo_id = 2;

-- 5. Lista los nombres de los productos en la categoría "Electrónica", ordenados alfabéticamente.

SELECT nombre 
FROM productos
WHERE categoria = 'Electrónica' 
ORDER BY nombre ASC;

-- 6. Muestra los detalles de los pedidos que están en estado "Pendiente", incluyendo el ID del pedido, el ID del cliente y la fecha del pedido.

SELECT pedido_id, cliente_id, fecha_pedido 
FROM pedidos 
WHERE estado = 'Pendiente';

-- 7. Encuentra el nombre y el precio del producto más caro en la base de datos.

SELECT nombre, precio 
FROM productos
ORDER BY precio DESC
LIMIT 1;

-- 8. Obtén el total de pedidos realizados por cada cliente, mostrando el ID del cliente y el total de pedidos.


SELECT u.usuario_id, u.nombre, SUM(dp.cantidad * dp.precio_unitario)
FROM usuarios AS u
INNER JOIN pedidos AS p ON u.usuario_id = p.cliente_id
INNER JOIN detalles_pedidos AS dp ON p.pedido_id = dp.pedido_id
GROUP BY u.usuario_id, u.nombre;

-- 9. Calcula el promedio de salario de todos los empleados en la empresa.

SELECT AVG(salario) AS promedio_salario
FROM empleados

-- 10. Encuentra el número de productos en cada categoría, mostrando la categoría y el número de productos.

SELECT categoria, COUNT(categoria) AS cantidad 
FROM productos
GROUP BY categoria;

-- 11. Obtén una lista de productos con un precio mayor a $75 USD, mostrando solo el nombre, el precio y su respectivo precio en USD.

SELECT nombre, precio AS precio_cop, (precio/4100) AS precio_usd FROM productos WHERE (precio/4100) > 75

-- 12. Lista todos los proveedores registrados.

SELECT * FROM proveedores;
