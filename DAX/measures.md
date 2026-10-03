# DAX Measures

This file documents the DAX measures used in the Olist E-Commerce Power BI report.

Each report page is built on a standalone SQL view from `sql/analysis/`. The views are analyzed independently, so no relationships are required between them.

Measures are divided into two groups:

- **Base measures** — additive measures calculated directly from the imported view columns using functions such as `SUM` and `COUNT`.
- **Ratio measures** — calculated from base measures using `DIVIDE`. This keeps ratios responsive to filters and the current report context instead of calculating them as fixed values in SQL.

Each measure is validated against the corresponding SQL results before being used in the report visualizations.

---


## Page 1. Sales

*Source view: `analysis.vw_sales_monthly` (grain: 1 row = 1 month)*

### Base measures

```DAX
Total Sales Value = 
SUM('analysis vw_sales_monthly'[total_sales_value])
```

```DAX
Order Count = 
SUM('analysis vw_sales_monthly'[order_count])
```

### Ratio measures

```DAX
Avg Order Value = 
DIVIDE(
    [Total Sales Value],
    [Order Count]
)
```

---

## Page 2. Customers

*Source view: `analysis.vw_customer_value` (grain: 1 row = 1 customer type: `one_time` / `returning`)*

### Base measures

```DAX
Customer Count = 
SUM('analysis vw_customer_value'[customer_count])
```

```DAX
Customer Sales Value = 
SUM('analysis vw_customer_value'[total_sales_value])
```

### Ratio measures

```DAX
Avg Value per Customer = 
DIVIDE(
    [Customer Sales Value],
    [Customer Count]
)
```

```DAX
Customer Share % = 
DIVIDE(
    [Customer Count],
    CALCULATE(
        [Customer Count],
        ALLSELECTED('analysis vw_customer_value')
    )
)
```

```DAX
Sales Share % = 
DIVIDE(
    [Customer Sales Value],
    CALCULATE(
        [Customer Sales Value],
        ALLSELECTED('analysis vw_customer_value')
    )
)
```

### Returning customer KPIs

```DAX
Returning Customers % = 
DIVIDE(
    CALCULATE(
        [Customer Count],
        'analysis vw_customer_value'[customer_type] = "returning"
    ),
    CALCULATE(
        [Customer Count],
        REMOVEFILTERS('analysis vw_customer_value'[customer_type])
    )
)
```

```DAX
Returning Sales Share % = 
DIVIDE(
    CALCULATE(
        [Customer Sales Value],
        'analysis vw_customer_value'[customer_type] = "returning"
    ),
    CALCULATE(
        [Customer Sales Value],
        REMOVEFILTERS('analysis vw_customer_value'[customer_type])
    )
)
```

```DAX
Returning Value Multiple = 
DIVIDE(
    CALCULATE(
        [Avg Value per Customer],
        'analysis vw_customer_value'[customer_type] = "returning"
    ),
    CALCULATE(
        [Avg Value per Customer],
        'analysis vw_customer_value'[customer_type] = "one_time"
    )
)
```

### Frequency vs. basket size (explains WHY returning customers are worth more)

```DAX
Total Orders = 
SUM('analysis vw_customer_value'[total_orders])
```

```DAX
Avg Orders per Customer = 
DIVIDE([Total Orders], [Customer Count])
```

```DAX
Customer Avg Order Value = 
DIVIDE([Customer Sales Value], [Total Orders])
```

> Note: named `Customer Avg Order Value`, not `Avg Order Value`, because that
> name is already used by the Sales page measure — measure names must be
> unique across the whole model.

> Note: measure names are unique across the whole model, which is why the
> Customers page uses `Customer Sales Value` instead of reusing
> `Total Sales Value` from the Sales page.

---

## Page 3. Product Performance

*Source view: `analysis.vw_product_performance` (grain: 1 row = 1 product category)*

### Base measures

```DAX
Product Sales Value = 
SUM('analysis vw_product_performance'[total_sales_value])
```

```DAX
Units Sold = 
SUM('analysis vw_product_performance'[units_sold])
```

```DAX
Category Count = 
DISTINCTCOUNT('analysis vw_product_performance'[product_category])
```

### Ratio measures

```DAX
Avg Item Price = 
DIVIDE([Product Sales Value], [Units Sold])
```

> Note: no cost/margin data exists in the source (see README data
> limitations) — this page deliberately covers revenue and volume only.

---

## Page 4. Delivery & Satisfaction

*Source view: `analysis.vw_delivery_satisfaction` (grain: 1 row = 1 delay bucket)*

### Base measures

```DAX
Review Count = 
SUM('analysis vw_delivery_satisfaction'[review_count])
```

```DAX
Review Score Sum = 
SUM('analysis vw_delivery_satisfaction'[review_score_sum])
```

### Ratio measures

```DAX
Avg Review Score = 
DIVIDE([Review Score Sum], [Review Count])
```

### Comparison KPIs (on-time vs. severely late)

```DAX
On Time Avg Score = 
CALCULATE(
    [Avg Review Score],
    'analysis vw_delivery_satisfaction'[delay_bucket] = "on time"
)
```

```DAX
Late 15 Plus Avg Score = 
CALCULATE(
    [Avg Review Score],
    'analysis vw_delivery_satisfaction'[delay_bucket] = "15+ days late"
)
```

```DAX
Score Drop = 
[On Time Avg Score] - [Late 15 Plus Avg Score]
```

```DAX
Late Delivery Rate = 
1 - DIVIDE(
    CALCULATE(
        [Review Count],
        'analysis vw_delivery_satisfaction'[delay_bucket] = "on time"
    ),
    CALCULATE(
        [Review Count],
        REMOVEFILTERS('analysis vw_delivery_satisfaction'[delay_bucket])
    )
)
```

