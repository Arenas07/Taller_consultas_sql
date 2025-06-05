USE taller_consultas;


-- 1. Encuentra los nombres de los clientes que han realizado al menos un pedido de más de $500.000.

SELECT nombre
FROM usuarios
WHERE usuario_id IN
(SELECT cliente_id
FROM pedidos AS p
INNER JOIN detalles_pedidos AS dp ON p.pedido_id = dp.pedido_id
WHERE (dp.cantidad * dp.precio_unitario) > 500000
)

-- 2. Muestra los productos que nunca han sido pedidos.Muestra los productos que nunca han sido pedidos.

INSERT INTO productos (nombre, categoria, precio, stock)
VALUES ('Proyector HD', 'Electrónica', 1350000.00, 30);


SELECT pr.producto_id, pr.nombre, pr.categoria, pr.precio, pr.stock 
FROM productos AS pr
WHERE pr.producto_id NOT IN(
    SELECT dp.producto_id
    FROM detalles_pedidos AS dp
);

-- 3. Lista los empleados que han gestionado pedidos en los últimos 6 meses.

SELECT * 
FROM pedidos 
WHERE fecha_pedido BETWEEN DATE_ADD(CURDATE(), INTERVAL -6 MONTH) AND CURDATE();

-- 4. Encuentra el pedido con el total de ventas más alto.
USE trabajo_consultas;

SELECT pedido_id, total_venta
FROM (
    SELECT p.pedido_id, SUM(dp.cantidad * dp.precio_unitario) AS total_venta
    FROM detalles_pedidos AS dp
    INNER JOIN pedidos AS p ON p.pedido_id = dp.pedido_id
    GROUP BY p.pedido_id
) AS ventas_por_pedido
ORDER BY total_venta DESC
LIMIT 1;


-- 5. Muestra los nombres de los clientes que han realizado más pedidos que el promedio de pedidos de todos los clientes.

SELECT u.nombre, COUNT(pe.pedido_id) AS total_pedidos
FROM usuarios AS u
INNER JOIN pedidos AS pe ON pe.cliente_id = u.usuario_id
GROUP BY u.nombre
HAVING COUNT(pe.pedido_id) > (
    SELECT AVG(pedidos_cliente)
    FROM (
        SELECT COUNT(*) AS pedidos_cliente 
        FROM pedidos 
        GROUP BY cliente_id
    ) AS total
);
