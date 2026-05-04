  schema_name  |      object_name       | total_size 
---------------+------------------------+------------
 dw_star_tpcds | dim_customer           | 89 MB
 dw_star_tpcds | dim_item               | 31 MB
 dw_star_tpcds | dim_customer_pkey      | 15 MB
 dw_star_tpcds | dim_date               | 6608 kB
 dw_star_tpcds | dim_item_pkey          | 3576 kB
 dw_star_tpcds | idx_star_dim_cust_st   | 3432 kB
 dw_star_tpcds | dim_date_pkey          | 1616 kB
 dw_star_tpcds | idx_star_dim_item_cat  | 712 kB
 dw_star_tpcds | dim_store              | 80 kB
 dw_star_tpcds | fact_store_sales       | 56 kB
 dw_star_tpcds | fact_store_sales_pkey  | 16 kB
 dw_star_tpcds | idx_star_dim_store_st  | 16 kB
 dw_star_tpcds | dim_store_pkey         | 16 kB
 dw_star_tpcds | idx_star_fact_store    | 8192 bytes
 dw_star_tpcds | idx_star_fact_customer | 8192 bytes
 dw_star_tpcds | idx_star_fact_date     | 8192 bytes
 dw_star_tpcds | idx_star_fact_item     | 8192 bytes
(17 rows)

  schema_name  |                        object_name                        | total_size 
---------------+-----------------------------------------------------------+------------
 dw_snow_tpcds | dim_customer_demo                                         | 176 MB
 dw_snow_tpcds | dim_customer                                              | 65 MB
 dw_snow_tpcds | dim_customer_demo_pkey                                    | 60 MB
 dw_snow_tpcds | dim_geo                                                   | 34 MB
 dw_snow_tpcds | dim_geo_city_name_county_name_state_code_country_name_key | 15 MB
 dw_snow_tpcds | dim_customer_pkey                                         | 13 MB
 dw_snow_tpcds | idx_snow_cust_geo                                         | 7088 kB
 dw_snow_tpcds | dim_date                                                  | 6608 kB
 dw_snow_tpcds | dim_geo_pkey                                              | 4160 kB
 dw_snow_tpcds | dim_item                                                  | 3600 kB
 dw_snow_tpcds | dim_item_pkey                                             | 3576 kB
 dw_snow_tpcds | dim_date_pkey                                             | 1616 kB
 dw_snow_tpcds | dim_store                                                 | 72 kB
 dw_snow_tpcds | fact_store_sales                                          | 56 kB
 dw_snow_tpcds | dim_class                                                 | 32 kB
 dw_snow_tpcds | dim_brand                                                 | 32 kB
 dw_snow_tpcds | dim_category                                              | 24 kB
 dw_snow_tpcds | dim_manufacturer                                          | 24 kB
 dw_snow_tpcds | dim_brand_pkey                                            | 16 kB
 dw_snow_tpcds | dim_manufacturer_pkey                                     | 16 kB
 dw_snow_tpcds | dim_store_pkey                                            | 16 kB
 dw_snow_tpcds | fact_store_sales_pkey                                     | 16 kB
 dw_snow_tpcds | dim_class_pkey                                            | 16 kB
 dw_snow_tpcds | dim_category_pkey                                         | 16 kB
 dw_snow_tpcds | idx_snow_store_geo                                        | 16 kB
 dw_snow_tpcds | idx_snow_fact_customer                                    | 8192 bytes
 dw_snow_tpcds | idx_snow_fact_store                                       | 8192 bytes
 dw_snow_tpcds | idx_snow_item_class                                       | 8192 bytes
 dw_snow_tpcds | idx_snow_class_cat                                        | 8192 bytes
 dw_snow_tpcds | idx_snow_fact_date                                        | 8192 bytes
 dw_snow_tpcds | idx_snow_fact_item                                        | 8192 bytes
(31 rows)

  object_name  | count  
---------------+--------
 star_fact     |      0
 snow_fact     |      0
 star_dim_item | 102000
 snow_dim_item |      0
(4 rows)
