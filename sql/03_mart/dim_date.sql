-- ============================================================
-- MART: dim_date
-- Purpose: Create a calendar table used for filtering and
--          grouping data by date, month, quarter, and year.
--          The dates are generated rather than taken from the source data.
-- Grain: 1 row = 1 calendar day.
-- ============================================================

BEGIN;

DROP TABLE IF EXISTS mart.dim_date;

CREATE TABLE mart.dim_date AS 
SELECT
	TO_CHAR(dates, 'YYYYMMDD')::INTEGER 	AS date_key,
	dates::DATE 							AS full_date,
	EXTRACT(YEAR FROM dates)::INTEGER   	AS year,
	EXTRACT(QUARTER FROM dates)::INTEGER	AS quarter,
	EXTRACT(MONTH FROM dates)::INTEGER  	AS month,
	TO_CHAR(dates, 'FMMonth')           	AS month_name,
	EXTRACT(DAY FROM dates)::INTEGER		AS day_of_month,
	EXTRACT(ISODOW FROM dates)::INTEGER 	AS day_of_week,
	TO_CHAR(dates, 'FMDay')					AS day_name,
	CASE WHEN EXTRACT(ISODOW FROM dates) IN (6,7) THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series(
'2016-09-01'::DATE,
'2018-10-31'::DATE,
'1 day'::INTERVAL
) AS dates;

ALTER TABLE mart.dim_date ADD PRIMARY KEY (date_key);

COMMIT;

-- Sanity check: row count should equal the number of days in the range.
SELECT COUNT(*) AS days_generated
FROM mart.dim_date;

	