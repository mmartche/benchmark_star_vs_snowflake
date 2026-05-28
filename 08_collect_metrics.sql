-- ============================================================
-- 08_storage_metrics.sql
-- ============================================================

-- ============================================================
-- STAR SCHEMA SIZES
-- ============================================================

SELECT 'dw_star' AS schema_name,
       relname AS object_name,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM pg_class c
JOIN pg_namespace n
  ON n.oid = c.relnamespace
WHERE n.nspname = 'dw_star'
  AND c.relkind IN ('r','i')
ORDER BY pg_total_relation_size(c.oid) DESC;

-- ============================================================
-- SNOWFLAKE SCHEMA SIZES
-- ============================================================

SELECT 'dw_snow_tpcds' AS schema_name,
       relname AS object_name,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM pg_class c
JOIN pg_namespace n
  ON n.oid = c.relnamespace
WHERE n.nspname = 'dw_snow_tpcds'
  AND c.relkind IN ('r','i')
ORDER BY pg_total_relation_size(c.oid) DESC;

-- ============================================================
-- ROW COUNTS
-- ============================================================

SELECT 'star_fact' AS object_name,
       COUNT(*)
FROM dw_star.fact_store_sales

UNION ALL

SELECT 'snow_fact',
       COUNT(*)
FROM dw_snow_tpcds.fact_store_sales

UNION ALL

SELECT 'star_dim_item',
       COUNT(*)
FROM dw_star.dim_item

UNION ALL

SELECT 'snow_dim_item',
       COUNT(*)
FROM dw_snow_tpcds.dim_item;

-- ============================================================
-- FACT TABLE SIZE COMPARISON
-- ============================================================

SELECT
    'STAR' AS schema_type,
    pg_size_pretty(
        pg_total_relation_size(
            'dw_star.fact_store_sales'
        )
    ) AS fact_size

UNION ALL

SELECT
    'SNOWFLAKE',
    pg_size_pretty(
        pg_total_relation_size(
            'dw_snow_tpcds.fact_store_sales'
        )
    );

-- ============================================================
-- VALIDATION
-- ============================================================

-- Expected:
-- STAR fact table: several GB
-- SNOWFLAKE fact table: several GB
-- Row counts should be similar