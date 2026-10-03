-- ============================================================
-- MART: dim_customer
-- Purpose: One row per real, unique customer (customer_unique_id),
-- 			not per order. The dataset description notes that customer_id
-- 			identifies an order-specific customer record, while
-- 			customer_unique_id identifies the actual customer across orders.
-- 			We resolve this by keeping one record per customer_unique_id
-- 			and using SCD Type 1: for each unique customer, we keep the
-- 			address/location data from their most recent order.
-- Grain: 1 row = 1 unique real customer.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS mart.dim_customer;

CREATE TABLE mart.dim_customer AS 
SELECT
	ranked.customer_unique_id,
	ranked.customer_city,
	ranked.customer_state,
	ranked.customer_zip_code_prefix	
FROM (
	SELECT
		c.customer_unique_id,
		c.customer_zip_code_prefix,
		c.customer_city,
		c.customer_state,
		ROW_NUMBER() OVER(
			PARTITION BY c.customer_unique_id
			ORDER BY o.order_purchase_ts DESC
			) AS rn
	FROM stg.customers c
	JOIN stg.orders o
		ON c.customer_id = o.customer_id
) AS ranked
WHERE ranked.rn = 1;

ALTER TABLE mart.dim_customer ADD COLUMN customer_key SERIAL PRIMARY KEY;
ALTER TABLE mart.dim_customer ADD CONSTRAINT uq_customer_unique_id UNIQUE (customer_unique_id);

COMMIT;

-- Sanity check: should equal COUNT(DISTINCT customer_unique_id) = 96 096
SELECT COUNT(*) AS unique_customers FROM mart.dim_customer;
	
	
	