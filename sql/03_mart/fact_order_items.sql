-- ============================================================
-- MART: fact_order_items
-- Purpose: Store order item data together with the keys needed
--          to connect sales with the customer, product, seller,
--          and date dimensions.
--          All order items are kept, while is_valid_sale indicates
--          which records are included in sales analysis.
-- Grain: 1 row = 1 order item.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS mart.fact_order_items;

CREATE TABLE mart.fact_order_items AS
SELECT
    oi.order_id,
    oi.order_item_id,
    o.order_status,
    CASE WHEN o.order_status IN ('delivered', 'shipped')
         THEN TRUE ELSE FALSE
    END AS is_valid_sale,

    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    TO_CHAR(o.order_purchase_ts::DATE, 'YYYYMMDD')::INTEGER AS order_date_key,

    oi.price,
    oi.freight_value

FROM stg.order_items oi
JOIN stg.orders o
    ON oi.order_id = o.order_id
JOIN stg.customers c
    ON o.customer_id = c.customer_id
JOIN mart.dim_customer dc
    ON c.customer_unique_id = dc.customer_unique_id
JOIN mart.dim_product dp
    ON oi.product_id = dp.product_id
JOIN mart.dim_seller ds
    ON oi.seller_id = ds.seller_id;

ALTER TABLE mart.fact_order_items
ADD CONSTRAINT fk_order_items_customer
FOREIGN KEY (customer_key)
REFERENCES mart.dim_customer(customer_key);

ALTER TABLE mart.fact_order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_key)
REFERENCES mart.dim_product(product_key);

ALTER TABLE mart.fact_order_items
ADD CONSTRAINT fk_order_items_seller
FOREIGN KEY (seller_key)
REFERENCES mart.dim_seller(seller_key);

ALTER TABLE mart.fact_order_items
ADD CONSTRAINT fk_order_items_date
FOREIGN KEY (order_date_key)
REFERENCES mart.dim_date(date_key);

COMMIT;

-- Sanity check: grain must match stg.order_items exactly
SELECT 'fact' AS layer, COUNT(*) AS row_count FROM mart.fact_order_items
UNION ALL
SELECT 'stg', COUNT(*) FROM stg.order_items;

-- Extra check: does any row have a NULL dimension key? (would mean a JOIN silently dropped/missed something)
SELECT COUNT(*) AS rows_with_missing_dimension_key
FROM mart.fact_order_items
WHERE customer_key IS NULL OR product_key IS NULL OR seller_key IS NULL OR order_date_key IS NULL;