-- =============================================
-- 05_segmentation.sql
-- Customer & Sales Segmentation (Task 4)
-- =============================================

-- Add Revenue Bucket column
ALTER TABLE sales 
ADD COLUMN IF NOT EXISTS revenue_bucket VARCHAR(20);

-- Populate Revenue Buckets
UPDATE sales
SET revenue_bucket = 
    CASE 
        WHEN revenue < 500 THEN 'Low'
        WHEN revenue BETWEEN 500 AND 1999.99 THEN 'Medium'
        WHEN revenue BETWEEN 2000 AND 4999.99 THEN 'High'
        ELSE 'Premium'
    END;

-- Add Sale Season column
ALTER TABLE sales 
ADD COLUMN IF NOT EXISTS sale_season VARCHAR(20);

-- Populate Sale Season based on month
UPDATE sales s
SET sale_season = 
    CASE 
        WHEN c.month IN (12, 1, 2)  THEN 'Winter'
        WHEN c.month IN (3, 4, 5)   THEN 'Spring'
        WHEN c.month IN (6, 7, 8)   THEN 'Summer'
        ELSE 'Fall'
    END
FROM calendar c
WHERE s.order_date = c.date;

-- Add Time Category (Holiday / Peak / Regular)
ALTER TABLE sales 
ADD COLUMN IF NOT EXISTS time_category VARCHAR(30);

UPDATE sales s
SET time_category = 
    CASE 
        WHEN c.month IN (11, 12) THEN 'Holiday Season'
        WHEN c.quarter = 4 THEN 'Q4 Peak'
        WHEN c.month IN (6, 7, 8) THEN 'Summer Peak'
        ELSE 'Regular Period'
    END
FROM calendar c
WHERE s.order_date = c.date;

-- Add High-Value Transaction Flag
ALTER TABLE sales 
ADD COLUMN IF NOT EXISTS is_high_value BOOLEAN DEFAULT FALSE;

UPDATE sales
SET is_high_value = TRUE
WHERE revenue >= 5000;

-- Optional: Customer Segment View (based on total spending)
CREATE OR REPLACE VIEW vw_customer_segmentation AS
SELECT 
    c.customer_id,
    COUNT(DISTINCT s.order_id) AS total_orders,
    SUM(s.revenue) AS total_spent,
    ROUND(AVG(s.revenue), 2) AS avg_order_value,
    CASE 
        WHEN SUM(s.revenue) >= 10000 THEN 'VIP'
        WHEN SUM(s.revenue) >= 5000 THEN 'High Value'
        WHEN SUM(s.revenue) >= 2000 THEN 'Medium Value'
        ELSE 'Standard'
    END AS customer_segment
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- Summary of Segmentation
SELECT 
    revenue_bucket,
    COUNT(*) AS transaction_count,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_transaction
FROM sales
GROUP BY revenue_bucket
ORDER BY total_revenue DESC;