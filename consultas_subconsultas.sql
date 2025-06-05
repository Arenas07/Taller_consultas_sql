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

USE taller_consultas;
SELECT * 
FROM empleados

SELECT * 
FROM pedidos 
WHERE fecha_pedido BETWEEN DATE_ADD(CURDATE(), INTERVAL -6 MONTH) AND CURDATE();


SELECT * FROM pedidos;