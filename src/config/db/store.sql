CREATE DATABASE store;


CREATE USER admin;
ALTER USER admin WITH ENCRYPTED PASSWORD 'hardpassword';

-- Войти в базу данных под пользователем:
-- psql store -U admin
-- hardpassword



-- ROLES

-- создать таблицу
CREATE TABLE roles
(
    id SERIAL PRIMARY KEY,
    role VARCHAR(30) UNIQUE NOT NULL
);

-- создать роль
INSERT INTO roles (role)
VALUES ('ADMIN')
RETURNING *;

INSERT INTO roles (role)
VALUES ('USER')
RETURNING *;

INSERT INTO roles (role)
VALUES ('GUEST')
RETURNING *;



-- USERS

CREATE TABLE users 
(
    id SERIAL PRIMARY KEY,
    login VARCHAR(20) UNIQUE NOT NULL, 
    password VARCHAR(255) NOT NULL,
    age INTEGER DEFAULT 18 CHECK(Age >0 AND Age < 100),
    status VARCHAR(255) DEFAULT ('Родился')
);

INSERT INTO users (login, password)
VALUES ('TEST_USER', 'TEST_PASSWORD')
RETURNING *;

-- СВЯЗАТЬ ТАБЛИЦУ ПОЛЬЗОВАТЕЛЕЙ И РОЛЯМИ

CREATE TABLE users_roles
(
    user_id INTEGER,
    role_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);

-- ДОБАВИТЬ ПОЛЬЗОВАТЕЛЮ РОЛЬ

INSERT INTO users_roles (user_id, role_id)
VALUES (1, 1)
RETURNING *;

-- ПОЛУЧИТЬ ПОЛЬЗОВАТЕЛЯ С РОЛЬЮ

SELECT users.login, roles.value 
    FROM users INNER JOIN users_roles
    ON users.id = users_roles.user_id
    INNER JOIN roles
    ON users_roles.role_id = roles.id;



-- СОЗДАНИЕ ТАБЛИЦЫ ПРОДУКТ
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    price INTEGER NOT NULL CHECK(price > 0 AND price < 1000000),
    count INTEGER NOT NULL DEFAULT 0,
    brand_id INTEGER DEFAULT 1 REFERENCES brands (id) ON DELETE CASCADE,
    type_id INTEGER DEFAULT 1 REFERENCES types (id) ON DELETE CASCADE
);

INSERT INTO products (name, price, count)
VALUES ('Product NAME', 1, 10)
RETURNING *;


CREATE TABLE products_photos (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255),
    product_id INTEGER REFERENCES products (id) ON DELETE CASCADE
);

INSERT INTO products_photos (url, product_id)
VALUES ('Product photo URL', 1)
RETURNING *;

CREATE TABLE products_info (
    id SERIAL PRIMARY KEY,
    characteristics TEXT,
    description TEXT,
    product_id INTEGER REFERENCES products (id) ON DELETE CASCADE
);

INSERT INTO products_info (characteristics, description, product_id)
VALUES ('Product info  CHARACTERERISTICS', 'Product info DESCRIPTION', 1)
RETURNING *;

-- ПОЛУЧИТЬ ВСЕХ ПОЛЯ ДЛЯ ПРОДУКТА
SELECT p.id, p.name, p.price, pp.url as photo_url, pi.description, pi.characteristics 
    FROM products p 
    LEFT JOIN products_photos pp 
    ON p.id = pp.product_id 
    LEFT JOIN products_info pi 
    ON p.id = pi.product_id;


-- СОЗДАНИЕ ТАБЛИЦЫ ЗАКАЗА

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    product_count INTEGER DEFAULT 0,
    price INTEGER DEFAULT 0,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO orders (user_id, product_id)
VALUES (1, 1)
RETURNING *;

-- ПРАКТИКА С JOIN
SELECT u.id, u.login,
    r.value as user_role,
    p.name as product_name, p.price,
    pi.description, pi.characteristics,
    pp.url
    FROM users u 
    LEFT JOIN users_roles ur 
    ON u.id = ur.user_id
    LEFT JOIN roles r
    ON r.id = ur.role_id
    LEFT JOIN orders o
    ON u.id = o.user_id
    LEFT JOIN products p
    ON p.id = o.product_id
    LEFT JOIN products_info pi
    ON p.id = pi.product_id
    LEFT JOIN products_photos pp
    ON p.id = pp.product_id;


-- СОЗДАНИЕ КОММЕНТАРИЕВ

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    comment VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP 
);

INSERT INTO comments (comment)
VALUES ('COMMENT_1')
RETURNING *;


CREATE TABLE users_comments (
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    comment_id INTEGER NOT NULL REFERENCES comments(id) ON DELETE CASCADE
);

CREATE TABLE products_comments (
    product_id INTEGER NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    comment_id INTEGER NOT NULL REFERENCES comments (id) ON DELETE CASCADE
);

INSERT INTO users_comments (user_id, comment_id)
VALUES (1, 1)
RETURNING *;

INSERT INTO products_comments (product_id, comment_id)
VALUES (1, 1)
RETURNING *;

CREATE TABLE brands (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE types (
    id SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE brands_types (
    brand_id INTEGER NOT NULL REFERENCES brands (id) ON DELETE CASCADE,
    type_id INTEGER NOT NULL REFERENCES types (id) ON DELETE CASCADE
);

INSERT INTO brands (brand)
VALUES ('BRAND 1')
RETURNING *;

INSERT INTO types (type)
VALUES ('TYPE 1')
RETURNING *;

INSERT INTO brands (brand)
VALUES ('BRAND 2')
RETURNING *;

INSERT INTO types (type)
VALUES ('TYPE 2')
RETURNING *;

INSERT INTO brands_types (brand_id, type_id)
VALUES (1, 1)
RETURNING *;


INSERT INTO brands_types (brand_id, type_id)
VALUES (1, 2)
RETURNING *;

INSERT INTO brands_types (brand_id, type_id)
VALUES (2, 1)
RETURNING *;


INSERT INTO brands_types (brand_id, type_id)
VALUES (2, 2)
RETURNING *;

ALTER TABLE products 
    ADD COLUMN brand_id INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN type_id INTEGER NOT NULL DEFAULT 1;



-- ПРАКТИКА "ОПЕРАЦИИ С ДАННЫМИ"

-- roles
-- Создать 
INSERT INTO roles (role)
VALUES
('ADMIN'),
RETURNING *;
-- Получить
SELECT * FROM roles;
-- Полчуть одного 
SELECT * FROM roles WHERE id = 1
SELECT * FROM roles WHERE role = 'ADMIN'
RETURNING *;
-- Обновить
UPDATE roles
SET role = 'MAGL',
WHERE role = 'GUEST'
RETURNING *;
-- Удалить 
DELETE FROM roles 
WHERE role = 'TESTER' AND id > 3
RETURNING *;

-- products
-- CREATE
INSERT INTO products (name, price, count)
VALUES
('iPhone 6', 36000, 3),
('Galaxy S8', 46000, 2),
('Galaxy S8 Plus', 56000, 1)
RETURNING *;

-- ПОЛУЧИТЬ уникальное значение
SELECT distinct name 
FROM products p
WHERE p.price > 10000;

-- SORT
SELECT * 
FROM products p
ORDER BY p.price * count ASC, p.name DESC;

-- LIMIT
SELECT * 
FROM products p
ORDER BY p.name ASC
LIMIT 10 OFFSET 10;

-- FILTER
SELECT * 
FROM products p
WHERE p.name NOT IN ('Samsung', 'HTC', 'Huawei');

SELECT *
FROM products p
WHERE p.price * p.count NOT BETWEEN 10000 AND 20000;

SELECT *
FROM products p
WHERE p.name LIKE 'iPhone%'

-- Агрегатные функции
-- Средняя цена
SELECT AVG(p.price * p.count) as average_price
FROM products p
WHERE p.name LIKE 'iPhone%'

-- Кол-во строк 
SELECT COUNT(*) FROM products;
SELECT COUNT(DISTINCT p.name) FROM products p;

-- Min Max Sum Bool_or
SELECT MIN(p.price) as min_price
FROM products p;

SELECT MAX(p.price) as max_price
FROM products p

SELECT SUM(p.price * p.count) as sum_price
FROM products p;

SELECT COUNT(*) AS products_count,
       SUM(p.count) AS total_count,
       MIN(p.price) AS min_price,
       MAX(p.price) AS max_price,
       AVG(p.price) AS avg_price
FROM products;

-- GET ALL
SELECT p.* 
FROM products p;

-- GET BY ID
SELECT p.* 
FROM products p 
WHERE p.id = 1 ;

-- GET
SELECT p.*
FROM products p
WHERE p.price >= 3000 AND p.price !> 1000 -- Не больше чем 3000 и не меньшне чем 1000
OR p.name <> 'NAME';

-- UPDATE
UPDATE products
SET price = 1000, count + 10
WHERE id = 1
RETURNING *;

-- DELETE 
DELETE products
WHERE id = 2
RETURNING *;



