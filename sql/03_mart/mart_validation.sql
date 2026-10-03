-- ============================================================
-- MART VALIDATION
-- Purpose: Final validation of the MART layer before connecting
--          the model to Power BI. Checks relationships between
--          fact and dimension tables and validates basic measures.
-- ============================================================

-- 1. Row counts across the whole model
SELECT 'dim_date' AS table_name, COUNT(*) AS row_count FROM mart.dim_date
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM mart.dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM mart.dim_product
UNION ALL
SELECT 'dim_seller', COUNT(*) FROM mart.dim_seller
UNION ALL
SELECT 'fact_order_items', COUNT(*) FROM mart.fact_order_items
UNION ALL
SELECT 'fact_order_payments', COUNT(*) FROM mart.fact_order_payments
UNION ALL
SELECT 'fact_order_reviews', COUNT(*) FROM mart.fact_order_reviews
ORDER BY table_name;

-- 2. Referential integrity: fact_order_items
SELECT 
    COUNT(*) AS total_rows,
    COUNT(dc.customer_key) AS matched_customer,
    COUNT(dp.product_key)  AS matched_product,
    COUNT(ds.seller_key)   AS matched_seller,
    COUNT(dd.date_key)     AS matched_date
FROM mart.fact_order_items f
LEFT JOIN mart.dim_customer dc ON f.customer_key = dc.customer_key
LEFT JOIN mart.dim_product dp  ON f.product_key = dp.product_key
LEFT JOIN mart.dim_seller ds   ON f.seller_key = ds.seller_key
LEFT JOIN mart.dim_date dd     ON f.order_date_key = dd.date_key;

-- 3. Referential integrity: fact_order_payments
SELECT 
    COUNT(*) AS total_rows,
    COUNT(dc.customer_key) AS matched_customer,
    COUNT(dd.date_key)     AS matched_date
FROM mart.fact_order_payments f
LEFT JOIN mart.dim_customer dc ON f.customer_key = dc.customer_key
LEFT JOIN mart.dim_date dd     ON f.order_date_key = dd.date_key;

-- 4. Referential integrity: fact_order_reviews 
SELECT 
    COUNT(*) AS total_rows,
    COUNT(dc.customer_key) AS matched_customer,
    COUNT(dd.date_key)     AS matched_date
FROM mart.fact_order_reviews f
LEFT JOIN mart.dim_customer dc ON f.customer_key = dc.customer_key
LEFT JOIN mart.dim_date dd     ON f.review_date_key = dd.date_key;

-- 5. Measure sanity checks
SELECT
    COUNT(*) FILTER (WHERE price < 0)          AS negative_price,
    COUNT(*) FILTER (WHERE freight_value < 0)   AS negative_freight
FROM mart.fact_order_items;

SELECT
    COUNT(*) FILTER (WHERE payment_value < 0) AS negative_payment_value
FROM mart.fact_order_payments;

SELECT
    COUNT(*) FILTER (WHERE review_score NOT BETWEEN 1 AND 5) AS review_score_out_of_range,
    COUNT(*) FILTER (WHERE response_time_hours < 0)          AS negative_response_time
FROM mart.fact_order_reviews;