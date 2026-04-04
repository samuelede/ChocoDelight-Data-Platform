-- =============================================
-- 02_constraints_indexes.sql
-- Adds PRIMARY KEY, FOREIGN KEY constraints and indexes
-- =============================================

-- Add Foreign Key Constraints
ALTER TABLE sales
ADD CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_store FOREIGN KEY (store_id) REFERENCES stores(store_id);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_date FOREIGN KEY (order_date) REFERENCES calendar(date);

-- Add Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_sales_order_date ON sales(order_date);
CREATE INDEX IF NOT EXISTS idx_sales_product_id ON sales(product_id);
CREATE INDEX IF NOT EXISTS idx_sales_store_id ON sales(store_id);
CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_sales_revenue ON sales(revenue);

-- Add NOT NULL where appropriate
ALTER TABLE sales ALTER COLUMN order_date SET NOT NULL;
ALTER TABLE sales ALTER COLUMN quantity SET NOT NULL;
ALTER TABLE sales ALTER COLUMN revenue SET NOT NULL;