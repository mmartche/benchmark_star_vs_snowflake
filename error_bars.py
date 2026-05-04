import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# =========================
# LOAD DATA
# =========================
df = pd.read_csv("results_multi.csv")

# =========================
# MÉDIA E DESVIO PADRÃO
# =========================
stats = df.groupby(["query_name", "schema_type"])["execution_time_ms"].agg(["mean", "std"]).reset_index()

pivot_mean = stats.pivot(index="query_name", columns="schema_type", values="mean")
pivot_std = stats.pivot(index="query_name", columns="schema_type", values="std")

# =========================
# 1. BAR COM ERROR BARS
# =========================
x = np.arange(len(pivot_mean.index))
width = 0.35

fig, ax = plt.subplots(figsize=(10,6))

ax.bar(x - width/2, pivot_mean["STAR"], width,
       yerr=pivot_std["STAR"], capsize=5, label="Star")

ax.bar(x + width/2, pivot_mean["SNOWFLAKE"], width,
       yerr=pivot_std["SNOWFLAKE"], capsize=5, label="Snowflake")

ax.set_xticks(x)
ax.set_xticklabels(pivot_mean.index, rotation=45)

ax.set_title("Execution Time with Error Bars")
ax.set_ylabel("Execution Time (ms)")
ax.set_xlabel("Query")

ax.legend()

plt.tight_layout()
plt.savefig("graph_error_bars.png", dpi=300)
plt.close()

# =========================
# 2. SPEEDUP COM ERROR BARS
# =========================
speedup = pivot_mean["SNOWFLAKE"] / pivot_mean["STAR"]

# erro aproximado (propagação simples)
speedup_err = speedup * np.sqrt(
    (pivot_std["SNOWFLAKE"]/pivot_mean["SNOWFLAKE"])**2 +
    (pivot_std["STAR"]/pivot_mean["STAR"])**2
)

fig, ax = plt.subplots(figsize=(10,6))

ax.bar(x, speedup, yerr=speedup_err, capsize=5)

ax.axhline(y=1, linestyle='--')

ax.set_xticks(x)
ax.set_xticklabels(pivot_mean.index, rotation=45)

ax.set_title("Speedup with Error Bars (Snowflake / Star)")
ax.set_ylabel("Speedup Ratio")
ax.set_xlabel("Query")

plt.tight_layout()
plt.savefig("graph_speedup_error.png", dpi=300)
plt.close()

print("✅ Gráficos com error bars gerados!")