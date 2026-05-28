-- ============================================================
-- 07_benchmark_queries_tpcds.sql
-- FINAL VERSION
-- ============================================================

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS benchmark_results;

CREATE TABLE benchmark_results (
    run_id SERIAL PRIMARY KEY,
    query_name TEXT,
    schema_type TEXT,
    execution_time_ms NUMERIC,
    execution_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- CONFIGURATION
-- ============================================================

DO $$
DECLARE
    i INTEGER;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    elapsed_ms NUMERIC;
BEGIN

-- ============================================================
-- RUN EACH QUERY 10 TIMES
-- ============================================================

FOR i IN 1..10 LOOP

    -- ========================================================
    -- Q1 YEARLY SALES (STAR)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM d.d_year,
           SUM(f.net_paid)
    FROM dw_star.fact_store_sales f
    JOIN dw_star.dim_date d
      ON f.sold_date_key = d.date_key
    GROUP BY d.d_year;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q1_YEARLY_SALES',
        'STAR',
        elapsed_ms
    );

    -- ========================================================
    -- Q1 YEARLY SALES (SNOWFLAKE)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM d.d_year,
           SUM(f.net_paid)
    FROM dw_snow_tpcds.fact_store_sales f
    JOIN dw_snow_tpcds.dim_date d
      ON f.sold_date_key = d.date_key
    GROUP BY d.d_year;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q1_YEARLY_SALES',
        'SNOWFLAKE',
        elapsed_ms
    );

    -- ========================================================
    -- Q2 TOP PRODUCTS (STAR)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM item_key,
           SUM(net_paid)
    FROM dw_star.fact_store_sales
    GROUP BY item_key
    ORDER BY SUM(net_paid) DESC
    LIMIT 10;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q2_TOP_PRODUCTS',
        'STAR',
        elapsed_ms
    );

    -- ========================================================
    -- Q2 TOP PRODUCTS (SNOWFLAKE)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM i.item_key,
           SUM(f.net_paid)
    FROM dw_snow_tpcds.fact_store_sales f
    JOIN dw_snow_tpcds.dim_item i
      ON f.item_key = i.item_key
    GROUP BY i.item_key
    ORDER BY SUM(f.net_paid) DESC
    LIMIT 10;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q2_TOP_PRODUCTS',
        'SNOWFLAKE',
        elapsed_ms
    );

    -- ========================================================
    -- Q3 SALES BY STATE (STAR)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM s.s_state,
           SUM(f.net_paid)
    FROM dw_star.fact_store_sales f
    JOIN dw_star.dim_store s
      ON f.store_key = s.store_key
    GROUP BY s.s_state;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q3_SALES_BY_STATE',
        'STAR',
        elapsed_ms
    );

    -- ========================================================
    -- Q3 SALES BY STATE (SNOWFLAKE)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM s.s_state,
           SUM(f.net_paid)
    FROM dw_snow_tpcds.fact_store_sales f
    JOIN dw_snow_tpcds.dim_store s
      ON f.store_key = s.store_key
    GROUP BY s.s_state;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q3_SALES_BY_STATE',
        'SNOWFLAKE',
        elapsed_ms
    );

    -- ========================================================
    -- Q4 CUSTOMER SALES (STAR)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM c.customer_key,
           SUM(f.net_paid)
    FROM dw_star.fact_store_sales f
    JOIN dw_star.dim_customer c
      ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
    ORDER BY SUM(f.net_paid) DESC
    LIMIT 100;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q4_CUSTOMER_SALES',
        'STAR',
        elapsed_ms
    );

    -- ========================================================
    -- Q4 CUSTOMER SALES (SNOWFLAKE)
    -- ========================================================

    start_time := clock_timestamp();

    PERFORM c.customer_key,
           SUM(f.net_paid)
    FROM dw_snow_tpcds.fact_store_sales f
    JOIN dw_snow_tpcds.dim_customer c
      ON f.customer_key = c.customer_key
    JOIN dw_snow_tpcds.dim_geo g
      ON c.geo_key = g.geo_key
    JOIN dw_snow_tpcds.dim_customer_demo cd
      ON c.demo_key = cd.demo_key
    GROUP BY c.customer_key
    ORDER BY SUM(f.net_paid) DESC
    LIMIT 100;

    end_time := clock_timestamp();

    elapsed_ms :=
        EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;

    INSERT INTO benchmark_results(
        query_name,
        schema_type,
        execution_time_ms
    )
    VALUES (
        'Q4_CUSTOMER_SALES',
        'SNOWFLAKE',
        elapsed_ms
    );

END LOOP;

END $$;

-- ============================================================
-- SHOW RESULTS
-- ============================================================

SELECT *
FROM benchmark_results
ORDER BY query_name,
         schema_type,
         run_id;