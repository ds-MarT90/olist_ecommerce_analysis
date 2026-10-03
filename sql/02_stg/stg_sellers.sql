-- ============================================================
-- STG: sellers
-- Purpose: Clean and standardize seller data from RAW.
--          Convert text columns to appropriate data types.
-- Grain: 1 row = 1 seller.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.sellers;

CREATE TABLE stg.sellers AS

SELECT
    TRIM(seller_id) AS seller_id,
    TRIM(seller_zip_code_prefix) AS seller_zip_code_prefix,
    TRIM(seller_city) AS seller_city,
    UPPER(TRIM(seller_state)) AS seller_state
FROM raw.sellers;

COMMIT;

-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.sellers
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.sellers;