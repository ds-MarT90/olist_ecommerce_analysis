-- ============================================================
-- STG: customers
-- Purpose: Clean and standardize customer data from RAW.
--          Convert text columns to appropriate data types.
-- Grain: 1 row = 1 customer record.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.customers;

CREATE TABLE stg.customers AS

SELECT
	TRIM(customer_id) 					AS customer_id,
	TRIM(customer_unique_id) 			AS customer_unique_id,
	TRIM(customer_zip_code_prefix) 		AS customer_zip_code_prefix,
	LOWER(TRIM(customer_city)) 			AS customer_city,
	UPPER(TRIM(customer_state))			AS customer_state
FROM raw.customers;

COMMIT;
	
-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.customers
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.customers;

