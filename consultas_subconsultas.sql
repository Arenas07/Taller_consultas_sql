USE Taller_consultas;


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
FROM empleados AS e
WHERE e.empleado_id IN (
    SELECT pe.empleado_id
    FROM pedidos AS pe 
    WHERE fecha_pedido BETWEEN DATE_ADD(CURDATE(), INTERVAL -6 MONTH) AND CURDATE()
)


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


-- 6. Obtén los productos cuyo precio es superior al precio promedio de todos los productos.

SELECT pr.nombre, pr.precio
FROM productos AS pr
WHERE pr.precio > (
    SELECT AVG(pr.precio) AS precio_promedio  
    FROM productos AS pr
);
 
-- 7. Lista los clientes que han gastado más de $1.000.000 en total.

SELECT *
FROM usuarios
WHERE usuario_id IN (
    SELECT p.cliente_id
    FROM pedidos AS p
    INNER JOIN detalles_pedidos AS dp ON p.pedido_id = dp.pedido_id
    GROUP BY p.cliente_id
    HAVING SUM(dp.precio_unitario * dp.cantidad) > 1000000
);

-- 8. Encuentra los empleados que ganan un salario mayor al promedio de la empresa.


SELECT usuario_id, nombre, telefono, pais
FROM usuarios
WHERE usuario_id IN (
    SELECT e.empleado_id
    FROM empleados AS e
    WHERE salario > (
        SELECT AVG(salario) 
        FROM empleados	
    ) 
);

-- 9. Obtén los productos que generaron ingresos mayores al ingreso promedio por producto.

SELECT p.producto_id, p.nombre, SUM(dp.cantidad * dp.precio_unitario) AS ingresos 
FROM productos AS p
INNER JOIN detalles_pedidos AS dp ON p.producto_id = dp.producto_id
GROUP BY p.producto_id, p.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) > (
    SELECT AVG(total_ingresos) 
    FROM (
        SELECT SUM(dp.cantidad * dp.precio_unitario) AS total_ingresos
        FROM detalles_pedidos AS dp
        GROUP BY dp.producto_id
    ) AS ingresos_por_producto
);

-- 10. Encuentra el nombre del cliente que realizó el pedido más reciente.

SELECT u.*
FROM usuarios AS u
WHERE u.usuario_id = (
    SELECT pe.cliente_id 
    FROM pedidos AS pe 
    ORDER BY pe.fecha_pedido DESC
    LIMIT 1
) AND u.tipo_id = 1;

-- 11. Muestra los productos pedidos al menos una vez en los últimos 3 meses.

SELECT * 
FROM productos AS pr
INNER JOIN detalles_pedidos AS dp ON dp.producto_id = pr.producto_id
WHERE dp.pedido_id IN (
    SELECT pedido_id
    FROM pedidos 
    WHERE fecha_pedido BETWEEN DATE_ADD(CURDATE(), INTERVAL -3 MONTH) AND CURDATE()
);

-- 12. Lista los empleados que no han gestionado ningún pedido.

SELECT e.empleado_id, u.nombre AS empleado, e.puesto
FROM empleados AS e 
INNER JOIN usuarios AS u ON u.usuario_id = e.usuario_id
WHERE e.empleado_id IN (
    SELECT p.empleado_id
    FROM pedidos AS p
    WHERE p.empleado_id IS NULL
);


-- 13. Encuentra los clientes que han comprado más de tres tipos distintos de productos.

SELECT u.usuario_id, u.nombre
FROM usuarios AS u
WHERE u.tipo_id = 1 AND u.usuario_id IN (
      SELECT pe.cliente_id
      FROM pedidos AS pe
      INNER JOIN detalles_pedidos AS dp ON dp.pedido_id = pe.pedido_id
      GROUP BY pe.cliente_id
      HAVING COUNT(DISTINCT dp.producto_id) > 3
  );
