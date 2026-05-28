# ============================================================
# analyze_results.py
# FINAL VERSION
# ============================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# ============================================================
# LOAD DATA
# ============================================================

df = pd.read_csv("./results/results.csv")

# ============================================================
# REMOVE FIRST EXECUTION (WARM-UP)
# ============================================================

df = (
    df.groupby(["query_name", "schema_type"], group_keys=False)
      .apply(lambda x: x.iloc[1:])
      .reset_index(drop=True)
)

# ============================================================
# BASIC STATISTICS
# ============================================================

grouped = df.groupby(
    ["query_name", "schema_type"]
)["execution_time_ms"]

stats_df = grouped.agg(
    ['mean', 'std', 'count']
).reset_index()

# ============================================================
# CALCULATE 95% CONFIDENCE INTERVAL
# ============================================================

confidence = 0.95
ci_list = []

for _, row in stats_df.iterrows():

    mean = row['mean']
    std = row['std']
    n = int(row['count'])

    if n > 1:
        t_val = stats.t.ppf(
            (1 + confidence) / 2.,
            n - 1
        )

        margin = t_val * (std / np.sqrt(n))

    else:
        margin = 0

    ci_list.append(margin)

stats_df['ci95'] = ci_list

# ============================================================
# T-TEST
# ============================================================

pvalues = []

queries = df["query_name"].unique()

for q in queries:

    star = df[
        (df["query_name"] == q) &
        (df["schema_type"] == "STAR")
    ]["execution_time_ms"]

    snow = df[
        (df["query_name"] == q) &
        (df["schema_type"] == "SNOWFLAKE")
    ]["execution_time_ms"]

    tstat, pvalue = stats.ttest_ind(
        star,
        snow,
        equal_var=False
    )

    pvalues.append({
        "query_name": q,
        "t_statistic": tstat,
        "p_value": pvalue
    })

pvalues_df = pd.DataFrame(pvalues)

# ============================================================
# MERGE
# ============================================================

stats_df = stats_df.merge(
    pvalues_df,
    on="query_name",
    how="left"
)

# ============================================================
# ROUND VALUES
# ============================================================

stats_df["mean"] = stats_df["mean"].round(2)
stats_df["std"] = stats_df["std"].round(2)
stats_df["ci95"] = stats_df["ci95"].round(2)
stats_df["t_statistic"] = stats_df["t_statistic"].round(4)
stats_df["p_value"] = stats_df["p_value"].round(6)

# ============================================================
# EXPORT CSV
# ============================================================

stats_df.to_csv(
    "./results/results_statistics.csv",
    index=False
)

# ============================================================
# PIVOT FOR PLOT
# ============================================================

pivot_mean = stats_df.pivot(
    index="query_name",
    columns="schema_type",
    values="mean"
)

pivot_ci = stats_df.pivot(
    index="query_name",
    columns="schema_type",
    values="ci95"
)

# ============================================================
# BAR CHART WITH 95% CI
# ============================================================

x = np.arange(len(pivot_mean.index))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))

ax.bar(
    x - width/2,
    pivot_mean["STAR"],
    width,
    yerr=pivot_ci["STAR"],
    capsize=6,
    label="Star Schema"
)

ax.bar(
    x + width/2,
    pivot_mean["SNOWFLAKE"],
    width,
    yerr=pivot_ci["SNOWFLAKE"],
    capsize=6,
    label="Snowflake Schema"
)

ax.set_xticks(x)
ax.set_xticklabels(
    pivot_mean.index,
    rotation=20
)

ax.set_title(
    "Execution Time with 95% Confidence Intervals"
)

ax.set_ylabel("Execution Time (ms)")
ax.set_xlabel("Benchmark Queries")

ax.legend()

plt.tight_layout()

plt.savefig(
    "./results/graph_ci95.png",
    dpi=300
)

plt.close()

# ============================================================
# SPEEDUP
# ============================================================

speedup_df = pivot_mean.copy()

speedup_df["speedup"] = (
    speedup_df["SNOWFLAKE"] /
    speedup_df["STAR"]
).round(2)

speedup_df.to_csv(
    "./results/speedup.csv"
)

# ============================================================
# PRINT RESULTS
# ============================================================

print("\n================================================")
print("STATISTICAL RESULTS")
print("================================================\n")

print(stats_df)

print("\n================================================")
print("SPEEDUP")
print("================================================\n")

print(speedup_df)

print("\n✅ 95% confidence intervals calculated!")
print("✅ T-tests completed!")
print("✅ CSV files exported!")
print("✅ Graph generated!")