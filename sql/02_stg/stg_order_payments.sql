-- ============================================================
-- STG: order_payments
-- Purpose: Clean and standardize payment data from RAW.
--          Convert text columns to appropriate data types.
-- Grain: 1 row = 1 payment record.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.order_payments;

CREATE TABLE stg.order_payments AS

SELECT
	TRIM(order_id) AS order_id,
	payment_sequential::INTEGER 	AS payment_sequential,
	LOWER(TRIM(payment_type)) 		AS payment_type,
	payment_installments::INTEGER 	AS payment_installments,
	payment_value::NUMERIC(10,2) 	AS payment_value
FROM raw.order_payments;
	
COMMIT;

-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.order_payments
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.order_payments;
