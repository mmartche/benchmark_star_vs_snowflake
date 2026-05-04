-- ============================================================
-- SNOWFLAKE SCHEMA FINAL (VERSÃO LIMPA E FUNCIONAL)
-- ============================================================

\set ON_ERROR_STOP on

DROP SCHEMA IF EXISTS dw_snowflake CASCADE;
CREATE SCHEMA dw_snowflake;
SET search_path TO dw_snowflake;

-- ============================================================
-- DIM DATE
-- ============================================================

CREATE TABLE dim_date AS
SELECT DISTINCT
    d_date_sk AS date_key,
    d_date,
    d_year,
    d_moy,
    d_dom,
    d_day_name,
    d_quarter_name
FROM tpcds_raw.date_dim
WHERE d_date_sk IS NOT NULL;

ALTER TABLE dim_date ADD PRIMARY KEY (date_key);

-- ============================================================
-- CUSTOMER SNOWFLAKE
-- ============================================================

-- 👤 CUSTOMER
CREATE TABLE dim_customer AS
SELECT DISTINCT
    c_customer_sk AS customer_key,
    c_first_name,
    c_last_name,
    c_birth_year,
    c_current_addr_sk
FROM tpcds_raw.customer
WHERE c_customer_sk IS NOT NULL;

ALTER TABLE dim_customer ADD PRIMARY KEY (customer_key);

-- 📍 ADDRESS
CREATE TABLE dim_customer_address AS
SELECT DISTINCT
    ca_address_sk AS address_key,
    ca_city,
    ca_state,
    ca_country
FROM tpcds_raw.customer_address
WHERE ca_address_sk IS NOT NULL;

ALTER TABLE dim_customer_address ADD PRIMARY KEY (address_key);

-- 🔗 RELAÇÃO CUSTOMER → ADDRESS
ALTER TABLE dim_customer ADD COLUMN address_key INT;

UPDATE dim_customer c
SET address_key = ca.address_key
FROM dim_customer_address ca
WHERE c.c_current_addr_sk = ca.address_key;

CREATE INDEX idx_customer_address ON dim_customer(address_key);

-- ============================================================
-- ITEM SNOWFLAKE (CORRIGIDO)
-- ============================================================

-- 📦 ITEM BASE
CREATE TABLE dim_item AS
SELECT DISTINCT
    i_item_sk AS item_key,
    i_item_id,
    i_item_desc,
    i_current_price,
    i_category
FROM tpcds_raw.item
WHERE i_item_sk IS NOT NULL;

ALTER TABLE dim_item ADD PRIMARY KEY (item_key);

-- 🏷️ CATEGORY (surrogate key)
CREATE TABLE dim_category AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS category_key,
    i_category
FROM tpcds_raw.item
WHERE i_category IS NOT NULL;

ALTER TABLE dim_category ADD PRIMARY KEY (category_key);

-- 🔗 RELAÇÃO ITEM → CATEGORY
ALTER TABLE dim_item ADD COLUMN category_key INT;

UPDATE dim_item i
SET category_key = c.category_key
FROM dim_category c
WHERE i.i_category = c.i_category;

CREATE INDEX idx_item_category ON dim_item(category_key);

-- ============================================================
-- STORE SNOWFLAKE
-- ============================================================

-- 🏬 STORE BASE
CREATE TABLE dim_store AS
SELECT DISTINCT
    s_store_sk AS store_key,
    s_store_id,
    s_store_name,
    s_city,
    s_state
FROM tpcds_raw.store
WHERE s_store_sk IS NOT NULL;

ALTER TABLE dim_store ADD PRIMARY KEY (store_key);

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
    sales_price NUMERIC(10,2),
    net_profit NUMERIC(10,2)
);

-- ============================================================
-- INSERT (SEGURO)
-- ============================================================

INSERT INTO fact_store_sales (
    sold_date_key,
    customer_key,
    item_key,
    store_key,
    quantity,
    sales_price,
    net_profit
)
SELECT
    d.d_date_sk,
    c.c_customer_sk,
    i.i_item_sk,
    s.s_store_sk,
    ss.ss_quantity,
    ss.ss_sales_price,
    ss.ss_net_profit
FROM tpcds_raw.store_sales ss

JOIN tpcds_raw.date_dim d 
    ON ss.ss_sold_date_sk = d.d_date_sk

JOIN tpcds_raw.customer c 
    ON ss.ss_customer_sk = c.c_customer_sk

JOIN tpcds_raw.item i 
    ON ss.ss_item_sk = i.i_item_sk

JOIN tpcds_raw.store s 
    ON ss.ss_store_sk = s.s_store_sk

WHERE 
    ss.ss_sold_date_sk IS NOT NULL
    AND ss.ss_customer_sk IS NOT NULL
    AND ss.ss_item_sk IS NOT NULL
    AND ss.ss_store_sk IS NOT NULL;

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_fact_date ON fact_store_sales(sold_date_key);
CREATE INDEX idx_fact_customer ON fact_store_sales(customer_key);
CREATE INDEX idx_fact_item ON fact_store_sales(item_key);
CREATE INDEX idx_fact_store ON fact_store_sales(store_key);

-- ============================================================
-- ANALYZE
-- ============================================================

ANALYZE;