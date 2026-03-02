
-- crear base de datosa o verificar si esta existente
CREATE DATABASE IF NOT EXISTS marketplace;

-- usar base de datos 
USE marketplace;

show tables;

-- -------------- crear tablas -------------------------

-- tabla clientes
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- tabla vendedor
CREATE TABLE sellers (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- tabla categories
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name enum(
    "tecnologia",
    "hogar",
    "deporte",
    "accesorios",
    "mascotas"
    ) not null
);

-- tabla de productos
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    category_id int NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
   FOREIGN KEY (category_id) references categories(category_id)
   
);
 -- tabla de pedidos
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,

    status ENUM(
        'CREATED',
        'PAID',
        'IN_PROGRESS',
        'DELIVERED',
        'CANCELED',
        'REFUNDED'
    ) NOT NULL DEFAULT 'CREATED',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- tabla pivote de productos y pedidos 
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status ENUM(
        'PENDING',
        'APPROVED',
        'FAILED'
    ) NOT NULL,
    method ENUM(
        'CARD',
        'PSE',
        'PAYPAL',
        'BANK_TRANSFER'
    ) NOT NULL,

    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);



CREATE TABLE order_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,

    from_status ENUM(
        'CREATED',
        'PAID',
        'IN_PROGRESS',
        'DELIVERED',
        'CANCELED',
        'REFUNDED'
    ) NOT NULL,

    to_status ENUM(
        'CREATED',
        'PAID',
        'IN_PROGRESS',
        'DELIVERED',
        'CANCELED',
        'REFUNDED'
    ) NOT NULL,

    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by_seller int not null,

    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (changed_by_seller)references sellers(seller_id)
);


-- ---------------------- insertar datos ------------------------------

-- insertar customers
INSERT INTO customers (name, email) VALUES
('Laura Gómez', 'laura@gmail.com'),
('Carlos Pérez', 'carlos@gmail.com'),
('Ana Martínez', 'ana@gmail.com'),
('Julián Rojas', 'julian@gmail.com'),
('Sofía Torres', 'sofia@gmail.com');





-- insertar sellers

INSERT INTO sellers (name, email) VALUES
('TechStore', 'ventas@techstore.com'),
('HogarPlus', 'contacto@hogarplus.com'),
('PetWorld', 'ventas@petworld.com');

-- insertar categorias

INSERT INTO categories (name) VALUES
('tecnologia'),
('hogar'),
('deporte'),
('accesorios'),
('mascotas');

-- insertar productos
INSERT INTO products (seller_id, category_id, name, description, price) VALUES
(1, 1, 'Audífonos Bluetooth', 'Audífonos inalámbricos con cancelación de ruido', 120000),
(1, 1, 'Mouse Gamer RGB', 'Mouse óptico con luces RGB', 80000),
(1, 1, 'Teclado Mecánico', 'Teclado switch blue', 150000),

(2, 2, 'Licuadora 2L', 'Licuadora de alta potencia', 95000),
(2, 2, 'Sartén Antiadherente', 'Sartén profesional', 60000),

(2, 4, 'Cinta LED', 'Luces LED decorativas', 45000),

(3, 5, 'Cama para Perro', 'Cama acolchada talla M', 110000),
(3, 5, 'Juguete Mordedor', 'Juguete resistente para perro', 30000),

(3, 3, 'Balón de Fútbol', 'Balón profesional', 70000),
(3, 3, 'Guantes Deportivos', 'Guantes para gimnasio', 50000);


-- insertar pedidos

INSERT INTO orders (customer_id, status) VALUES
(1, 'CREATED'),
(2, 'PAID'),
(3, 'PAID'),
(4, 'IN_PROGRESS'),
(5, 'CREATED'),
(1, 'PAID'),
(2, 'CANCELED'),
(3, 'PAID');

-- insertar datos de ordenes y pedidos 

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 120000),
(1, 2, 1, 80000),

(2, 3, 1, 150000),

(3, 4, 1, 95000),

(4, 1, 1, 120000),
(4, 5, 1, 60000),

(5, 7, 1, 110000),

(6, 3, 1, 150000),
(6, 10, 1, 50000),

(7, 8, 1, 30000),

(8, 2, 1, 80000),
(8, 3, 1, 150000),
(8, 9, 1, 70000),
(8, 10, 1, 50000),
(8, 6, 1, 45000),
(8, 4, 1, 95000);

-- insertar datos de pagos

INSERT INTO payments (order_id, status, method, amount) VALUES
(1, 'FAILED', 'CARD', 200000),
(1, 'APPROVED', 'CARD', 200000),

(2, 'APPROVED', 'PSE', 150000),

(3, 'APPROVED', 'CARD', 95000),

(4, 'APPROVED', 'BANK_TRANSFER', 180000),

(5, 'FAILED', 'CARD', 110000),
(5, 'FAILED', 'CARD', 110000),

(6, 'APPROVED', 'PAYPAL', 200000),

(7, 'APPROVED', 'CARD', 30000),

(8, 'APPROVED', 'PSE', 490000);

-- insertar datos de historias de estados de pedidos
INSERT INTO payments (order_id, status, method, amount) VALUES
(1, 'FAILED', 'CARD', 200000),
(1, 'APPROVED', 'CARD', 200000),

(2, 'APPROVED', 'PSE', 150000),

(3, 'APPROVED', 'CARD', 95000),

(4, 'APPROVED', 'BANK_TRANSFER', 180000),

(5, 'FAILED', 'CARD', 110000),
(5, 'FAILED', 'CARD', 110000),

(6, 'APPROVED', 'PAYPAL', 200000),

(7, 'APPROVED', 'CARD', 30000),

(8, 'APPROVED', 'PSE', 490000);



-- ------------------- consultas -------------------------

-- 1 resumen por pedido

select * from orders;

select * from products;

select * from order_items;



select * from customers;

    









