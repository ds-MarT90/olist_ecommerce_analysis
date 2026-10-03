-- =========================================================
-- RAW SANITY CHECKS
-- Purpose: Validate the basic structure, completeness, and consistency
-- of the raw data before moving to the staging layer.
--
-- The checks focus on row counts, missing values, duplicates,
-- table relationships, date coverage, and basic value validity.
-- The results help identify potential data issues and define
-- what needs to be handled during staging.
-- =========================================================

-- 1. Count of rows for every table

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM raw.geolocation
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM raw.order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM raw.order_reviews
UNION ALL
SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL
SELECT 'products', COUNT(*) FROM raw.products
UNION ALL
SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM raw.product_category_translation
ORDER BY table_name; 


-- 2. Check whether key fields and the order date contain missing or empty values.
SELECT
    COUNT(*) FILTER(WHERE NULLIF(TRIM(order_id), '') 	  			 IS NULL) AS order_id_missing,
    COUNT(*) FILTER(WHERE NULLIF(TRIM(customer_id), '')			   	 IS NULL) AS customer_id_missing,
    COUNT(*) FILTER(WHERE NULLIF(TRIM(order_purchase_timestamp), '') IS NULL) AS order_purchase_timestamp_missing
FROM raw.orders;

-- 3. Check whether the main dimension tables contain missing or empty primary keys. 

SELECT 'customers' AS table_name, COUNT(*) FILTER (WHERE NULLIF(TRIM(customer_id), '') IS NULL) AS missing_keys FROM raw.customers
UNION ALL
SELECT 'products', COUNT(*) FILTER (WHERE NULLIF(TRIM(product_id), '')  			   IS NULL) FROM raw.products
UNION ALL
SELECT 'sellers', COUNT(*) FILTER (WHERE NULLIF(TRIM(seller_id), '') 				   IS NULL) FROM raw.sellers;

-- 4. Check whether the fields needed to calculate order value contain missing or empty values.

SELECT
    COUNT(*) FILTER (WHERE NULLIF(TRIM(order_id), '') 	   IS NULL) AS order_id_missing,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(product_id), '')    IS NULL) AS product_id_missing,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(price), '') 		   IS NULL) AS price_missing,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(freight_value), '') IS NULL) AS freight_value_missing
FROM raw.order_items;

-- 5. Time period for orders. Check whether every order can be matched to an existing customer.

SELECT
    MIN(order_purchase_timestamp) AS min_order_date,
    MAX(order_purchase_timestamp) AS max_order_date
FROM raw.orders;

-- 6. Check whether every order can be matched to an existing customer.

SELECT
    COUNT(*) AS orders_rows,
    COUNT(c.customer_id) AS matched_customers,
    COUNT(*) - COUNT(c.customer_id) AS missing_customers
FROM raw.orders o
LEFT JOIN raw.customers c
    ON o.customer_id = c.customer_id;

-- 7. Check whether every order item can be matched to an existing product and seller.

SELECT
    COUNT(*) AS order_items_rows,
    COUNT(p.product_id) AS matched_products,
    COUNT(s.seller_id) AS matched_sellers,
    COUNT(*) - COUNT(p.product_id) AS missing_products,
    COUNT(*) - COUNT(s.seller_id) AS missing_sellers
FROM raw.order_items oi
LEFT JOIN raw.products p
    ON oi.product_id = p.product_id
LEFT JOIN raw.sellers s
    ON oi.seller_id = s.seller_id;

-- 8. Check whether every payment record can be matched to an existing order.

SELECT
    COUNT(*) AS payment_rows,
    COUNT(o.order_id) AS matched_orders,
    COUNT(*) - COUNT(o.order_id) AS missing_orders
FROM raw.order_payments p
LEFT JOIN raw.orders o
    ON p.order_id = o.order_id;


