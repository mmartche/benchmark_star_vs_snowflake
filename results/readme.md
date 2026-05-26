# Slide 1 — Title

Today We’re going to present our work about dimensional modeling in Data Warehouses, specifically comparing Star Schema and Snowflake Schema using the TPC-DS benchmark executed on PostgreSQL.

The main motivation for this work is understanding how schema design affects analytical query performance in OLAP environments.

This is important because Data Warehouses process huge amounts of analytical data, and even small performance differences can significantly impact business intelligence systems.”

# Slide 2 — Agenda

“First, We will briefly explain the problem and introduce the TPC-DS benchmark.

Then, We will explain the differences between Star Schema and Snowflake Schema.

After that, We will present the experimental environment, the benchmark queries we used, the performance results, and finally the statistical analysis and conclusions.”

# Slide 3 — Introduction

“Data Warehouses are designed to support analytical processing rather than transactional operations.

Unlike transactional databases, analytical systems execute complex queries involving aggregation, filtering, joins, and historical analysis.

Because of this, schema design becomes extremely important.

The way tables are organized directly affects query execution plans, optimizer behavior, and overall analytical performance.

This work investigates how dimensional modeling impacts these factors.”

# Slide 4 — What is TPC-DS?

“TPC-DS is an industry-standard benchmark used for evaluating decision support systems and analytical databases.

It simulates a realistic retail business environment containing customers, products, stores, sales, and promotions.

One reason TPC-DS is important is because it includes very complex analytical queries that are similar to real-world business intelligence workloads.

Compared to simpler benchmarks, TPC-DS provides more realistic OLAP scenarios and allows us to evaluate optimizer behavior under complex workloads.”

# Slide 5 — Star Schema

“Star Schema is one of the most common dimensional models used in Data Warehouses.

In this model, we have a central fact table connected directly to denormalized dimension tables.

The main advantage is reduced join complexity.

Since dimensions are denormalized, analytical queries require fewer joins, which simplifies execution plans and usually improves performance.

However, this approach may increase redundancy and storage consumption.”

# Slide 6 — Snowflake Schema

“Snowflake Schema extends the Star Schema by normalizing dimensions into hierarchical tables.

This normalization reduces redundancy and improves maintainability and consistency.

For example, instead of storing repeated category information directly in the item dimension, categories may be separated into independent tables.

The disadvantage is that analytical queries become more complex because additional joins are required during execution.”

# Slide 7 — Experimental Environment

“All experiments were executed on an Apple Silicon MacBook with 16 GB of RAM running macOS.

PostgreSQL 16 was used as the database management system.

The dataset was generated using the official TPC-DS dsdgen tool.

Due to hardware and execution-time constraints, we used a representative subset of the SF10 workload instead of the complete dataset.”

# Slide 8 — Benchmark Queries

“We selected four representative OLAP queries.

The first query evaluates yearly sales aggregation.

The second identifies the top-selling products.

The third analyzes sales distribution by state.

Finally, the fourth query performs customer-level sales aggregation, which is significantly more complex because it requires deeper joins and more intermediate processing.”

# Slide 9 — Execution Time Results

“Here we can observe the execution time comparison between Star Schema and Snowflake Schema.

One important observation is that performance is not uniformly better for a single schema.

For simpler analytical workloads such as Q1 and Q3, Snowflake achieved competitive performance and in some cases even slightly better results.

However, as query complexity increased, Star Schema demonstrated clear advantages.

The most important example is Query 4.

This query involves customer-level aggregation and multiple joins, and here Star Schema performed significantly better.

This happens because Star Schema reduces join complexity, allowing PostgreSQL to generate simpler execution plans with lower computational overhead.”

# Slide 10 — Performance Ratio Analysis

“This graph presents the relative execution ratio calculated as Snowflake divided by Star execution time.

Values above one indicate that Snowflake Schema required more execution time.

The most significant result is Query 4, where Snowflake became much slower.

This demonstrates how normalization depth directly impacts analytical performance.

As the number of joins increases, the optimizer must evaluate a larger search space and process more intermediate operations.

This increases both planning and execution costs.”

# Slide 11 — Join Complexity Impact

“This graph illustrates the relationship between join depth and execution performance.

As the number of joins increases, Snowflake Schema tends to suffer larger performance degradation.

This happens because normalized dimensions require additional table accesses and more complex join trees.

In contrast, Star Schema mitigates this effect through denormalization, reducing the total number of joins required during execution.”

# Slide 12 — Trade-offs Between Schemas

“This slide summarizes the main trade-offs between the two dimensional models.

Star Schema prioritizes performance and simplicity.

Because dimensions are denormalized, analytical queries become easier to optimize and execute.

On the other hand, Snowflake Schema prioritizes normalization, maintainability, and reduced redundancy.

Therefore, the best schema depends on system objectives and workload requirements rather than performance alone.”

# Slide 13 — Statistical Validation

“To improve reliability, each benchmark query was executed multiple times under identical conditions.

Average execution time, standard deviation, and 95 percent confidence intervals were computed.

Additionally, Student’s t-test was applied to verify whether the observed differences were statistically significant.

The relatively small confidence intervals indicate low variability between executions, increasing confidence in the results.”

# Slide 14 — Threats to Validity

“Some limitations should be considered when interpreting these results.

First, experiments were executed on a single hardware configuration.

Second, only a representative subset of TPC-DS queries was evaluated rather than the complete benchmark suite.

Finally, PostgreSQL-specific optimizer behavior and cache effects may influence performance measurements.”

# Slide 15 — Conclusion

“In conclusion, dimensional modeling significantly impacts analytical query performance.

Star Schema demonstrated significant advantages in complex analytical workloads due to reduced join complexity and simplified execution plans.

Snowflake Schema, however, provides benefits in terms of normalization, maintainability, and reduced redundancy.

Overall, the results show that schema selection should consider workload characteristics and long-term system requirements rather than assuming one model is universally superior.”
