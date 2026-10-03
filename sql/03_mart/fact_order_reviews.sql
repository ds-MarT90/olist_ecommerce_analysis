-- ============================================================
-- MART: fact_order_reviews
-- Purpose: Store customer review data for analyzing review
--          scores and customer experience.
--          Review text is excluded because it is not needed
--          for the main analysis.
-- Grain: 1 row = 1 review.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS mart.fact_order_reviews;

CREATE TABLE mart.fact_order_reviews AS 
SELECT 
	r.review_id,
	r.order_id,
	
	dc.customer_key,
	TO_CHAR(r.review_creation_ts, 'YYYYMMDD')::INTEGER AS review_date_key,
	
	r.review_score,
	EXTRACT(EPOCH FROM (r.review_answer_ts - r.review_creation_ts)) / 3600 AS response_time_hours
	 
FROM stg.order_reviews r
JOIN stg.orders o
	ON r.order_id = o.order_id
JOIN stg.customers c
	ON o.customer_id = c.customer_id 
JOIN mart.dim_customer dc 
	ON c.customer_unique_id = dc.customer_unique_id;

ALTER TABLE mart.fact_order_reviews 
ADD CONSTRAINT fk_order_reviews_customer
FOREIGN KEY (customer_key)
REFERENCES mart.dim_customer(customer_key);

ALTER TABLE mart.fact_order_reviews 
ADD CONSTRAINT fk_order_reviews_date
FOREIGN KEY (review_date_key)
REFERENCES mart.dim_date(date_key);

COMMIT;

-- Sanity check: grain must match stg.order_reviews exactly
SELECT 'fact' AS layer, COUNT(*) AS row_count FROM mart.fact_order_reviews
UNION ALL
SELECT 'stg', COUNT(*) FROM stg.order_reviews;