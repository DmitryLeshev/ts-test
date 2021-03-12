CREATE DATABASE store_v2;

CREATE TABLE roles
(
    id SERIAL PRIMARY KEY,
    role VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE brands (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE types (
    id SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE users 
(
    id SERIAL PRIMARY KEY,
    login VARCHAR(20) UNIQUE NOT NULL, 
    password VARCHAR(255) NOT NULL,
    age INTEGER DEFAULT 18 CHECK(Age >0 AND Age < 100),
    status VARCHAR(255) DEFAULT ('Я Родился')
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    price INTEGER NOT NULL CHECK(price > 0 AND price < 1000000),
    count INTEGER NOT NULL DEFAULT 0,
    brand_id INTEGER DEFAULT 1 REFERENCES brands (id) ON DELETE CASCADE,
    type_id INTEGER DEFAULT 1 REFERENCES types (id) ON DELETE CASCADE
);

CREATE TABLE products_photos (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255),
    product_id INTEGER REFERENCES products (id) ON DELETE CASCADE
);

CREATE TABLE products_info (
    id SERIAL PRIMARY KEY,
    characteristics TEXT,
    description TEXT,
    product_id INTEGER REFERENCES products (id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    product_count INTEGER DEFAULT 0,
    price INTEGER DEFAULT 0,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    comment VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE users_comments (
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    comment_id INTEGER NOT NULL REFERENCES comments(id) ON DELETE CASCADE
);

CREATE TABLE products_comments (
    product_id INTEGER NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    comment_id INTEGER NOT NULL REFERENCES comments (id) ON DELETE CASCADE
);

CREATE TABLE users_roles
(
    user_id INTEGER,
    role_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);

CREATE TABLE brands_types (
    brand_id INTEGER NOT NULL REFERENCES brands (id) ON DELETE CASCADE,
    type_id INTEGER NOT NULL REFERENCES types (id) ON DELETE CASCADE
);

INSERT INTO roles 
(role)
VALUES 
('GUEST'),
('USER'),
('ADMIN');

INSERT INTO brands 
(brand)
VALUES 
('NONE'),
('Apple'),
('Samsung'),
('Xiaomi');

INSERT INTO types 
(type)
VALUES 
('NONE'),
('smartphone'),
('smartwatch'),
('headphones');

INSERT INTO products 
(name, price, brand_id, type_id, count) 
VALUES
('iPhone 6', 36000, 2, 2, 100),
('iPhone 12 Pro', 99990, 2, 2, 100),
('Apple Watch Series 6', 36990, 2, 3, 100),
('AirPods', 19990, 2, 4, 100),
('Galaxy S8', 46000, 3, 2, 100),
('Samsung Galaxy S21', 67990, 3, 2, 100),
('Galaxy Watch3', 49990, 3, 3, 100),
('Samsung Galaxy Buds Live', 13990, 3, 4, 100),
('POCO X3 NFC', 17490, 4, 2, 100),
('Redmi 9C NFC', 9490, 4, 2, 100),
('Mi Smart Band 5', 2990, 4, 3, 100),
('Mi True Wireless Earphones 2S', 6490, 4, 4, 100);

INSERT INTO users 
(login, password, age, status) 
VALUES
('Stalker', 'pro100', 20, 'Хочу летать'),
('Bublic', '101010', 16, 'Рублик'),
('Stalin', 'Lenin', 28, 'Мир, Труд, Май');
