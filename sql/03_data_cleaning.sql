-- =============================================
-- 03_data_cleaning.sql
-- Data cleaning and basic transformations (run after loading data)
-- =============================================

-- Calculate profit if not present in source
UPDATE sales
SET profit = revenue - cost
WHERE profit IS NULL;

-- Remove any negative or zero quantity (outliers)
DELETE FROM sales
WHERE quantity <= 0;

-- Standardize any string columns if needed (example)
UPDATE products
SET product_name = TRIM(INITCAP(product_name));

-- Flag high-value transactions (optional)
ALTER TABLE sales 
ADD COLUMN IF NOT EXISTS is_high_value BOOLEAN DEFAULT FALSE;

UPDATE sales
SET is_high_value = TRUE
WHERE revenue > 5000;