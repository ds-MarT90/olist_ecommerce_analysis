-- ============================================================
-- STG: order_reviews
-- Purpose: Clean and standardize review data from RAW.
--          Convert text columns to appropriate data types.
-- Grain: 1 row = 1 review record.
-- No joins or business logic at this stage.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS stg.order_reviews;

CREATE TABLE stg.order_reviews AS 

SELECT
	TRIM(review_id) AS review_id,
	TRIM(order_id) AS order_id,
	review_score::INTEGER AS review_score,
	TRIM(review_comment_title) AS review_comment_title,
	TRIM(review_comment_message) AS review_comment_message,
	review_creation_date::TIMESTAMP AS review_creation_ts,
	review_answer_timestamp::TIMESTAMP AS review_answer_ts
FROM raw.order_reviews;

COMMIT;
	
-- Sanity check: Check that the number of rows matches RAW.

SELECT 'stg' AS layer, COUNT(*) AS number_of_records FROM stg.order_reviews
UNION ALL 
SELECT 'raw', COUNT(*) FROM raw.order_reviews;

