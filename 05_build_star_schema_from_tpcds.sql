-- ============================================================
-- Build STAR SCHEMA from TPC-DS raw tables
-- FINAL corrected version
-- ============================================================

\set ON_ERROR_STOP on

DROP SCHEMA IF EXISTS dw_star CASCADE;
CREATE SCHEMA dw_star;
SET search_path TO dw_star;

-- ============================================================
-- DIMENSION TABLES
-- ============================================================

CREATE TABLE dim_date AS
SELECT DISTINCT
    d_date_sk AS date_key,
    d_date,
    d_month_seq,
    d_week_seq,
    d_quarter_seq,
    d_year,
    d_dow,
    d_moy
FROM tpcds_raw.date_dim
WHERE d_date_sk IS NOT NULL;

ALTER TABLE dim_date
ADD PRIMARY KEY (date_key);


CREATE TABLE dim_customer AS
SELECT DISTINCT
    c_customer_sk AS customer_key,
    c_customer_id,
    c_first_name,
    c_last_name,
    c_preferred_cust_flag,
    c_birth_country,
    c_email_address
FROM tpcds_raw.customer
WHERE c_customer_sk IS NOT NULL;

ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_key);


CREATE TABLE dim_item AS
SELECT DISTINCT
    i_item_sk AS item_key,
    i_item_id,
    i_item_desc,
    i_current_price,
    i_brand,
    i_class,
    i_category
FROM tpcds_raw.item
WHERE i_item_sk IS NOT NULL;

ALTER TABLE dim_item
ADD PRIMARY KEY (item_key);


CREATE TABLE dim_store AS
SELECT DISTINCT
    s_store_sk AS store_key,
    s_store_id,
    s_store_name,
    s_city,
    s_state,
    s_country
FROM tpcds_raw.store
WHERE s_store_sk IS NOT NULL;

ALTER TABLE dim_store
ADD PRIMARY KEY (store_key);


-- ============================================================
-- FACT TABLE
-- IMPORTANT:
-- NO DISTINCT
-- NO GROUP BY
-- NO composite primary key
-- ============================================================

CREATE TABLE fact_store_sales (
    fact_id BIGSERIAL PRIMARY KEY,

    sold_date_key INT,
    customer_key INT,
    item_key INT,
    store_key INT,

    quantity INT,
    wholesale_cost NUMERIC(12,2),
    list_price NUMERIC(12,2),
    sales_price NUMERIC(12,2),
    discount_amt NUMERIC(12,2),
    ext_sales_price NUMERIC(12,2),
    ext_wholesale_cost NUMERIC(12,2),
    ext_list_price NUMERIC(12,2),
    ext_tax NUMERIC(12,2),
    coupon_amt NUMERIC(12,2),
    net_paid NUMERIC(12,2),
    net_paid_inc_tax NUMERIC(12,2),
    net_profit NUMERIC(12,2)
);


-- ============================================================
-- INSERT FACT DATA
-- IMPORTANT:
-- LEFT JOIN avoids losing rows
-- NO filters removing data
-- ============================================================

INSERT INTO fact_store_sales (
    sold_date_key,
    customer_key,
    item_key,
    store_key,
    quantity,
    wholesale_cost,
    list_price,
    sales_price,
    discount_amt,
    ext_sales_price,
    ext_wholesale_cost,
    ext_list_price,
    ext_tax,
    coupon_amt,
    net_paid,
    net_paid_inc_tax,
    net_profit
)
SELECT
    ss.ss_sold_date_sk,
    ss.ss_customer_sk,
    ss.ss_item_sk,
    ss.ss_store_sk,

    ss.ss_quantity,
    ss.ss_wholesale_cost,
    ss.ss_list_price,
    ss.ss_sales_price,
    ss.ss_ext_discount_amt,
    ss.ss_ext_sales_price,
    ss.ss_ext_wholesale_cost,
    ss.ss_ext_list_price,
    ss.ss_ext_tax,
    ss.ss_coupon_amt,
    ss.ss_net_paid,
    ss.ss_net_paid_inc_tax,
    ss.ss_net_profit

FROM tpcds_raw.store_sales ss;


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_fact_date
ON fact_store_sales(sold_date_key);

CREATE INDEX idx_fact_customer
ON fact_store_sales(customer_key);

CREATE INDEX idx_fact_item
ON fact_store_sales(item_key);

CREATE INDEX idx_fact_store
ON fact_store_sales(store_key);


-- ============================================================
-- FOREIGN KEYS
-- ============================================================

ALTER TABLE fact_store_sales
ADD CONSTRAINT fk_fact_date
FOREIGN KEY (sold_date_key)
REFERENCES dim_date(date_key);

ALTER TABLE fact_store_sales
ADD CONSTRAINT fk_fact_customer
FOREIGN KEY (customer_key)
REFERENCES dim_customer(customer_key);

ALTER TABLE fact_store_sales
ADD CONSTRAINT fk_fact_item
FOREIGN KEY (item_key)
REFERENCES dim_item(item_key);

ALTER TABLE fact_store_sales
ADD CONSTRAINT fk_fact_store
FOREIGN KEY (store_key)
REFERENCES dim_store(store_key);


-- ============================================================
-- ANALYZE
-- ============================================================

ANALYZE dim_date;
ANALYZE dim_customer;
ANALYZE dim_item;
ANALYZE dim_store;
ANALYZE fact_store_sales;


-- ============================================================
-- VALIDATION
-- ============================================================

SELECT 'RAW store_sales rows' AS metric,
       COUNT(*)
FROM tpcds_raw.store_sales;

SELECT 'FACT rows' AS metric,
       COUNT(*)
FROM fact_store_sales;

SELECT 'FACT size' AS metric,
       pg_size_pretty(pg_total_relation_size('dw_star.fact_store_sales'));


-- ============================================================
-- EXPECTED RESULTS
-- ============================================================
-- SF10 should contain millions of rows
-- FACT table should be hundreds of MB or several GB
-- NOT KB
-- ============================================================
