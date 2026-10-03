-- ============================================================
-- MART: fact_order_payments
-- Purpose: Store payment information for each order.
--          An order can have multiple payment records, so
--          payments are kept in a separate fact table.
-- Grain: 1 row = 1 payment record.
-- ============================================================

BEGIN;
DROP TABLE IF EXISTS mart.fact_order_payments;

CREATE TABLE mart.fact_order_payments AS 
SELECT
	p.order_id,
	p.payment_sequential,
	p.payment_type,
	
	dc.customer_key,
	TO_CHAR(o.order_purchase_ts::DATE, 'YYYYMMDD')::INTEGER AS order_date_key,
	
	p.payment_installments,
	p.payment_value

FROM stg.order_payments p
JOIN stg.orders o 
	ON p.order_id = o.order_id 
JOIN stg.customers c 
	ON o.customer_id = c.customer_id 
JOIN mart.dim_customer dc
	ON c.customer_unique_id = dc.customer_unique_id;

ALTER TABLE mart.fact_order_payments
ADD CONSTRAINT fk_order_payments_customer
FOREIGN KEY (customer_key)
REFERENCES mart.dim_customer(customer_key);

ALTER TABLE mart.fact_order_payments 
ADD CONSTRAINT fk_fact_order_payments_date
FOREIGN KEY (order_date_key)
REFERENCES mart.dim_date(date_key);

COMMIT;


-- Sanity check: grain must match stg.order_payments exactly
SELECT 'fact' AS layer, COUNT(*) AS row_count FROM mart.fact_order_payments
UNION ALL
SELECT 'stg', COUNT(*) FROM stg.order_payments;