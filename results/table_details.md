 schema_name |      object_name      | total_size 
-------------+-----------------------+------------
 dw_star     | fact_store_sales      | 5008 MB
 dw_star     | fact_store_sales_pkey | 617 MB
 dw_star     | idx_fact_item         | 198 MB
 dw_star     | idx_fact_customer     | 194 MB
 dw_star     | idx_fact_date         | 191 MB
 dw_star     | idx_fact_store        | 190 MB
 dw_star     | dim_customer          | 61 MB
 dw_star     | dim_item              | 22 MB
 dw_star     | dim_customer_pkey     | 11 MB
 dw_star     | dim_date              | 5952 kB
 dw_star     | dim_item_pkey         | 2248 kB
 dw_star     | dim_date_pkey         | 1616 kB
 dw_star     | dim_store             | 32 kB
 dw_star     | dim_store_pkey        | 16 kB
(14 rows)

  schema_name  |      object_name       | total_size 
---------------+------------------------+------------
 dw_snow_tpcds | fact_store_sales       | 5009 MB
 dw_snow_tpcds | fact_store_sales_pkey  | 617 MB
 dw_snow_tpcds | idx_snow_fact_item     | 198 MB
 dw_snow_tpcds | idx_snow_fact_customer | 194 MB
 dw_snow_tpcds | idx_snow_fact_date     | 191 MB
 dw_snow_tpcds | idx_snow_fact_store    | 190 MB
 dw_snow_tpcds | dim_customer_demo      | 157 MB
 dw_snow_tpcds | dim_customer           | 73 MB
 dw_snow_tpcds | dim_customer_demo_pkey | 41 MB
 dw_snow_tpcds | dim_geo                | 25 MB
 dw_snow_tpcds | dim_item               | 20 MB
 dw_snow_tpcds | dim_customer_pkey      | 11 MB
 dw_snow_tpcds | idx_snow_cust_geo      | 8240 kB
 dw_snow_tpcds | dim_date               | 5952 kB
 dw_snow_tpcds | dim_geo_pkey           | 5512 kB
 dw_snow_tpcds | dim_item_pkey          | 2248 kB
 dw_snow_tpcds | dim_date_pkey          | 1616 kB
 dw_snow_tpcds | idx_snow_item_class    | 712 kB
 dw_snow_tpcds | dim_brand              | 112 kB
 dw_snow_tpcds | dim_manufacturer       | 112 kB
 dw_snow_tpcds | dim_class              | 48 kB
 dw_snow_tpcds | dim_brand_pkey         | 40 kB
 dw_snow_tpcds | dim_manufacturer_pkey  | 40 kB
 dw_snow_tpcds | dim_category           | 32 kB
 dw_snow_tpcds | dim_store              | 32 kB
 dw_snow_tpcds | dim_category_pkey      | 16 kB
 dw_snow_tpcds | idx_snow_class_cat     | 16 kB
 dw_snow_tpcds | dim_store_pkey         | 16 kB
 dw_snow_tpcds | dim_class_pkey         | 16 kB
(29 rows)

  object_name  |  count   
---------------+----------
 snow_dim_item |   102000
 star_dim_item |   102000
 star_fact     | 28800991
 snow_fact     | 28800991
(4 rows)

 schema_type | fact_size 
-------------+-----------
 STAR        | 5008 MB
 SNOWFLAKE   | 5009 MB
(2 rows)
