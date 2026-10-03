-- ============================================================
-- LOAD RAW TABLES FROM CSV FILES
-- The script supports a full reload of RAW tables.
-- ============================================================

BEGIN;


TRUNCATE TABLE
    raw.customers,
    raw.geolocation,
    raw.order_items,
    raw.order_payments,
    raw.order_reviews,
    raw.orders,
    raw.products,
    raw.sellers,
    raw.product_category_translation;


COPY raw.customers
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_customers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.geolocation
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_geolocation_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.order_items
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_order_items_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.order_payments
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_order_payments_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.order_reviews
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_order_reviews_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.orders
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_orders_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.products
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_products_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.sellers
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\olist_sellers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COPY raw.product_category_translation
FROM 'C:\MyStuff\Projects\olist_ecommerce_analysis\data\product_category_name_translation.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


COMMIT;