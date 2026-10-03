-- ============================================================
-- STG: order_items
-- Purpose: Clean and standardize order item data from RAW.
--          Convert text columns to appropriate data types.
-- Grain: 1 row = 1 order item.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.order_items;

CREATE TABLE stg.order_items AS 

SELECT
	TRIM(order_id) 					AS order_id,
	order_item_id::INTEGER 			AS order_item_id,
	TRIM(product_id) 				AS product_id,
	TRIM(seller_id) 				AS seller_id,
	shipping_limit_date::TIMESTAMP  AS shipping_limit_ts,
	price::NUMERIC(10,2) 			AS price,
	freight_value::NUMERIC(10,2)	AS freight_value
FROM raw.order_items;

COMMIT;

-- Sanity check: Check that the number of rows matches RAW.
SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.order_items
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.order_items;