-- Creando las tablas

-- Tabla de productos
CREATE TABLE productos (
    producto_id INT PRIMARY KEY,
    nombre_producto VARCHAR(50),
    categoria VARCHAR(25),
    precio_unitario DECIMAL(2, 1),
    en_promocion BOOLEAN
);

-- Tabla de ventas
CREATE TABLE ventas (
    venta_id INT PRIMARY KEY,
    fecha DATE,
    hora TIME,
    producto_id INT,
    cantidad INT,
    total_venta DECIMAL(3, 1),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- Tabla de inventario
CREATE TABLE inventario (
    producto_id INT,
    fecha_actualizacion DATE,
    stock_actual INT,
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);