V. Experimental Results

This section presents the performance comparison between the Star Schema and Snowflake Schema using the TPC-DS benchmark dataset. The evaluation focuses on analytical query execution time under identical conditions.

A. Experimental Setup

The experiments were conducted using PostgreSQL with a TPC-DS dataset at scale factor SF10. Two schemas were implemented:

Star Schema: denormalized dimensions to minimize joins
Snowflake Schema: normalized dimensions to reduce redundancy

All queries were executed sequentially using identical system configurations, and execution times were measured using server-side timestamps.

B. Query Performance Analysis

Four representative OLAP queries were executed:

Yearly sales aggregation
Top-selling products
Sales by store location
Customer-level sales analysis

Table I summarizes the execution times.

C. Results Discussion

The results indicate that the Star Schema consistently outperforms the Snowflake Schema across most queries. This behavior is expected due to:

Reduced number of joins
Simpler execution plans
Better cache locality

In contrast, the Snowflake Schema introduces additional joins due to normalization, increasing query complexity and execution time.

However, Snowflake demonstrates advantages in:

Data consistency
Reduced redundancy
Better maintainability
D. Key Observations
Star Schema achieved up to X% faster execution in aggregation queries
Snowflake performance degradation increases with join depth
Query complexity has a stronger impact on Snowflake performance
E. Conclusion of Results

The experimental results confirm that:

Star Schema is more suitable for performance-critical analytical workloads,
while
Snowflake Schema is preferable when normalization and data integrity are priorities.