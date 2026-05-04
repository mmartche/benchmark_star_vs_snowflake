-- ============================================================
-- Load raw TPC-DS subset (VERSÃO FINAL SEM ERRO)
-- ============================================================

\set ON_ERROR_STOP on

CREATE SCHEMA IF NOT EXISTS tpcds_raw;
SET search_path TO tpcds_raw;

TRUNCATE TABLE date_dim, customer_address, customer_demographics, customer, item, store, store_sales;

\copy date_dim FROM '/Users/martche/data/tpcds_sf10/date_dim.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy customer_address FROM '/Users/martche/data/tpcds_sf10/customer_address.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy customer_demographics FROM '/Users/martche/data/tpcds_sf10/customer_demographics.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy customer FROM '/Users/martche/data/tpcds_sf10/customer.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy item FROM '/Users/martche/data/tpcds_sf10/item.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy store FROM '/Users/martche/data/tpcds_sf10/store.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy store_sales FROM '/Users/martche/data/tpcds_sf10/store_sales.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');

ANALYZE;