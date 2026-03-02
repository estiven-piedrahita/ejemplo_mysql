CREATE DATABASE IF NOT EXISTS practice_db;
USE practice_db;

-- Roles
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO roles (name) VALUES 
('ADMIN'), ('CLIENT'), ('VENDEDOR');

-- Usuarios
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    age INT,
    password VARCHAR(50)
);

INSERT INTO users (name, email, age, password) VALUES
('Juan Pérez', 'juanp@mail.com', 25, '1234'),
('Ana Gómez', 'ana_g@mail.com', 30, 'abcd'),
('Pedro Ramírez', 'pedro.r@mail.com', 22, 'pass1'),
('Luisa Martínez', 'luisa.m@mail.com', 28, 'qwerty');

-- Relación usuarios-roles
CREATE TABLE user_roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY(user_id, role_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(role_id) REFERENCES roles(role_id)
);

INSERT INTO user_roles (user_id, role_id) VALUES
(1,1), -- Juan es ADMIN
(2,2), -- Ana CLIENT
(3,2), -- Pedro CLIENT
(4,3); -- Luisa VENDEDOR

-- Eventos
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    date DATE,
    location VARCHAR(100)
);

INSERT INTO events (name, date, location) VALUES
('Concierto A', '2026-03-05', 'Estadio Central'),
('Concierto B', '2026-03-10', 'Auditorio Norte'),
('Feria del Libro', '2026-04-01', 'Centro Cultural');

-- Tickets
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    user_id INT,
    seat VARCHAR(10),
    price DECIMAL(10,2),
    purchase_date DATE,
    FOREIGN KEY(event_id) REFERENCES events(event_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

INSERT INTO tickets (event_id, user_id, seat, price, purchase_date) VALUES
(1,1,'A1',150,'2026-02-28'),
(2,2,'B3',80,'2026-03-01'),
(3,3,'C5',50,'2026-03-02'),
(1,4,'A2',150,'2026-02-28');



-- consultas basicas

-- Traer todos los usuarios
SELECT * FROM users;

-- Traer solo nombre y correo
SELECT name, email FROM users;





-- Usuarios mayores de 25 años
SELECT name, age FROM users
WHERE age > 25;

-- Buscar usuario por correo
SELECT * FROM users
WHERE email = 'ana_g@mail.com';



-- Ordenar usuarios por edad descendente
SELECT name, age FROM users
ORDER BY age DESC;

-- Ordenar por nombre ascendente
SELECT name, email FROM users
ORDER BY name ASC;





-- Traer usuarios con sus roles
SELECT u.name AS usuario, r.name AS rol
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id;




-- LEFT JOIN: traer todos los usuarios aunque no tengan rol
SELECT u.name AS usuario, r.name AS rol
FROM users u
LEFT JOIN user_roles ur ON u.user_id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.role_id;






-- Contar cuántos usuarios hay por rol
SELECT r.name AS rol, COUNT(u.user_id) AS total_usuarios
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id
GROUP BY r.name;

-- Promedio de edad por rol
SELECT r.name AS rol, AVG(u.age) AS promedio_edad
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id
GROUP BY r.name;






-- Agregar un nuevo usuario
INSERT INTO users (name, email, age, password) VALUES
('Carlos Torres','carlos@mail.com', 27, 'pass123');

-- Agregar ticket
INSERT INTO tickets (event_id, user_id, seat, price, purchase_date) VALUES
(2,5,'B4',90,'2026-03-03');






-- Cambiar correo de usuario
UPDATE users
SET email = 'ana.gomez@mail.com'
WHERE name = 'Ana Gómez';

-- Subir precio de tickets de Concierto A
UPDATE tickets t
JOIN events e ON t.event_id = e.event_id
SET t.price = 160
WHERE e.name = 'Concierto A';






-- Borrar un usuario
DELETE FROM users
WHERE name = 'Pedro Ramírez';

-- Borrar tickets de un evento específico
DELETE t FROM tickets t
JOIN events e ON t.event_id = e.event_id
WHERE e.name = 'Feria del Libro';







-- Usuarios que compraron ticket para Concierto A
SELECT name FROM users
WHERE user_id IN (
    SELECT user_id FROM tickets t
    JOIN events e ON t.event_id = e.event_id
    WHERE e.name = 'Concierto A'
);

-- Eventos con más de un ticket vendido
SELECT e.name, COUNT(t.ticket_id) AS total_tickets
FROM tickets t
JOIN events e ON t.event_id = e.event_id
GROUP BY e.name
HAVING total_tickets > 1;







SELECT u.name AS usuario, SUM(t.price) AS total_gastado
FROM users u
JOIN tickets t ON u.user_id = t.user_id
GROUP BY u.name
HAVING SUM(t.price) > 150;




SELECT name, age
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM tickets
    GROUP BY user_id
    HAVING SUM(price) > 150
);



SELECT u.name AS usuario, SUM(t.price) AS total_gastado
FROM users u
JOIN tickets t ON u.user_id = t.user_id
JOIN events e ON t.event_id = e.event_id
WHERE e.name = 'Concierto A'
GROUP BY u.name
HAVING SUM(t.price) > 100;