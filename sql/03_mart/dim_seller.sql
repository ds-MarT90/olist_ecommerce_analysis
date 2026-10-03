-- ============================================================
-- MART: dim_seller
-- Purpose: Store seller information used for sales analysis.
-- Grain: 1 row = 1 seller.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS mart.dim_seller;

CREATE TABLE mart.dim_seller AS
SELECT
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix
FROM stg.sellers;

ALTER TABLE mart.dim_seller ADD COLUMN seller_key SERIAL PRIMARY KEY;
ALTER TABLE mart.dim_seller ADD CONSTRAINT uq_seller_id UNIQUE (seller_id);

COMMIT;

-- Sanity check
SELECT COUNT(*) AS seller_count FROM mart.dim_seller;