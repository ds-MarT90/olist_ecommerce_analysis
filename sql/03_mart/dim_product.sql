-- ============================================================
-- MART: dim_product
-- Purpose: Create a product dimension containing product details
--          together with the English product category name.
--          Category information is kept directly in this dimension
--          to keep the star schema simple.
-- Grain: 1 row = 1 product.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS mart.dim_product;

CREATE TABLE mart.dim_product AS
SELECT
	p.product_id,
	COALESCE(t.product_category_name_english, p.product_category_name, 'unknown' ) AS product_category,
	p.product_name_length,
	p.product_description_length,
	p.product_photos_qty,
	p.product_weight_g,
	p.product_length_cm,
	p.product_height_cm,
	p.product_width_cm	
FROM stg.products p
LEFT JOIN stg.product_category_translation t
	ON p.product_category_name = t.product_category_name;

ALTER TABLE mart.dim_product ADD COLUMN product_key SERIAL PRIMARY KEY;
ALTER TABLE mart.dim_product ADD CONSTRAINT uq_product_id UNIQUE (product_id);

COMMIT;

-- Sanity check: grain must match stg.products (1 row per product)
SELECT COUNT(*) AS product_count FROM mart.dim_product
UNION ALL 
SELECT COUNT(*) FROM stg.products;

-- Extra check: how many products ended up with the 'unknown' product_category?
SELECT COUNT(*) AS unknown_category_count
FROM mart.dim_product
WHERE product_category = 'unknown';


