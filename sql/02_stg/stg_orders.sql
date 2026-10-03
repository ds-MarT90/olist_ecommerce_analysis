-- ============================================================
-- STG: orders
-- Purpose: Clean and standardize order data from RAW.
--         Convert text columns to appropriate data types.
-- Grain: 1 row = 1 order.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.orders;

CREATE TABLE stg.orders AS

SELECT
	TRIM(order_id) 							 AS order_id,
	TRIM(customer_id) 						 AS customer_id,
	LOWER(TRIM(order_status)) 				 AS order_status,
	order_purchase_timestamp::TIMESTAMP 	 AS order_purchase_ts,
	order_approved_at::TIMESTAMP 			 AS order_approved_ts,
	order_delivered_carrier_date::TIMESTAMP  AS order_delivered_carrier_ts,
	order_delivered_customer_date::TIMESTAMP AS order_delivered_customer_ts,
	order_estimated_delivery_date::TIMESTAMP AS order_estimated_delivery_ts
FROM raw.orders;

COMMIT;

-- Sanity check: Check that the number of rows matches RAW.
SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.orders
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.orders;

