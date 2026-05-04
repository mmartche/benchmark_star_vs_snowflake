-- ============================================================
-- BENCHMARK FINAL: STAR vs SNOWFLAKE
-- ============================================================

\set ON_ERROR_STOP on

DISCARD ALL;

SET work_mem = '256MB';

-- ============================================================
-- TABELA DE RESULTADOS
-- ============================================================

DROP TABLE IF EXISTS benchmark_results;

CREATE TABLE benchmark_results (
    id SERIAL PRIMARY KEY,
    schema_type TEXT,
    query_name TEXT,
    execution_time_ms NUMERIC
);

-- ============================================================
-- BLOCO DE MEDIÇÃO
-- ============================================================

DO $$
DECLARE
    t_start TIMESTAMP;
    t_end TIMESTAMP;
BEGIN

-- ============================================================
-- Q1: SALES POR ANO
-- ============================================================

-- STAR
t_start := clock_timestamp();

PERFORM d.d_year, SUM(f.sales_price)
FROM dw_star.fact_store_sales f
JOIN dw_star.dim_date d ON f.sold_date_key = d.date_key
GROUP BY d.d_year;

t_end := clock_timestamp();

INSERT INTO benchmark_results(schema_type, query_name, execution_time_ms)
VALUES ('STAR', 'Q1_YEARLY_SALES', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- SNOWFLAKE
t_start := clock_timestamp();

PERFORM d.d_year, SUM(f.sales_price)
FROM dw_snowflake.fact_store_sales f
JOIN dw_snowflake.dim_date d ON f.sold_date_key = d.date_key
GROUP BY d.d_year;

t_end := clock_timestamp();

INSERT INTO benchmark_results(schema_type, query_name, execution_time_ms)
VALUES ('SNOWFLAKE', 'Q1_YEARLY_SALES', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- ============================================================
-- Q2: TOP 10 PRODUTOS
-- ============================================================

-- STAR
t_start := clock_timestamp();

PERFORM i.i_item_desc, SUM(f.sales_price)
FROM dw_star.fact_store_sales f
JOIN dw_star.dim_item i ON f.item_key = i.item_key
GROUP BY i.i_item_desc
ORDER BY SUM(f.sales_price) DESC
LIMIT 10;

t_end := clock_timestamp();

INSERT INTO benchmark_results VALUES
(DEFAULT, 'STAR', 'Q2_TOP_PRODUCTS', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- SNOWFLAKE
t_start := clock_timestamp();

PERFORM i.i_item_desc, SUM(f.sales_price)
FROM dw_snowflake.fact_store_sales f
JOIN dw_snowflake.dim_item i ON f.item_key = i.item_key
JOIN dw_snowflake.dim_category c ON i.category_key = c.category_key
GROUP BY i.i_item_desc
ORDER BY SUM(f.sales_price) DESC
LIMIT 10;

t_end := clock_timestamp();

INSERT INTO benchmark_results VALUES
(DEFAULT, 'SNOWFLAKE', 'Q2_TOP_PRODUCTS', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- ============================================================
-- Q3: SALES POR ESTADO
-- ============================================================

-- STAR
t_start := clock_timestamp();

PERFORM s.s_state, SUM(f.sales_price)
FROM dw_star.fact_store_sales f
JOIN dw_star.dim_store s ON f.store_key = s.store_key
GROUP BY s.s_state;

t_end := clock_timestamp();

INSERT INTO benchmark_results VALUES
(DEFAULT, 'STAR', 'Q3_SALES_BY_STATE', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- SNOWFLAKE
t_start := clock_timestamp();

PERFORM s.s_state, SUM(f.sales_price)
FROM dw_snowflake.fact_store_sales f
JOIN dw_snowflake.dim_store s ON f.store_key = s.store_key
GROUP BY s.s_state;

t_end := clock_timestamp();

INSERT INTO benchmark_results VALUES
(DEFAULT, 'SNOWFLAKE', 'Q3_SALES_BY_STATE', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- ============================================================
-- Q4: SALES POR CLIENTE
-- ============================================================

-- STAR
t_start := clock_timestamp();

PERFORM c.c_first_name, c.c_last_name, SUM(f.sales_price)
FROM dw_star.fact_store_sales f
JOIN dw_star.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.c_first_name, c.c_last_name
ORDER BY SUM(f.sales_price) DESC
LIMIT 20;

t_end := clock_timestamp();

INSERT INTO benchmark_results VALUES
(DEFAULT, 'STAR', 'Q4_CUSTOMER_SALES', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

-- SNOWFLAKE
t_start := clock_timestamp();

PERFORM c.c_first_name, c.c_last_name, a.ca_city, SUM(f.sales_price)
FROM dw_snowflake.fact_store_sales f
JOIN dw_snowflake.dim_customer c ON f.customer_key = c.customer_key
JOIN dw_snowflake.dim_customer_address a ON c.address_key = a.address_key
GROUP BY c.c_first_name, c.c_last_name, a.ca_city
ORDER BY SUM(f.sales_price) DESC
LIMIT 20;

t_end := clock_timestamp();

INSERT INTO benchmark_results VALUES
(DEFAULT, 'SNOWFLAKE', 'Q4_CUSTOMER_SALES', EXTRACT(EPOCH FROM (t_end - t_start)) * 1000);

END $$;

-- ============================================================
-- RESULTADOS
-- ============================================================

SELECT *
FROM benchmark_results
ORDER BY query_name, schema_type;