drop table customers;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    subtotal DECIMAL(10,2)
);

INSERT INTO customers (name, email, country) VALUES
('Alice Johnson', 'alice@example.com', 'USA'),
('Bob Smith', 'bob@example.com', 'Canada'),
('Charlie Lee', 'charlie@example.com', 'UK'),
('Diana Evans', 'diana@example.com', 'USA'),
('Ethan Brown', 'ethan@example.com', 'Australia');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1200.00),
('Headphones', 'Electronics', 150.00),
('Coffee Maker', 'Home Appliances', 80.00),
('Desk Chair', 'Furniture', 200.00),
('Book', 'Stationery', 20.00);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-05', 1350.00),
(2, '2025-02-12', 300.00),
(3, '2025-03-18', 1200.00),
(4, '2025-04-22', 80.00),
(1, '2025-05-14', 1400.00),
(5, '2025-06-10', 220.00);

INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 1200.00),
(1, 2, 1, 150.00),
(2, 2, 2, 300.00),
(3, 1, 1, 1200.00),
(4, 3, 1, 80.00),
(5, 1, 1, 1200.00),
(5, 4, 1, 200.00),
(6, 5, 2, 40.00),
(6, 2, 1, 150.00);

SELECT order_id, customer_id, total_amount
FROM orders
WHERE total_amount > 500
ORDER BY total_amount DESC;

SELECT c.country, SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_sales DESC;

SELECT o.order_id, c.name AS customer_name, p.product_name, oi.quantity, oi.subtotal
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.name;

SELECT name, customer_id
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount) FROM orders
    )
);

SELECT AVG(total_amount) AS avg_order_value FROM orders;

SELECT p.category, SUM(oi.subtotal) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

CREATE VIEW top_customers AS
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING SUM(o.total_amount) > 1000;

SELECT * FROM top_customers ORDER BY total_spent DESC;

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
