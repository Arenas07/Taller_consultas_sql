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
INNER JOIN usuarios AS ue ON ue.usuario_id = e.usuario_id

-- 4. Muestra todos los pedidos y, si existen, los productos en cada pedido, incluyendo los pedidos sin productos usando `LEFT JOIN`

SELECT p.pedido_id, p.cliente_id, p.fecha_pedido, p.estado, dp.producto_id, dp.cantidad
FROM pedidos AS p
LEFT JOIN detalles_pedidos AS dp ON dp.pedido_id = p.pedido_id

-- 5.