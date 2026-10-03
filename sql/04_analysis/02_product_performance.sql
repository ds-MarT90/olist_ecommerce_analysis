
-- ============================================================
-- ANALYSIS: vw_product_performance
-- Purpose: Compare product categories by sales volume and
--          total sales value.
--          The view helps identify categories with high sales
--          volume and categories that generate the highest
--          sales value.
-- Grain: 1 row = 1 product category.
-- ============================================================

CREATE OR REPLACE VIEW analysis.vw_product_performance AS

SELECT
    dp.product_category,
    COUNT(f.order_item_id) AS units_sold,
    SUM(f.price)           AS total_sales_value
FROM mart.fact_order_items f
JOIN mart.dim_product dp ON f.product_key = dp.product_key
WHERE f.is_valid_sale = TRUE
GROUP BY dp.product_category
ORDER BY total_sales_value DESC;
