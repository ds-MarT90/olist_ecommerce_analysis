-- ============================================================
-- STG: products
-- Purpose: Clean and standardize product data from RAW.
--          Correct source naming and convert columns to appropriate data types.
-- Grain: 1 row = 1 product.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.products;

CREATE TABLE stg.products AS

SELECT
    TRIM(product_id) 					AS product_id,
    TRIM(product_category_name) 		AS product_category_name,
    product_name_lenght::INTEGER 		AS product_name_length,
    product_description_lenght::INTEGER AS product_description_length,
    product_photos_qty::INTEGER 		AS product_photos_qty,
    product_weight_g::NUMERIC(10,2) 	AS product_weight_g,
    product_length_cm::NUMERIC(10,2)	AS product_length_cm,
    product_height_cm::NUMERIC(10,2) 	AS product_height_cm,
    product_width_cm::NUMERIC(10,2) 	AS product_width_cm
FROM raw.products;

COMMIT;

-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.products
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.products;
