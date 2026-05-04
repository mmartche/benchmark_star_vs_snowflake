-- ============================================================
-- Raw TPC-DS staging subset for PostgreSQL
-- ============================================================

CREATE SCHEMA IF NOT EXISTS tpcds_raw;
SET search_path TO tpcds_raw;

DROP TABLE IF EXISTS store_sales CASCADE;
DROP TABLE IF EXISTS store CASCADE;
DROP TABLE IF EXISTS item CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS customer_address CASCADE;
DROP TABLE IF EXISTS customer_demographics CASCADE;
DROP TABLE IF EXISTS date_dim CASCADE;

CREATE TABLE date_dim (
    d_date_sk                 INTEGER PRIMARY KEY,
    d_date_id                 CHAR(16),
    d_date                    DATE,
    d_month_seq               INTEGER,
    d_week_seq                INTEGER,
    d_quarter_seq             INTEGER,
    d_year                    INTEGER,
    d_dow                     INTEGER,
    d_moy                     INTEGER,
    d_dom                     INTEGER,
    d_qoy                     INTEGER,
    d_fy_year                 INTEGER,
    d_fy_quarter_seq          INTEGER,
    d_fy_week_seq             INTEGER,
    d_day_name                VARCHAR(9),
    d_quarter_name            VARCHAR(6),
    d_holiday                 CHAR(1),
    d_weekend                 CHAR(1),
    d_following_holiday       CHAR(1),
    d_first_dom               INTEGER,
    d_last_dom                INTEGER,
    d_same_day_ly             INTEGER,
    d_same_day_lq             INTEGER,
    d_current_day             CHAR(1),
    d_current_week            CHAR(1),
    d_current_month           CHAR(1),
    d_current_quarter         CHAR(1),
    d_current_year            CHAR(1)
);

CREATE TABLE customer_address (
    ca_address_sk             INTEGER PRIMARY KEY,
    ca_address_id             CHAR(16),
    ca_street_number          VARCHAR(10),
    ca_street_name            VARCHAR(60),
    ca_street_type            VARCHAR(15),
    ca_suite_number           VARCHAR(10),
    ca_city                   VARCHAR(60),
    ca_county                 VARCHAR(30),
    ca_state                  CHAR(2),
    ca_zip                    VARCHAR(10),
    ca_country                VARCHAR(20),
    ca_gmt_offset             NUMERIC(5,2),
    ca_location_type          VARCHAR(20)
);

CREATE TABLE customer_demographics (
    cd_demo_sk                INTEGER PRIMARY KEY,
    cd_gender                 CHAR(1),
    cd_marital_status         CHAR(1),
    cd_education_status       VARCHAR(20),
    cd_purchase_estimate      INTEGER,
    cd_credit_rating          VARCHAR(10),
    cd_dep_count              INTEGER,
    cd_dep_employed_count     INTEGER,
    cd_dep_college_count      INTEGER
);

CREATE TABLE customer (
    c_customer_sk             INTEGER PRIMARY KEY,
    c_customer_id             CHAR(16),
    c_current_cdemo_sk        INTEGER,
    c_current_hdemo_sk        INTEGER,
    c_current_addr_sk         INTEGER,
    c_first_shipto_date_sk    INTEGER,
    c_first_sales_date_sk     INTEGER,
    c_salutation              VARCHAR(10),
    c_first_name              VARCHAR(20),
    c_last_name               VARCHAR(30),
    c_preferred_cust_flag     CHAR(1),
    c_birth_day               INTEGER,
    c_birth_month             INTEGER,
    c_birth_year              INTEGER,
    c_birth_country           VARCHAR(20),
    c_login                   VARCHAR(13),
    c_email_address           VARCHAR(50),
    c_last_review_date        CHAR(16)
);

CREATE TABLE item (
    i_item_sk                 INTEGER PRIMARY KEY,
    i_item_id                 CHAR(16),
    i_rec_start_date          DATE,
    i_rec_end_date            DATE,
    i_item_desc               VARCHAR(200),
    i_current_price           NUMERIC(7,2),
    i_wholesale_cost          NUMERIC(7,2),
    i_brand_id                INTEGER,
    i_brand                   VARCHAR(50),
    i_class_id                INTEGER,
    i_class                   VARCHAR(50),
    i_category_id             INTEGER,
    i_category                VARCHAR(50),
    i_manufact_id             INTEGER,
    i_manufact                VARCHAR(50),
    i_size                    VARCHAR(20),
    i_formulation             VARCHAR(20),
    i_color                   VARCHAR(20),
    i_units                   VARCHAR(10),
    i_container               VARCHAR(10),
    i_manager_id              INTEGER,
    i_product_name            VARCHAR(50)
);

CREATE TABLE store (
    s_store_sk                INTEGER PRIMARY KEY,
    s_store_id                CHAR(16),
    s_rec_start_date          DATE,
    s_rec_end_date            DATE,
    s_closed_date_sk          INTEGER,
    s_store_name              VARCHAR(50),
    s_number_employees        INTEGER,
    s_floor_space             INTEGER,
    s_hours                   VARCHAR(20),
    s_manager                 VARCHAR(40),
    s_market_id               INTEGER,
    s_geography_class         VARCHAR(100),
    s_market_desc             VARCHAR(100),
    s_market_manager          VARCHAR(40),
    s_division_id             INTEGER,
    s_division_name           VARCHAR(50),
    s_company_id              INTEGER,
    s_company_name            VARCHAR(50),
    s_street_number           VARCHAR(10),
    s_street_name             VARCHAR(60),
    s_street_type             VARCHAR(15),
    s_suite_number            VARCHAR(10),
    s_city                    VARCHAR(60),
    s_county                  VARCHAR(30),
    s_state                   CHAR(2),
    s_zip                     VARCHAR(10),
    s_country                 VARCHAR(20),
    s_gmt_offset              NUMERIC(5,2),
    s_tax_precentage          NUMERIC(5,2)
);

CREATE TABLE store_sales (
    ss_sold_date_sk           INTEGER,
    ss_sold_time_sk           INTEGER,
    ss_item_sk                INTEGER,
    ss_customer_sk            INTEGER,
    ss_cdemo_sk               INTEGER,
    ss_hdemo_sk               INTEGER,
    ss_addr_sk                INTEGER,
    ss_store_sk               INTEGER,
    ss_promo_sk               INTEGER,
    ss_ticket_number          BIGINT,
    ss_quantity               INTEGER,
    ss_wholesale_cost         NUMERIC(7,2),
    ss_list_price             NUMERIC(7,2),
    ss_sales_price            NUMERIC(7,2),
    ss_ext_discount_amt       NUMERIC(7,2),
    ss_ext_sales_price        NUMERIC(7,2),
    ss_ext_wholesale_cost     NUMERIC(7,2),
    ss_ext_list_price         NUMERIC(7,2),
    ss_ext_tax                NUMERIC(7,2),
    ss_coupon_amt             NUMERIC(7,2),
    ss_net_paid               NUMERIC(7,2),
    ss_net_paid_inc_tax       NUMERIC(7,2),
    ss_net_profit             NUMERIC(7,2)
);
