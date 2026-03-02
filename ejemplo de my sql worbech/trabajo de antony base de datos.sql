
CREATE DATABASE IF NOT EXISTS marketplace;
USE marketplace;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sellers (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
   FOREIGN KEY (category_id) REFERENCES categories(category_id)
   
);


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


CREATE TABLE fulfillment (
    fulfillment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,

    status ENUM(
        'PENDING',
        'ASSIGNED',
        'DONE',
        'FAILED'
    ) NOT NULL DEFAULT 'PENDING',

    assigned_to VARCHAR(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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
    changed_by VARCHAR(100),

    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

show tables;



INSERT INTO customers (name, email) VALUES
('Ana Torres', 'ana.torres@gmail.com'),
('Carlos Ruiz', 'carlos.ruiz@gmail.com'),
('Laura Gómez', 'laura.gomez@gmail.com'),
('Mateo Pérez', 'mateo.perez@gmail.com'),
('Sofía Herrera', 'sofia.herrera@gmail.com');

INSERT INTO sellers (name, email) VALUES
('TechStore Colombia', 'ventas@techstore.co'),
('HogarPlus', 'contacto@hogarplus.co'),
('FashionLatam', 'sales@fashionlatam.co');

INSERT INTO categories (name) VALUES
('Electrónica'),
('Hogar'),
('Moda'),
('Deportes'),
('Accesorios');


INSERT INTO products (seller_id, category_id, name, description, price) VALUES
(1, 1, 'Laptop Lenovo i5', 'Laptop 14 pulgadas 8GB RAM', 2500000),
(1, 1, 'Mouse inalámbrico', 'Mouse óptico USB', 45000),
(1, 5, 'Audífonos Bluetooth', 'Cancelación de ruido', 180000),

(2, 2, 'Licuadora Oster', '3 velocidades', 220000),
(2, 2, 'Cafetera', '12 tazas', 150000),
(2, 4, 'Mancuernas 10kg', 'Par de mancuernas', 120000),

(3, 3, 'Camiseta deportiva', 'Transpirable', 60000),
(3, 3, 'Jeans hombre', 'Slim fit', 130000),
(3, 5, 'Reloj casual', 'Resistente al agua', 90000),
(3, 3, 'Chaqueta', 'Impermeable', 210000);


INSERT INTO orders (customer_id, status) VALUES
(1, 'CREATED'),
(2, 'PAID'),
(3, 'IN_PROGRESS'),
(4, 'DELIVERED'),
(5, 'CANCELED'),
(1, 'PAID'),
(2, 'DELIVERED'),
(3, 'REFUNDED');

select * from order_items;
select * from orders;

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(17, 1, 1, 2500000),
(17, 2, 1, 45000),

(18, 3, 1, 180000),
(18, 7, 2, 60000),

(20, 4, 1, 220000),
(20, 5, 1, 150000),

(19, 1, 1, 2500000),
(19, 3, 1, 180000),

(21, 8, 1, 130000),
(21, 9, 1, 90000),

(22, 10, 1, 210000),
(22, 7, 1, 60000),

(23, 4, 1, 220000),
(23, 6, 1, 120000),

(24, 2, 2, 45000),
(24, 3, 1, 180000);


INSERT INTO payments (order_id, status, method, amount) VALUES
(17, 'FAILED', 'CARD', 2545000),
(17, 'APPROVED', 'PSE', 2545000),

(18, 'APPROVED', 'CARD', 300000),

(19, 'FAILED', 'CARD', 370000),
(19, 'FAILED', 'CARD', 370000),
(19, 'APPROVED', 'PSE', 370000),

(20, 'APPROVED', 'CARD', 2680000),

(21, 'FAILED', 'PAYPAL', 220000),

(22, 'APPROVED', 'CARD', 270000),

(24, 'APPROVED', 'BANK_TRANSFER', 270000);


show tables;

select * from orders ;

select * from products;

select * from order_items;

SELECT 
o.order_id,
c.name 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;


SELECT 
    c.name AS customer,
    p.name AS product
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
where p.product_id = 1;
;

SELECT 
	c.name AS customer,
    o.order_id 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
    
SELECT 
	p.name AS product,
     SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
group by p.name;
    









