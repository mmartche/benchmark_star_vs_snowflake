-- ============================================================
-- Load raw TPC-DS subset
-- ============================================================

\set ON_ERROR_STOP on

CREATE SCHEMA IF NOT EXISTS tpcds_raw;
SET search_path TO tpcds_raw;

TRUNCATE TABLE date_dim, customer_address, customer_demographics, customer, item, store, store_sales;

\copy date_dim FROM './data/tpcds_sf1/date_dim.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy customer_address FROM './data/tpcds_sf1/customer_address.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy customer_demographics FROM './data/tpcds_sf1/customer_demographics.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy customer FROM './data/tpcds_sf1/customer.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy item FROM './data/tpcds_sf1/item.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy store FROM './data/tpcds_sf1/store.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');
\copy store_sales FROM './data/tpcds_sf1/store_sales.dat' WITH (FORMAT csv, DELIMITER '|', NULL '');

ANALYZE;