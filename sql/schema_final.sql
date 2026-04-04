-- =============================================
-- schema_final.sql - FIXED VERSION
-- ChocoDelight Capstone Project II
-- =============================================

-- Drop existing foreign keys to avoid conflicts
ALTER TABLE IF EXISTS sales 
    DROP CONSTRAINT IF EXISTS fk_sales_product,
    DROP CONSTRAINT IF EXISTS fk_sales_store,
    DROP CONSTRAINT IF EXISTS fk_sales_customer,
    DROP CONSTRAINT IF EXISTS fk_sales_date;

-- 1. DIMENSION TABLES
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

-- 2. FACT TABLE
CREATE TABLE IF NOT EXISTS sales (
    order_id BIGINT PRIMARY KEY,
    order_date DATE NOT NULL,
    product_id INTEGER,
    store_id INTEGER,
    customer_id INTEGER,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2),
    discount NUMERIC(10,2),
    revenue NUMERIC(12,2) NOT NULL,
    cost NUMERIC(12,2),
    profit NUMERIC(12,2)
);

-- 3. FOREIGN KEY CONSTRAINTS
ALTER TABLE sales
    ADD CONSTRAINT fk_sales_product 
    FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE sales
    ADD CONSTRAINT fk_sales_store 
    FOREIGN KEY (store_id) REFERENCES stores(store_id);

ALTER TABLE sales
    ADD CONSTRAINT fk_sales_customer 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE sales
    ADD CONSTRAINT fk_sales_date 
    FOREIGN KEY (order_date) REFERENCES calendar(date);

-- 4. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_sales_order_date ON sales(order_date);
CREATE INDEX IF NOT EXISTS idx_sales_product_id ON sales(product_id);
CREATE INDEX IF NOT EXISTS idx_sales_store_id ON sales(store_id);
CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_sales_revenue ON sales(revenue);

-- 5. BUSINESS ANALYTICS VIEWS (Task 3)
CREATE OR REPLACE VIEW vw_revenue_by_product AS
SELECT 
    p.product_name,
    p.brand,
    p.category,
    SUM(s.revenue) AS total_revenue,
    SUM(s.quantity) AS total_units_sold,
    ROUND(SUM(s.profit)::numeric, 2) AS total_profit
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.brand, p.category
ORDER BY total_revenue DESC;

CREATE OR REPLACE VIEW vw_revenue_by_store AS
SELECT 
    st.country,
    st.city,
    st.store_name,
    SUM(s.revenue) AS total_revenue,
    ROUND(SUM(s.profit)::numeric, 2) AS total_profit
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.country, st.city, st.store_name
ORDER BY total_revenue DESC;

CREATE OR REPLACE VIEW vw_monthly_trends AS
SELECT 
    c.year,
    c.month,
    SUM(s.revenue) AS monthly_revenue,
    ROUND(SUM(s.profit)::numeric, 2) AS monthly_profit
FROM sales s
JOIN calendar c ON s.order_date = c.date
GROUP BY c.year, c.month
ORDER BY c.year DESC, c.month DESC;

-- 6. SEGMENTATION (Task 4)
ALTER TABLE sales ADD COLUMN IF NOT EXISTS revenue_bucket VARCHAR(20);
ALTER TABLE sales ADD COLUMN IF NOT EXISTS sale_season VARCHAR(20);

UPDATE sales
SET revenue_bucket = 
    CASE 
        WHEN revenue < 500 THEN 'Low'
        WHEN revenue < 2000 THEN 'Medium'
        WHEN revenue < 5000 THEN 'High'
        ELSE 'Premium'
    END;

UPDATE sales s
SET sale_season = 
    CASE 
        WHEN c.month IN (12,1,2) THEN 'Winter'
        WHEN c.month IN (3,4,5) THEN 'Spring'
        WHEN c.month IN (6,7,8) THEN 'Summer'
        ELSE 'Fall'
    END
FROM calendar c 
WHERE s.order_date = c.date;

-- Final Comments
COMMENT ON TABLE sales IS 'Fact table - Chocolate Sales 2023-2024 (2NF Star Schema)';