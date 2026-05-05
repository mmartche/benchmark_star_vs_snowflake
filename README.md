# TPC-DS Implementation for `Star Schema vs Snowflake Schema`

This package gives you a practical, reproducible PostgreSQL implementation of a **TPC-DS-based benchmark** for comparing **Star Schema** and **Snowflake Schema** on analytical workloads.

## What is included

- `01_build_tpcds_tools.sh` — helper script to compile `dsdgen` from the official TPC-DS kit
- `02_generate_tpcds_data.sh` — generates TPC-DS flat files (CSV-like `.dat`) for a chosen scale factor
- `03_create_raw_tpcds_tables.sql` — creates a **subset** of raw TPC-DS tables required for this study
- `04_load_raw_tpcds_data.sql` — `COPY` commands to load generated data into PostgreSQL staging tables
- `05_build_star_schema_from_tpcds.sql` — creates and loads the denormalized star schema
- `06_build_snowflake_schema_from_tpcds.sql` — creates and loads the normalized snowflake schema
- `07_benchmark_queries_tpcds.sql` — paired analytical queries for both schemas
- `08_collect_metrics.sql` — helper SQL to inspect storage footprint and row counts
- `09_run_benchmark.sh` — optional shell script to automate repeated `EXPLAIN (ANALYZE, BUFFERS)` runs
- `10_95_ci.py` — optional, if the benchmark was executed, to compute a 95% confidence interval
- `11_run_graph_compare.py` - generate all graphs to compare infos and on documentation

## Recommended scale factors

For a master's assignment, use:

- `SF=1` for debugging / pilot runs
- `SF=10` for the main experiment if hardware permits

TPC-DS can generate many tables, but this package uses a **focused subset** that is enough to support a strong paper while keeping implementation manageable.

## Raw TPC-DS tables used

- `date_dim`
- `customer`
- `customer_address`
- `customer_demographics`
- `item`
- `store`
- `store_sales`

## Suggested execution order

1. Build `dsdgen`
2. Generate data files
3. Create raw tables
4. Load raw data
5. Build the star schema
6. Build the snowflake schema
7. Run the benchmark queries with cold/warm repetitions
8. Collect latency, storage, and scaling results

## Fix TPC-DS tools

- (./tpcds-kit/tools)
On macOS, if you encounter build issues with the main package, you may need to modify the source files located in this directory.

## Workflow
```bash
git clone https://github.com/databricks/tpcds-kit.git
cd tpcds-kit/tools
make
bash 01_build_tpcds_tools.sh ../tpcds-kit/tools
bash 02_generate_tpcds_data.sh 1 ../tpcds-kit/tools ./data/tpcds_sf1
bash 02_generate_tpcds_data.sh 10 ../tpcds-kit/tools ./data/tpcds_sf10
./dsdgen -scale 10 -dir ./tpcds_data
psql -U postgres -c "CREATE DATABASE dwbench;"
psql -U postgres -d dwbench -f 03_create_raw_tpcds_tables.sql
sed -i '' 's/|$//' ./data/tpcds_sf10/*.dat
psql -U postgres -d dwbench -f 04_load_raw_tpcds_data.sql
psql -U postgres -d dwbench -f 05_build_star_schema_from_tpcds.sql
psql -U postgres -d dwbench -f 06_build_snowflake_schema_from_tpcds.sql
psql -U postgres -d dwbench -f 07_benchmark_queries_tpcds.sql
psql -U postgres -d dwbench -f 08_collect_metrics.sql
bash 09_run_benchmark.sh dwbench postgres localhost 5432
python 10_95_ci.py
python 11_run_graph_compare.py
```

## Experimental note

To keep the comparison fair, run the **same semantic queries** against both schemas, on the **same hardware**, with the **same PostgreSQL configuration**, and after executing `ANALYZE`.