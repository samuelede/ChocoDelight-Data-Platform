-- =============================================
-- 04_views_analytics.sql
-- Business Analytics Views (Task 3)
-- =============================================

-- Revenue by Product (with rich details)
CREATE OR REPLACE VIEW vw_revenue_by_product AS
SELECT 
    p.product_name,
    p.brand,
    p.category,
    p.cocoa_percent,
    SUM(s.revenue) AS total_revenue,
    SUM(s.quantity) AS total_units_sold,
    ROUND(AVG(s.unit_price), 2) AS avg_unit_price,
    COUNT(DISTINCT s.order_id) AS transaction_count,
    ROUND(SUM(s.profit), 2) AS total_profit
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.brand, p.category, p.cocoa_percent
ORDER BY total_revenue DESC;

-- Revenue by Store / Country
CREATE OR REPLACE VIEW vw_revenue_by_store AS
SELECT 
    st.country,
    st.city,
    st.store_name,
    st.store_type,
    SUM(s.revenue) AS total_revenue,
    ROUND(SUM(s.profit), 2) AS total_profit,
    SUM(s.quantity) AS total_quantity,
    COUNT(DISTINCT s.order_id) AS total_orders
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.country, st.city, st.store_name, st.store_type
ORDER BY total_revenue DESC;

-- Monthly Sales Trends
CREATE OR REPLACE VIEW vw_monthly_trends AS
SELECT 
    c.year,
    c.month,
    TO_CHAR(c.date, 'Month') AS month_name,
    SUM(s.revenue) AS monthly_revenue,
    ROUND(SUM(s.profit), 2) AS monthly_profit,
    SUM(s.quantity) AS monthly_quantity,
    COUNT(DISTINCT s.order_id) AS order_count
FROM sales s
JOIN calendar c ON s.order_date = c.date
GROUP BY c.year, c.month, TO_CHAR(c.date, 'Month')
ORDER BY c.year DESC, c.month DESC;

-- Bonus View: Revenue by Season
CREATE OR REPLACE VIEW vw_revenue_by_season AS
SELECT 
    s.sale_season,
    c.year,
    SUM(s.revenue) AS seasonal_revenue,
    ROUND(SUM(s.profit), 2) AS seasonal_profit,
    SUM(s.quantity) AS units_sold
FROM sales s
JOIN calendar c ON s.order_date = c.date
GROUP BY s.sale_season, c.year
ORDER BY c.year DESC, seasonal_revenue DESC;