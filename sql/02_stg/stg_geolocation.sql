-- ============================================================
-- STG: geolocation
-- Purpose: Clean and standardize geolocation data from RAW.
--          Convert text columns to appropriate data types.
-- Grain: 1 row = 1 geolocation record.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.geolocation;

CREATE TABLE stg.geolocation AS 

SELECT
	TRIM(geolocation_zip_code_prefix) 	AS geolocation_zip_code_prefix,
	geolocation_lat::NUMERIC(10,6) 		AS geolocation_lat,
	geolocation_lng::NUMERIC(10,6) 		AS geolocation_lng,
	TRIM(geolocation_city) 				AS geolocation_city,
	UPPER(TRIM(geolocation_state)) 		AS geolocation_state
FROM raw.geolocation;

COMMIT;

-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.geolocation
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.geolocation;


	