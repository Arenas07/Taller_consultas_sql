CREATE TABLE tipos_usuarios (
    tipo_id   INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(50)    NOT NULL
);

CREATE TABLE usuarios (
    usuario_id     INT AUTO_INCREMENT PRIMARY KEY,
    tipo_id        INT NOT NULL,
    nombre         VARCHAR(50)    NOT NULL,
    email          VARCHAR(50)    NOT NULL UNIQUE,
    telefono       VARCHAR(15),
    direccion      VARCHAR(100),
    ciudad         VARCHAR(50),
    pais           VARCHAR(50),
    fecha_registro DATE           NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_usuarios_tipos
        FOREIGN KEY (tipo_id)
        REFERENCES tipos_usuarios(tipo_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


CREATE TABLE proveedores (
    proveedor_id   INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100)   NOT NULL,
    email          VARCHAR(100)   UNIQUE,
    telefono       VARCHAR(20),
    direccion      VARCHAR(150),
    ciudad         VARCHAR(50),
    pais           VARCHAR(50),
    fecha_registro DATE           NOT NULL DEFAULT (CURRENT_DATE)
);


CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(50)    NOT NULL,
    categoria   VARCHAR(50)    NOT NULL,
    precio      DECIMAL(10,2)  NOT NULL  DEFAULT 0.00,
    stock       INT            NOT NULL  DEFAULT 0,
    INDEX idx_productos_categoria (categoria)
);


CREATE TABLE proveedores_productos (
    proveedor_id INT NOT NULL,
    producto_id  INT NOT NULL,
    PRIMARY KEY (proveedor_id, producto_id),
    INDEX idx_pp_proveedor   (proveedor_id),
    INDEX idx_pp_producto    (producto_id),
    CONSTRAINT fk_pp_proveedor
        FOREIGN KEY (proveedor_id) 
        REFERENCES proveedores(proveedor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pp_producto
        FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE empleados (
    empleado_id       INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id        INT NOT NULL,
    puesto            VARCHAR(50)     NOT NULL,
    fecha_contratacion DATE           NOT NULL,
    salario           DECIMAL(10,2)   NOT NULL  DEFAULT 0.00,
    CONSTRAINT fk_empleados_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(usuario_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE pedidos (
    pedido_id     INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id    INT NOT NULL,      -- FK a 'usuarios'
    empleado_id   INT NOT NULL,      -- FK a 'empleados' (quién atendió el pedido)
    fecha_pedido  DATE NOT NULL      DEFAULT (CURRENT_DATE),
    estado        ENUM('Pendiente','Procesando','Enviado','Entregado','Cancelado') NOT NULL DEFAULT 'Pendiente',
    INDEX idx_pedidos_fecha (fecha_pedido),
    CONSTRAINT fk_pedidos_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES usuarios(usuario_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_pedidos_empleado
        FOREIGN KEY (empleado_id)
        REFERENCES empleados(empleado_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE detalles_pedidos (
    detalle_id      INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id       INT NOT NULL,
    producto_id     INT NOT NULL,
    cantidad        INT NOT NULL     DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    --
    CONSTRAINT fk_detalles_ped_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedidos(pedido_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalles_ped_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(producto_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    INDEX idx_detalles_pedido (pedido_id),
    INDEX idx_detalles_producto (producto_id)
);


INSERT INTO tipos_usuarios(nombre) VALUES ('Cliente'), ('Empleado');

INSERT INTO usuarios (
    tipo_id,
    nombre,
    email,
    telefono,
    direccion,
    ciudad,
    pais,
    fecha_registro
) VALUES
    (1, 'Ana Pérez',         'ana.perez@gmail.com',      '555-1234',   'Calle 123',           'Madrid',    'España', '2022-01-15'),
    (1, 'Juan García',       'juan.garcia@hotmail.com',  '555-5678',   'Avenida 45',          'Barcelona', 'España', '2021-11-22'),
    (1, 'María López',       'maria.lopez@gmail.com',    '555-7890',   'Calle Falsa 123',     'Sevilla',   'España', '2023-02-03'),
    (1, 'Carlos Sánchez',    'carlos.sanchez@yahoo.com', '555-4321',   'Av. Libertad 90',     'Valencia',  'España', '2023-05-17'),
    (1, 'Lucía Fernández',   'lucia.fernandez@gmail.com','555-8765',   'Plaza Mayor 12',      'Zaragoza',  'España', '2022-08-21'),
    (1, 'Pablo Martínez',    'pablo.martinez@gmail.com', '555-2345',   'Calle Nueva 45',      'Bilbao',    'España', '2021-09-15'),
    (1, 'Raúl Torres',       'raul.torres@hotmail.com',  '555-6789',   'Av. Central 120',     'Málaga',    'España', '2022-04-01'),
    (1, 'Elena Ramírez',     'elena.ramirez@gmail.com',  '555-1234',   'Paseo del Prado 5',   'Madrid',    'España', '2021-12-20'),
    (1, 'Sofía Gómez',       'sofia.gomez@gmail.com',    '555-5432',   'Calle Sol 18',        'Córdoba',   'España', '2022-11-30'),
    (1, 'Andrés Ortega',     'andres.ortega@hotmail.com','555-9876',   'Av. Buenavista 67',   'Murcia',    'España', '2022-07-14'),
    (1, 'Laura Morales',     'laura.morales@hotmail.com','555-3333',   'Calle Luna 8',        'Pamplona',  'España', '2023-01-11'),
    (1, 'Iván Navarro',      'ivan.navarro@gmail.com',   '555-2222',   'Av. del Rey 21',      'Santander', 'España', '2022-02-05'),
    (1, 'Daniel Ruiz',       'daniel.ruiz@yahoo.com',    '555-4444',   'Calle Grande 99',     'Valencia',  'España', '2023-02-17'),
    (1, 'Esther Blanco',     'esther.blanco@gmail.com',  '555-1111',   'Av. Colón 3',         'Valladolid','España', '2022-10-20'),
    (1, 'Nuria Gil',         'nuria.gil@gmail.com',      '555-5555',   'Calle Olmo 30',       'Madrid',    'España', '2021-06-30'),
    (1, 'Miguel Torres',     'miguel.torres@hotmail.com','555-6666',   'Paseo Marítimo 12',   'Cádiz',     'España', '2023-04-05'),
    (1, 'Paula Castro',      'paula.castro@gmail.com',   '555-7777',   'Plaza Carmen 8',      'Granada',   'España', '2021-12-05'),
    (1, 'Sergio Márquez',    'sergio.marquez@hotmail.com','555-8888',  'Av. Sol 45',          'Málaga',    'España', '2022-05-22'),
    (1, 'Beatriz Vega',      'beatriz.vega@gmail.com',   '555-9999',   'Calle Verde 67',      'Alicante',  'España', '2023-03-30'),
    (1, 'Álvaro Ramos',      'alvaro.ramos@gmail.com',   '555-0000',   'Av. Central 55',      'Logroño',   'España', '2022-09-10'),
     (
    1, 'Juan Quiroga', 'juan.quiroga@gmail.com', '+57 3001234567', 'Cra 10 #45-20', 'Bogotá', 'Colombia', '2025-06-01'
);

INSERT INTO usuarios (
    tipo_id,
    nombre,
    email,
    telefono,
    direccion,
    ciudad,
    pais,
    fecha_registro
) VALUES
    (2, 'Carlos López',     'carlos.lopez@empresa.com',      NULL, NULL, NULL, NULL, '2020-05-10'),
    (2, 'Marta Fernández',  'marta.fernandez@empresa.com',   NULL, NULL, NULL, NULL, '2021-08-20'),
    (2, 'Sergio Molina',    'sergio.molina@empresa.com',     NULL, NULL, NULL, NULL, '2022-01-11'),
    (2, 'Teresa Ortega',    'teresa.ortega@empresa.com',     NULL, NULL, NULL, NULL, '2021-04-15'),
    (2, 'Rafael Castro',    'rafael.castro@empresa.com',     NULL, NULL, NULL, NULL, '2020-12-05'),
    (2, 'Gloria Morales',   'gloria.morales@empresa.com',    NULL, NULL, NULL, NULL, '2023-02-10'),
    (2, 'Pablo Vega',       'pablo.vega@empresa.com',        NULL, NULL, NULL, NULL, '2022-10-23'),
    (2, 'Raquel Sánchez',   'raquel.sanchez@empresa.com',    NULL, NULL, NULL, NULL, '2019-11-07'),
    (2, 'Luis Ramos',       'luis.ramos@empresa.com',        NULL, NULL, NULL, NULL, '2021-03-18'),
    (2, 'Natalia Ruiz',     'natalia.ruiz@empresa.com',      NULL, NULL, NULL, NULL, '2022-07-30'),
    (2, 'Daniel Lara',      'daniel.lara@empresa.com',       NULL, NULL, NULL, NULL, '2020-11-15'),
    (2, 'Manuel García',    'manuel.garcia@empresa.com',     NULL, NULL, NULL, NULL, '2021-01-18'),
    (2, 'José Martínez',    'jose.martinez@empresa.com',     NULL, NULL, NULL, NULL, '2022-06-25'),
    (2, 'Patricia León',    'patricia.leon@empresa.com',     NULL, NULL, NULL, NULL, '2018-10-05'),
    (2, 'Lola Díaz',        'lola.diaz@empresa.com',         NULL, NULL, NULL, NULL, '2019-08-19'),
    (2, 'Juan Cruz',        'juan.cruz@empresa.com',         NULL, NULL, NULL, NULL, '2020-12-01'),
    (2, 'Paula Rueda',      'paula.rueda@empresa.com',       NULL, NULL, NULL, NULL, '2018-05-10'),
    (2, 'Miguel Gil',       'miguel.gil@empresa.com',        NULL, NULL, NULL, NULL, '2021-04-12'),
    (2, 'Rocío López',      'rocio.lopez@empresa.com',       NULL, NULL, NULL, NULL, '2022-02-20'),
    (2, 'Andrés Navas',     'andres.navas@empresa.com',      NULL, NULL, NULL, NULL, '2021-12-13');

INSERT INTO empleados (
    usuario_id,
    puesto,
    fecha_contratacion,
    salario
) VALUES
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'carlos.lopez@empresa.com'),
      'Gerente de Ventas',    '2020-05-10', 3500000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'marta.fernandez@empresa.com'),
      'Asistente de Ventas',  '2021-08-20', 2200000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'sergio.molina@empresa.com'),
      'Representante de Ventas','2022-01-11',2500000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'teresa.ortega@empresa.com'),
      'Asistente de Marketing','2021-04-15',2100000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'rafael.castro@empresa.com'),
      'Analista de Datos',     '2020-12-05',2800000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'gloria.morales@empresa.com'),
      'Ejecutiva de Cuentas',  '2023-02-10',2400000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'pablo.vega@empresa.com'),
      'Supervisor de Ventas',  '2022-10-23',2600000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'raquel.sanchez@empresa.com'),
      'Gerente de Finanzas',   '2019-11-07',4000000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'luis.ramos@empresa.com'),
      'Auxiliar Administrativo','2021-03-18',2000000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'natalia.ruiz@empresa.com'),
      'Desarrolladora',        '2022-07-30',3000000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'daniel.lara@empresa.com'),
      'Representante de Ventas','2020-11-15',2600000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'manuel.garcia@empresa.com'),
      'Encargado de Almacén',  '2021-01-18',2200000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'jose.martinez@empresa.com'),
      'Especialista de Soporte','2022-06-25',2100000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'patricia.leon@empresa.com'),
      'Gerente de Proyectos',  '2018-10-05',4200000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'lola.diaz@empresa.com'),
      'Coordinadora de Logística','2019-08-19',3100000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'juan.cruz@empresa.com'),
      'Asistente Administrativo','2020-12-01',1900000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'paula.rueda@empresa.com'),
      'Jefe de Compras',       '2018-05-10',3600000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'miguel.gil@empresa.com'),
      'Consultor de Negocios', '2021-04-12',2900000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'rocio.lopez@empresa.com'),
      'Especialista en Ventas','2022-02-20',2300000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'andres.navas@empresa.com'),
      'Desarrollador',         '2021-12-13',3100000.00
    );

INSERT INTO proveedores (
    nombre, email, telefono, direccion, ciudad, pais, fecha_registro
) VALUES
    ('Tech Supplies S.A.',           'contacto@techsupplies.com',  '0341-5551234', 'Calle Industria 45', 'Bogotá',   'Colombia', '2023-01-10'),
    ('Global Components Ltda.',       'ventas@globalcomp.com',      '0341-5555678', 'Av. Comercio 123',   'Medellín', 'Colombia', '2022-09-15'),
    ('Electrodomésticos del Norte',   'info@electronorte.com',      '0346-5557890', 'Calle Norte 8',      'Cali',     'Colombia', '2023-03-05'),
    ('Accesorios y Más S.A.S.',       'accesorios@ymas.com',        '0342-5554321', 'Av. Central 67',     'Barranquilla','Colombia','2022-11-20'),
    ('Muebles & Diseño S.A.',         'contacto@mueblesydiseno.com','0345-5558765', 'Calle Muebles 12',   'Cartagena','Colombia','2023-02-25'), ('Proveedor XYZ S.A.S.','contacto@provedorxyz.com', '+57 3107654321','Av. Comercio 123', 'Medellín', 'Colombia','2025-05-20'
);

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Laptop',           'Electrónica',  4148678.51, 50),
('Smartphone',       'Electrónica',  2074318.51, 150),
('Televisor',        'Electrónica',  1244616.00, 40),
('Auriculares',      'Accesorios',    103718.00, 200),
('Teclado',          'Accesorios',    186692.40, 120),
('Ratón',            'Accesorios',     82974.40, 180),
('Impresora',        'Oficina',       622308.00, 60),
('Escritorio',       'Muebles',       829744.00, 25),
('Silla',            'Muebles',       497846.40, 80),
('Tableta',          'Electrónica',  1037180.00, 90),
('Lámpara',          'Hogar',         145205.20, 100),
('Ventilador',       'Hogar',         248923.20, 50),
('Microondas',       'Hogar',         331897.60, 30),
('Licuadora',        'Hogar',         186692.40, 70),
('Refrigerador',     'Electrodomésticos', 2074360.00, 20),
('Cafetera',         'Electrodomésticos', 311154.00, 60),
('Altavoces',        'Audio',         228179.60, 90),
('Monitor',          'Electrónica',   746769.60, 40),
('Bicicleta',        'Deporte',      1244616.00, 15),
('Reloj Inteligente','Electrónica',   622308.00, 100),
('Auricular Bluetooth Pro','Accesorios',259900.00,75);

INSERT INTO proveedores_productos (proveedor_id, producto_id) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (1, 4),
    (4, 4),
    (5, 8),
    (1, 3),
    (3, 3),
    (4, 6),
    (4, 5),
    (2, 7),
    (2, 15),
    (5, 9),
    (5, 10),
    (3, 11),
    (3, 12),
    (3, 13),
    (4, 14),
    (2, 16),
    (1, 17),
    (1, 18),
    (5, 19),
    (2, 20);


INSERT INTO pedidos (cliente_id, empleado_id, fecha_pedido, estado) VALUES
(1, 1, '2023-02-10', 'Entregado'),
(2, 2, '2023-02-12', 'Pendiente'),
(3, 3, '2023-03-15', 'Cancelado'),
(4, 4, '2023-03-16', 'Enviado'),
(5, 5, '2023-04-10', 'Pendiente'),
(6, 6, '2023-04-12', 'Entregado'),
(7, 7, '2023-05-05', 'Pendiente'),
(8, 8, '2023-05-07', 'Pendiente'),
(9, 9, '2023-05-10', 'Entregado'),
(10, 10, '2023-06-01', 'Entregado'),
(11, 11, '2023-06-02', 'Cancelado'),
(12, 12, '2023-06-03', 'Entregado'),
(13, 13, '2023-07-12', 'Pendiente'),
(14, 14, '2023-07-20', 'Cancelado'),
(15, 15, '2023-08-15', 'Entregado'),
(16, 16, '2023-08-30', 'Procesando'),
(17, 17, '2023-09-10', 'Pendiente'),
(18, 18, '2023-09-25', 'Enviado'),
(19, 19, '2023-10-05', 'Cancelado'),
(20, 20, '2023-10-18', 'Entregado'),
(21,1,'2025-06-02','Pendiente'),
(21,1,'2025-06-05','Entregado'),
(21,1,'2025-06-10','Pendiente'),
(21,1,'2025-06-12','Cancelado'),
(21,1,'2025-06-15','Entregado'),
(21,1,'2025-06-18','Pendiente'),
(21,1,'2025-06-20','Entregado');


INSERT INTO detalles_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1,  1,  2,  4148678.51),
(2,  2,  1,  2074318.51),
(3,  3,  3,  1244616.00),
(4,  4,  1,   103718.00),
(5,  5,  5,   186692.40),
(6,  6,  4,    82974.40),
(7,  7,  2,   622308.00),
(8,  8,  1,   829744.00),
(9,  9,  8,   497846.40),
(10, 10, 3,  1037180.00),
(11, 11, 6,   145205.20),
(12, 12, 7,   248923.20),
(13, 13, 4,   331897.60),
(14, 14, 5,   186692.40),
(15, 15, 9,  2074360.00),
(16, 16, 10,  311154.00),
(17, 17, 5,   228179.60),
(18, 18, 4,   746769.60),
(19, 19, 11, 1244616.00),
(20, 20, 12,  622308.00);
 
-- *******************************************************
### Consultas multitabla joins
-- *******************************************************
-- 1. Encuentra los nombres de los clientes y los detalles de sus pedidos.
SELECT u.nombre AS cliente, p.pedido_id, dp.detalle_id, dp.cantidad, pr.nombre AS producto 
FROM usuarios as u
JOIN pedidos as p ON u.usuario_id = p.cliente_id
JOIN detalles_pedidos as dp ON p.pedido_id = dp.pedido_id 
JOIN productos as pr ON dp.producto_id = pr.producto_id;

-- 2. Lista todos los productos pedidos junto con el precio unitario de cada pedido

SELECT pr.nombre as producto, dp.precio_unitario 
FROM productos as pr 
JOIN detalles_pedidos as dp ON pr.producto_id = dp.producto_id; 

-- 3. Encuentra los nombres de los clientes y los nombres de los empleados que gestionaron sus pedidos

SELECT cliente.nombre AS cliente, empleado.nombre AS empleado
FROM pedidos as p
JOIN usuarios as cliente ON p.cliente_id = cliente.usuario_id
JOIN empleados as e ON p.empleado_id = e.empleado_id
JOIN usuarios as empleado ON e.usuario_id = empleado.usuario_id;

-- 4. Muestra todos los pedidos y, si existen, los productos en cada pedido, incluyendo los pedidos sin productos usando `LEFT JOIN`

SELECT * 
FROM pedidos as p 
LEFT JOIN detalles_pedidos as dp ON p.pedido_id = dp.pedido_id

-- 5. Encuentra los productos y, si existen, los detalles de pedidos en los que no se ha incluido el producto usando `RIGHT JOIN`.
SELECT *
FROM detalles_pedidos as dp
RIGHT JOIN productos as pr ON pr.producto_id = dp.producto_id;

-- 6. Lista todos los empleados junto con los pedidos que han gestionado, si existen, usando `LEFT JOIN` para ver los empleados sin pedidos.

SELECT e.empleado_id, u.nombre as empleado, p.pedido_id, p.fecha_pedido, p.estado
FROM empleados as e
JOIN usuarios as u ON e.usuario_id = u.usuario_id
LEFT JOIN pedidos as p ON e.empleado_id = p.empleado_id;

-- 7. Encuentra los empleados que no han gestionado ningún pedido usando un `LEFT JOIN` combinado con `WHERE`.

SELECT *
FROM empleados as e JOIN usuarios as u ON e.usuario_id = u.usuario_id
LEFT JOIN pedidos as p ON e.empleado_id = p.empleado_id
WHERE p.pedido_id IS NULL;

-- 8. Calcula el total gastado en cada pedido, mostrando el ID del pedido y el total, usando `JOIN`.

SELECT p.pedido_id, dp.cantidad * dp.precio_unitario as total_venta
FROM pedidos as p
JOIN detalles_pedidos as dp ON p.pedido_id = dp.pedido_id;

-- 9. Realiza un `CROSS JOIN` entre clientes y productos para mostrar todas las combinaciones posibles de clientes y productos.

SELECT u.nombre as cliente, p.nombre as producto
FROM usuarios as u
JOIN tipos_usuarios as tu ON u.tipo_id = tu.tipo_id
CROSS JOIN productos as p
WHERE tu.nombre = 'cliente';

-- 10. Encuentra los nombres de los clientes y los productos que han comprado, si existen, incluyendo los clientes que no han realizado pedidos usando `LEFT JOIN`.

SELECT u.nombre as cliente, pr.nombre as producto
FROM usuarios as u
LEFT JOIN pedidos as p ON u.usuario_id = p.cliente_id
LEFT JOIN detalles_pedidos as dp ON p.pedido_id = dp.pedido_id
LEFT JOIN productos as pr ON dp.producto_id = pr.producto_id

-- 11. Listar todos los proveedores que suministran un determinado producto.

SELECT pr.nombre as proveedor
FROM proveedores as pr
JOIN proveedores_productos as pp ON pr.proveedor_id = pp.proveedor_id
WHERE pp.producto_id = 1;

-- 12. Obtener todos los productos que ofrece un proveedor específico.

SELECT p.producto_id, p.nombre, p.categoria, p.precio, p.stock
FROM productos as p
JOIN proveedores_productos as pp ON p.producto_id = pp.producto_id
WHERE pp.proveedor_id = 1;

-- 13. Lista los proveedores que no están asociados a ningún producto (es decir, que aún no suministran).

SELECT *
FROM proveedores as pr
LEFT JOIN proveedores_productos as pp ON pr.proveedor_id = pp.proveedor_id
WHERE pp.proveedor_id IS NULL;

-- 14. Contar cuántos proveedores tiene cada producto.

SELECT p.producto_id, p.nombre as producto, COUNT(pp.proveedor_id) as total_proveedores
FROM productos as p
LEFT JOIN proveedores_productos pp ON p.producto_id = pp.producto_id
GROUP BY p.producto_id, p.nombre;

-- 15. Para un proveedor determinado (p. ej. `proveedor_id = 3`), muestra el nombre de todos los productos que suministra.

SELECT p.nombre as producto
FROM productos as p
JOIN proveedores_productos as pp ON p.producto_id = pp.producto_id
WHERE pp.proveedor_id = 3;

-- 16. Para un producto específico (p. ej. `producto_id = 1`), muestra todos los proveedores que lo distribuyen, con sus datos de contacto.

SELECT pr.proveedor_id, pr.nombre, pr.email, pr.telefono, pr.direccion, pr.ciudad, pr.pais
FROM proveedores as pr
JOIN proveedores_productos as pp ON pr.proveedor_id = pp.proveedor_id
WHERE pp.producto_id = 1;


-- 17. Cuenta cuántos proveedores tiene cada producto, listando `producto_id`, `nombre` y `cantidad_proveedores`.

SELECT p.producto_id, p.nombre, COUNT(pp.proveedor_id) as total_proveedores
FROM productos as p
LEFT JOIN proveedores_productos pp ON p.producto_id = pp.producto_id
GROUP BY p.producto_id, p.nombre;

-- 18. Cuenta cuántos productos suministra cada proveedor, mostrando `proveedor_id`, `nombre_proveedor` y `total_productos`.

SELECT pr.proveedor_id, pr.nombre as nombre_proveedor, COUNT(pp.producto_id) as total_productos
FROM proveedores as pr
LEFT JOIN proveedores_productos as pp ON pr.proveedor_id = pp.proveedor_id
GROUP BY pr.proveedor_id, pr.nombre;
