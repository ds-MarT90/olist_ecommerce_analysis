-- ============================================================
-- STG: product_category_translation
-- Purpose: Clean and standardize product category translations from RAW.
-- Grain: 1 row = 1 category translation.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.product_category_translation;

CREATE TABLE stg.product_category_translation AS

SELECT
	TRIM(product_category_name) AS product_category_name,
	TRIM(product_category_name_english) AS product_category_name_english
FROM raw.product_category_translation;

COMMIT;

-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.product_category_translation
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.product_category_translation;