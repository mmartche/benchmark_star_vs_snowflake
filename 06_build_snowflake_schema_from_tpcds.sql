-- ============================================================
-- 06_build_snowflake_schema_from_tpcds.sql
-- FINAL CORRECTED VERSION
-- ============================================================

\set ON_ERROR_STOP on

DROP SCHEMA IF EXISTS dw_snow_tpcds CASCADE;
CREATE SCHEMA dw_snow_tpcds;

SET search_path TO dw_snow_tpcds;

-- ============================================================
-- DATE DIMENSION
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

-- ============================================================
-- GEO DIMENSION
-- ============================================================

CREATE TABLE dim_geo AS
SELECT DISTINCT
    ca_address_sk AS geo_key,
    ca_city AS city_name,
    ca_county AS county_name,
    ca_state AS state_code,
    ca_country AS country_name,
    ca_zip
FROM tpcds_raw.customer_address
WHERE ca_address_sk IS NOT NULL;

ALTER TABLE dim_geo
ADD PRIMARY KEY (geo_key);

-- ============================================================
-- CUSTOMER DEMOGRAPHICS
-- ============================================================

CREATE TABLE dim_customer_demo AS
SELECT DISTINCT
    cd_demo_sk AS demo_key,
    cd_gender,
    cd_marital_status,
    cd_education_status,
    cd_purchase_estimate,
    cd_credit_rating
FROM tpcds_raw.customer_demographics
WHERE cd_demo_sk IS NOT NULL;

ALTER TABLE dim_customer_demo
ADD PRIMARY KEY (demo_key);

-- ============================================================
-- CUSTOMER DIMENSION
-- ============================================================

CREATE TABLE dim_customer AS
SELECT DISTINCT
    c_customer_sk AS customer_key,
    c_customer_id,
    c_first_name,
    c_last_name,
    c_current_addr_sk AS geo_key,
    c_current_cdemo_sk AS demo_key,
    c_email_address,
    c_birth_country
FROM tpcds_raw.customer
WHERE c_customer_sk IS NOT NULL;

ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_key);

ALTER TABLE dim_customer
ADD CONSTRAINT fk_customer_geo
FOREIGN KEY (geo_key)
REFERENCES dim_geo(geo_key);

ALTER TABLE dim_customer
ADD CONSTRAINT fk_customer_demo
FOREIGN KEY (demo_key)
REFERENCES dim_customer_demo(demo_key);

-- ============================================================
-- CATEGORY DIMENSION
-- ============================================================

CREATE TABLE dim_category AS
SELECT
    i_category_id AS category_key,
    MIN(i_category) AS category_name
FROM tpcds_raw.item
WHERE i_category_id IS NOT NULL
GROUP BY i_category_id;

ALTER TABLE dim_category
ADD PRIMARY KEY (category_key);

-- ============================================================
-- CLASS DIMENSION
-- ============================================================

CREATE TABLE dim_class AS
SELECT
    i_class_id AS class_key,
    MIN(i_class) AS class_name,
    MIN(i_category_id) AS category_key
FROM tpcds_raw.item
WHERE i_class_id IS NOT NULL
GROUP BY i_class_id;

ALTER TABLE dim_class
ADD PRIMARY KEY (class_key);

ALTER TABLE dim_class
ADD CONSTRAINT fk_class_category
FOREIGN KEY (category_key)
REFERENCES dim_category(category_key);

-- ============================================================
-- BRAND DIMENSION
-- ============================================================

CREATE TABLE dim_brand AS
SELECT
    i_brand_id AS brand_key,
    MIN(i_brand) AS brand_name
FROM tpcds_raw.item
WHERE i_brand_id IS NOT NULL
GROUP BY i_brand_id;

ALTER TABLE dim_brand
ADD PRIMARY KEY (brand_key);

-- ============================================================
-- MANUFACTURER DIMENSION
-- ============================================================

CREATE TABLE dim_manufacturer AS
SELECT
    i_manufact_id AS manufacturer_key,
    MIN(i_manufact) AS manufacturer_name
FROM tpcds_raw.item
WHERE i_manufact_id IS NOT NULL
GROUP BY i_manufact_id;

ALTER TABLE dim_manufacturer
ADD PRIMARY KEY (manufacturer_key);

-- ============================================================
-- ITEM DIMENSION
-- ============================================================

CREATE TABLE dim_item AS
SELECT DISTINCT
    i_item_sk AS item_key,
    i_item_id,
    i_item_desc,
    i_current_price,
    i_brand_id AS brand_key,
    i_class_id AS class_key,
    i_manufact_id AS manufacturer_key
FROM tpcds_raw.item
WHERE i_item_sk IS NOT NULL;

ALTER TABLE dim_item
ADD PRIMARY KEY (item_key);

ALTER TABLE dim_item
ADD CONSTRAINT fk_item_brand
FOREIGN KEY (brand_key)
REFERENCES dim_brand(brand_key);

ALTER TABLE dim_item
ADD CONSTRAINT fk_item_class
FOREIGN KEY (class_key)
REFERENCES dim_class(class_key);

ALTER TABLE dim_item
ADD CONSTRAINT fk_item_manufacturer
FOREIGN KEY (manufacturer_key)
REFERENCES dim_manufacturer(manufacturer_key);

-- ============================================================
-- STORE DIMENSION
-- ============================================================

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
-- LOAD FACT TABLE
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
-- INDEXES
-- ============================================================

CREATE INDEX idx_snow_fact_date
ON fact_store_sales(sold_date_key);

CREATE INDEX idx_snow_fact_customer
ON fact_store_sales(customer_key);

CREATE INDEX idx_snow_fact_item
ON fact_store_sales(item_key);

CREATE INDEX idx_snow_fact_store
ON fact_store_sales(store_key);

CREATE INDEX idx_snow_cust_geo
ON dim_customer(geo_key);

CREATE INDEX idx_snow_item_class
ON dim_item(class_key);

CREATE INDEX idx_snow_class_cat
ON dim_class(category_key);

-- ============================================================
-- ANALYZE
-- ============================================================

ANALYZE dim_date;
ANALYZE dim_geo;
ANALYZE dim_customer_demo;
ANALYZE dim_customer;
ANALYZE dim_category;
ANALYZE dim_class;
ANALYZE dim_brand;
ANALYZE dim_manufacturer;
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
       pg_size_pretty(
           pg_total_relation_size('dw_snow_tpcds.fact_store_sales')
       );

-- ============================================================
-- EXPECTED RESULTS
-- ============================================================

-- FACT TABLE:
-- millions of rows
-- hundreds of MB or GB
-- NEVER KB