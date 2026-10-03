-- ============================================================
-- ANALYSIS: vw_delivery_satisfaction
-- Purpose: Compare delivery performance with customer review
--          scores by grouping orders into delivery delay buckets.
--          The view helps assess whether delivery delays are
--          associated with differences in customer review scores.
-- Grain: 1 row = 1 delivery delay bucket.
-- ============================================================


CREATE OR REPLACE VIEW analysis.vw_delivery_satisfaction AS

SELECT
    CASE
        WHEN o.order_delivered_customer_ts <= o.order_estimated_delivery_ts THEN 'on time'
        WHEN o.order_delivered_customer_ts - o.order_estimated_delivery_ts <= INTERVAL '3 days'  THEN '1-3 days late'
        WHEN o.order_delivered_customer_ts - o.order_estimated_delivery_ts <= INTERVAL '7 days'  THEN '4-7 days late'
        WHEN o.order_delivered_customer_ts - o.order_estimated_delivery_ts <= INTERVAL '14 days' THEN '8-14 days late'
        ELSE '15+ days late'
    END AS delay_bucket,
    CASE
        WHEN o.order_delivered_customer_ts <= o.order_estimated_delivery_ts THEN 1
        WHEN o.order_delivered_customer_ts - o.order_estimated_delivery_ts <= INTERVAL '3 days'  THEN 2
        WHEN o.order_delivered_customer_ts - o.order_estimated_delivery_ts <= INTERVAL '7 days'  THEN 3
        WHEN o.order_delivered_customer_ts - o.order_estimated_delivery_ts <= INTERVAL '14 days' THEN 4
        ELSE 5
    END AS delay_bucket_sort,
    COUNT(*)            AS review_count,
    SUM(r.review_score) AS review_score_sum
FROM stg.orders o
JOIN mart.fact_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_ts IS NOT NULL
GROUP BY delay_bucket, delay_bucket_sort
ORDER BY delay_bucket_sort;