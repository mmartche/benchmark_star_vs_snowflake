import pandas as pd
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv("results.csv")

# Pivot table for plotting
pivot = df.pivot(index="query_name", columns="schema_type", values="execution_time_ms")

# Plot
pivot.plot(kind="bar", figsize=(10,6))

plt.title("Star vs Snowflake Query Performance")
plt.xlabel("Query")
plt.ylabel("Execution Time (ms)")
plt.xticks(rotation=45)
plt.tight_layout()

plt.savefig("benchmark_comparison.png")
plt.show()