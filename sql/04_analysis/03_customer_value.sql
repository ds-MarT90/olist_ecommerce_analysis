-- ============================================================
-- ANALYSIS: vw_customer_value
-- Purpose: Classify customers based on their number of orders
--          and compare one-time and returning customers by
--          customer count and sales value.
-- Grain: 1 row = 1 customer type.
-- ============================================================


CREATE OR REPLACE VIEW analysis.vw_customer_value AS

WITH customer_orders AS (
	SELECT
		customer_key,
		COUNT(order_id)  AS order_count,
		SUM(order_value) AS total_value
	FROM analysis.vw_order_value
	GROUP BY customer_key
)
SELECT 
	CASE WHEN order_count = 1 THEN 'one_time' ELSE 'returning' END 		AS customer_type,
	COUNT(*) 															AS customer_count,
	SUM(order_count)     												AS total_orders,
	SUM(total_value)													AS total_sales_value
FROM customer_orders 
GROUP BY customer_type;
	
	
	