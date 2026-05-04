-- ============================================================
-- Helper metrics for storage and row counts
-- ============================================================

-- STAR schema sizes
SELECT 'dw_star_tpcds' AS schema_name,
       relname AS object_name,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'dw_star_tpcds'
  AND c.relkind IN ('r','i')
ORDER BY pg_total_relation_size(c.oid) DESC;

-- SNOW schema sizes
SELECT 'dw_snow_tpcds' AS schema_name,
       relname AS object_name,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'dw_snow_tpcds'
  AND c.relkind IN ('r','i')
ORDER BY pg_total_relation_size(c.oid) DESC;

-- Row counts
SELECT 'star_fact' AS object_name, COUNT(*) FROM dw_star_tpcds.fact_store_sales
UNION ALL
SELECT 'snow_fact', COUNT(*) FROM dw_snow_tpcds.fact_store_sales
UNION ALL
SELECT 'star_dim_item', COUNT(*) FROM dw_star_tpcds.dim_item
UNION ALL
SELECT 'snow_dim_item', COUNT(*) FROM dw_snow_tpcds.dim_item;
