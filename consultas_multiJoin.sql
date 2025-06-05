USE trabajo_consultas;

-- 1. Encuentra los nombres de los clientes y los detalles de sus pedidos.

SELECT u.nombre AS cliente, pr.nombre AS producto, pr.categoria, dp.cantidad
FROM usuarios AS u
INNER JOIN pedidos AS p ON u.usuario_id = p.cliente_id
INNER JOIN detalles_pedidos AS dp ON p.pedido_id = dp.pedido_id
INNER JOIN productos AS pr ON pr.producto_id = dp.producto_id
WHERE u.tipo_id = 1;

-- 2. Lista todos los productos pedidos junto con el precio unitario de cada pedido

SELECT p.nombre AS producto, dp.precio_unitario
FROM detalles_pedidos AS dp
INNER JOIN productos AS p ON p.producto_id = dp.producto_id;

-- 3. Encuentra los nombres de los clientes y los nombres de los empleados que gestionaron sus pedidos

SELECT u.nombre AS cliente, ue.nombre AS empleado
FROM pedidos AS p
INNER JOIN usuarios AS u ON u.usuario_id = p.cliente_id
INNER JOIN empleados AS e ON e.empleado_id = p.empleado_id
INNER JOIN usuarios AS ue ON ue.usuario_id = e.usuario_id;

-- 4. Muestra todos los pedidos y, si existen, los productos en cada pedido, incluyendo los pedidos sin productos usando `LEFT JOIN`

SELECT p.pedido_id, p.cliente_id, p.fecha_pedido, p.estado, dp.producto_id, dp.cantidad
FROM pedidos AS p
LEFT JOIN detalles_pedidos AS dp ON dp.pedido_id = p.pedido_id;

-- 5. Encuentra los productos y, si existen, los detalles de pedidos en los que no se ha incluido el producto usando `RIGHT JOIN`.

SELECT *
FROM detalles_pedidos AS dp
RIGHT JOIN productos AS p ON dp.producto_id = p.producto_id;

-- 6. Lista todos los empleados junto con los pedidos que han gestionado, si existen, usando `LEFT JOIN` para ver los empleados sin pedidos.

SELECT u.nombre AS empleado, p.pedido_id, p.estado
FROM empleados AS e
INNER JOIN usuarios AS u ON u.usuario_id = e.usuario_id
LEFT JOIN pedidos AS p ON p.empleado_id = e.empleado_id;

-- 7. Encuentra los empleados que no han gestionado ningún pedido usando un `LEFT JOIN` combinado con `WHERE`.

SELECT p.cliente_id, u.nombre AS empleado, p.pedido_id, p.estado
FROM empleados AS e
INNER JOIN usuarios AS u ON u.usuario_id = e.usuario_id
LEFT JOIN pedidos AS p ON p.empleado_id = e.empleado_id
WHERE p.estado = 'Pendiente';

-- 8. Calcula el total gastado en cada pedido, mostrando el ID del pedido y el total, usando `JOIN`.

SELECT p.pedido_id, SUM(dp.cantidad * dp.precio_unitario) AS total_gastado
FROM pedidos AS p
INNER JOIN detalles_pedidos AS dp ON p.pedido_id = dp.pedido_id
GROUP BY p.pedido_id;

-- 9. Realiza un `CROSS JOIN` entre clientes y productos para mostrar todas las combinaciones posibles de clientes y productos.

SELECT u.usuario_id, u.tipo_id, u.nombre AS cliente, p.producto_id, p.nombre AS producto, p.categoria, p.precio
FROM usuarios AS u
CROSS JOIN productos as p
WHERE u.tipo_id = 1 ;


-- 10. Encuentra los nombres de los clientes y los productos que han comprado, si existen, incluyendo los clientes que no han realizado pedidos usando `LEFT JOIN`.

SELECT u.usuario_id, u.nombre AS cliente, p.pedido_id, p.estado
FROM usuarios AS u
LEFT JOIN pedidos AS p ON u.usuario_id = p.cliente_id
WHERE u.tipo_id = 1;

-- 11. Listar todos los proveedores que suministran un determinado producto.

SELECT pp.proveedor_id, pp.producto_id, p.nombre AS nombre_proveedor, pr.nombre AS nombre_producto, pr.categoria, pr.precio, pr.stock
FROM proveedores_productos AS pp
JOIN proveedores AS p ON p.proveedor_id = pp.proveedor_id
JOIN productos AS pr ON pr.producto_id = pp.producto_id
WHERE pr.categoria = 'Electrónica';

-- 12. Obtener todos los productos que ofrece un proveedor específico.

SELECT pp.proveedor_id, pp.producto_id, p.nombre AS nombre_proveedor, pr.nombre AS nombre_producto, pr.categoria, pr.precio, pr.stock
FROM proveedores_productos AS pp
JOIN proveedores AS p ON p.proveedor_id = pp.proveedor_id
JOIN productos AS pr ON pr.producto_id = pp.producto_id
WHERE pp.proveedor_id = '1';

-- 13. Lista los proveedores que no están asociados a ningún producto (es decir, que aún no suministran).

SELECT pr.proveedor_id, pr.nombre AS nombre_proveedor, pr.email, pr.telefono, pr.direccion
FROM proveedores AS pr
LEFT JOIN proveedores_productos AS pp ON pr.proveedor_id = pp.proveedor_id
WHERE pp.proveedor_id IS NULL;    

-- 14. Contar cuántos proveedores tiene cada producto.

SELECT COUNT(pp.proveedor_id) AS proveedores_totales, pr.nombre
FROM productos AS pr        
LEFT JOIN proveedores_productos AS pp ON pr.producto_id = pp.producto_id
GROUP BY pr.nombre

-- 15. Para un proveedor determinado (p. ej. `proveedor_id = 3`), muestra el nombre de todos los productos que suministra.

SELECT pr.proveedor_id, pr.nombre AS nombre_proveedor, pr.email, pr.telefono, pr.direccion, pp.producto_id, p.nombre
FROM proveedores AS pr
INNER JOIN proveedores_productos AS pp ON pp.proveedor_id = pr.proveedor_id
INNER JOIN productos AS p ON p.producto_id = pp.producto_id
WHERE pr.proveedor_id = 3;

-- 16. Para un producto específico (p. ej. `producto_id = 1`), muestra todos los proveedores que lo distribuyen, con sus datos de contacto.

SELECT pr.proveedor_id, pr.nombre AS nombre_proveedor, pr.email, pr.telefono, pr.direccion, pr.ciudad, pr.pais, pp.producto_id, p.nombre
FROM proveedores AS pr
INNER JOIN proveedores_productos AS pp ON pp.proveedor_id = pr.proveedor_id
INNER JOIN productos AS p ON p.producto_id = pp.producto_id
WHERE p.producto_id = 3;

-- 17. Cuenta cuántos proveedores tiene cada producto, listando `producto_id`, `nombre` y `cantidad_proveedores`.

SELECT DISTINCT COUNT(pp.proveedor_id) AS cantidad_proveedores, pr.producto_id, pr.nombre
FROM productos AS pr
LEFT JOIN proveedores_productos AS pp ON pp.proveedor_id = pr.producto_id
GROUP BY pr.producto_id, pr.nombre;

-- 18. Cuenta cuántos productos suministra cada proveedor, mostrando `proveedor_id`, `nombre_proveedor` y `total_productos`.


SELECT pr.proveedor_id, pr.nombre AS nombre_proveedor, COUNT(pp.producto_id) AS Total_productos
FROM proveedores AS pr
LEFT JOIN proveedores_productos AS pp ON pp.proveedor_id = pr.proveedor_id
GROUP BY pr.proveedor_id, pr.nombre;

