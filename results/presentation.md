#Presentation Script – Star Schema vs Snowflake Schema
##Star Schema vs Snowflake Schema

Good morning/afternoon everyone.

Today I will present our study comparing Star Schema and Snowflake Schema in analytical environments.
The goal of this project was to evaluate how dimensional modeling affects query performance in Data Warehouses.

To perform this analysis, we used PostgreSQL together with the TPC-DS benchmark, which is an industry-standard benchmark for decision support systems.

We implemented both schemas, executed analytical queries, and analyzed the results using statistical validation methods such as confidence intervals and t-tests.

##Introduction

Data warehouses are designed to support analytical queries and business intelligence systems.

One of the most important design decisions is dimensional modeling because it directly affects query execution time, scalability, storage efficiency, and maintainability.

The two most common dimensional models are Star Schema and Snowflake Schema.

Star Schema uses denormalized dimensions, while Snowflake Schema normalizes dimensions into multiple related tables.

##What is TPC-DS?

TPC-DS is a benchmark created for evaluating analytical database systems.

It simulates a retail environment with customers, products, stores, sales, and promotions.

The benchmark includes large datasets and complex analytical queries that represent realistic business intelligence workloads.

We used TPC-DS because it is widely recognized in both academia and industry, making our evaluation more credible and reproducible.

##Star Schema

Star Schema is composed of a central fact table connected directly to denormalized dimension tables.

Its main advantage is performance because analytical queries require fewer joins.

This usually leads to simpler execution plans and lower computational overhead.

However, Star Schema may increase redundancy and storage usage because dimension data is duplicated.

##Snowflake Schema

Snowflake Schema extends the Star Schema by normalizing dimensions into multiple related tables.

This approach reduces redundancy and improves maintainability and data consistency.

However, because dimensions are normalized, analytical queries require additional joins, increasing query complexity and execution cost.

##Experimental Setup

For the experiments, we used PostgreSQL together with the TPC-DS dataset at scale factor 10.

We implemented both a Star Schema and a Snowflake Schema derived from the same TPC-DS data.

Analytical queries were executed multiple times to ensure reliable measurements.

We also applied statistical validation using confidence intervals and t-tests.

##Benchmark Queries

We selected four representative analytical queries.

The first query evaluates yearly sales aggregation.
The second identifies top-selling products.
The third analyzes sales by geographic region.
Finally, the fourth analyzes customer-level sales information.

These queries were chosen because they represent common OLAP operations involving aggregations and joins.

##Performance Results

The results showed that performance depends strongly on query characteristics.

In some simpler aggregation queries, Snowflake Schema achieved comparable or even better performance.

However, in more complex queries involving multiple joins, Star Schema significantly outperformed Snowflake Schema.

This happens because Star Schema reduces join depth and simplifies execution plans.

##Statistical Validation

To ensure scientific reliability, each query was executed multiple times.

We calculated 95 percent confidence intervals and generated error-bar graphs.

In addition, we applied statistical t-tests to verify whether performance differences were significant.

The results confirmed that most differences were statistically significant.

##Conclusion

In conclusion, dimensional modeling has a measurable impact on analytical query performance.

Star Schema performs better for complex workloads because it reduces join complexity.

On the other hand, Snowflake Schema offers advantages in normalization, maintainability, and storage efficiency.

Finally, TPC-DS proved to be an effective benchmark for evaluating Data Warehouse performance in realistic analytical scenarios.

Thank you for your attention.

