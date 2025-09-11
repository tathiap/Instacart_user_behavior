
SELECT @@secure_file_priv AS secure_file_priv, @@local_infile AS local_infile;


-- Use the schema
CREATE DATABASE IF NOT EXISTS instacart;
USE instacart;

-- Aisles
DROP TABLE IF EXISTS aisles;
CREATE TABLE aisles (
  aisle_id INT PRIMARY KEY,
  aisle VARCHAR(255)
);

-- Departments
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
  department_id INT PRIMARY KEY,
  department VARCHAR(255)
);

-- Products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255),
  aisle_id INT,
  department_id INT,
  INDEX (aisle_id),
  INDEX (department_id)
);

-- Orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY,
  user_id BIGINT,
  eval_set VARCHAR(16),                 -- 'prior'/'train'/'test' (if present in your CSV)
  order_number INT,
  order_dow INT,
  order_hour_of_day INT,
  days_since_prior_order DOUBLE,
  INDEX (user_id),
  INDEX (eval_set),
  INDEX (order_dow),
  INDEX (order_hour_of_day)
);

-- Order products (prior)
DROP TABLE IF EXISTS order_products__prior;
CREATE TABLE order_products__prior (
  order_id BIGINT,
  product_id INT,
  add_to_cart_order INT,
  reordered TINYINT,
  INDEX (order_id),
  INDEX (product_id)
);

-- Order products (train)
DROP TABLE IF EXISTS order_products__train;
CREATE TABLE order_products__train (
  order_id BIGINT,
  product_id INT,
  add_to_cart_order INT,
  reordered TINYINT,
  INDEX (order_id),
  INDEX (product_id)
);


USE instacart;

-- already have: aisles, departments, products, orders (keep them)
-- create a single order_products table to match your one CSV
DROP TABLE IF EXISTS order_products;
CREATE TABLE order_products (
  order_id BIGINT,
  product_id INT,
  add_to_cart_order INT,
  reordered TINYINT,
  INDEX (order_id),
  INDEX (product_id)
);


-- LOAD DATA 
USE instacart;

LOAD DATA INFILE '/tmp/aisles.csv'
INTO TABLE aisles
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(aisle_id, aisle);

