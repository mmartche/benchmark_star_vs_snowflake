import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# =========================
# LOAD DATA
# =========================
df = pd.read_csv("./results/results.csv")

# =========================
# CALCULAR ESTATÍSTICAS
# =========================
grouped = df.groupby(["query_name", "schema_type"])["execution_time_ms"]

stats_df = grouped.agg(['mean', 'std', 'count']).reset_index()

# =========================
# CALCULAR INTERVALO DE CONFIANÇA 95%
# =========================
confidence = 0.95

ci_list = []

for _, row in stats_df.iterrows():
    mean = row['mean']
    std = row['std']
    n = int(row['count'])

    if n > 1:
        t_val = stats.t.ppf((1 + confidence) / 2., n-1)
        margin = t_val * (std / np.sqrt(n))
    else:
        margin = 0

    ci_list.append(margin)

stats_df['ci95'] = ci_list

# =========================
# PIVOT PARA PLOT
# =========================
pivot_mean = stats_df.pivot(index="query_name", columns="schema_type", values="mean")
pivot_ci = stats_df.pivot(index="query_name", columns="schema_type", values="ci95")

# =========================
# GRÁFICO COM CI 95%
# =========================
x = np.arange(len(pivot_mean.index))
width = 0.35

fig, ax = plt.subplots(figsize=(10,6))

ax.bar(x - width/2,
       pivot_mean["STAR"],
       width,
       yerr=pivot_ci["STAR"],
       capsize=6,
       label="Star")

ax.bar(x + width/2,
       pivot_mean["SNOWFLAKE"],
       width,
       yerr=pivot_ci["SNOWFLAKE"],
       capsize=6,
       label="Snowflake")

ax.set_xticks(x)
ax.set_xticklabels(pivot_mean.index, rotation=45)

ax.set_title("Execution Time with 95% Confidence Intervals")
ax.set_ylabel("Execution Time (ms)")
ax.set_xlabel("Query")

ax.legend()

plt.tight_layout()
plt.savefig("graph_ci95.png", dpi=300)
plt.close()

# =========================
# PRINT RESULTADOS
# =========================
print(stats_df)
print("✅ Intervalos de confiança (95%) calculados!")