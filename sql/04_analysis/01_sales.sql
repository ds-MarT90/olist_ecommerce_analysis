-- ============================================================
-- ANALYSIS: vw_order_value
-- Purpose: Aggregate order items to the order level so that
--          each row represents one order.
--          This view is used as a base for sales analysis.
-- Grain: 1 row = 1 order.
-- ============================================================

CREATE OR REPLACE VIEW analysis.vw_order_value AS

SELECT 
	order_id,
	customer_key,
	order_date_key,
	SUM(price) AS order_value	
FROM mart.fact_order_items
WHERE is_valid_sale = TRUE
GROUP BY order_id, customer_key, order_date_key
ORDER BY customer_key DESC;

-- ============================================================
-- ANALYSIS: vw_sales_monthly
-- Purpose: Summarize sales by month, including order count and
--          total sales value.
-- Grain: 1 row = 1 month.
-- ============================================================

CREATE OR REPLACE VIEW analysis.vw_sales_monthly AS

SELECT 
	dd.year,
	dd.month,
	dd.month_name,
	COUNT(ov.order_id) 	AS order_count,
	SUM(ov.order_value) AS total_sales_value
FROM analysis.vw_order_value ov
JOIN mart.dim_date dd
	ON ov.order_date_key = dd.date_key
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY dd.year, dd.month;

SELECT 
	SUM(total_sales_value)
FROM analysis.vw_sales_monthly;


