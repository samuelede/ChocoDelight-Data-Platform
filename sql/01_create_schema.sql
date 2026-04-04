-- =============================================
-- 01_create_schema.sql
-- Creates the base tables in 2NF Star Schema
-- =============================================

-- Dimension Tables
CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(200),
    brand VARCHAR(100),
    category VARCHAR(100),
    cocoa_percent NUMERIC(5,2),
    weight_g INTEGER
);

CREATE TABLE IF NOT EXISTS stores (
    store_id INTEGER PRIMARY KEY,
    store_name VARCHAR(150),
    city VARCHAR(100),
    country VARCHAR(100),
    store_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    age INTEGER,
    gender VARCHAR(20),
    loyalty_member BOOLEAN,
    join_date DATE
);

CREATE TABLE IF NOT EXISTS calendar (
    date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    week INTEGER,
    day_of_week VARCHAR(20)
);

-- Fact Table
CREATE TABLE IF NOT EXISTS sales (
    order_id BIGINT PRIMARY KEY,
    order_date DATE,
    product_id INTEGER,
    store_id INTEGER,
    customer_id INTEGER,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2),
    discount NUMERIC(10,2),
    revenue NUMERIC(12,2),
    cost NUMERIC(12,2),
    profit NUMERIC(12,2)
);