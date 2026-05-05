import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# =========================
# LOAD DATA
# =========================
df = pd.read_csv("results.csv")

pivot = df.pivot(index="query_name", columns="schema_type", values="execution_time_ms")

# Garantir ordem consistente
pivot = pivot.sort_index()

# =========================
# 1. BAR CHART (PADRÃO)
# =========================
pivot.plot(kind="bar", figsize=(10,6))

plt.title("Star vs Snowflake Execution Time")
plt.ylabel("Execution Time (ms)")
plt.xlabel("Query")
plt.xticks(rotation=45)

plt.tight_layout()
plt.savefig("graph_bar_standard.png", dpi=300)
plt.close()

# =========================
# 2. LOG SCALE (CRÍTICO)
# =========================
pivot.plot(kind="bar", figsize=(10,6), logy=True)

plt.title("Execution Time (Log Scale)")
plt.ylabel("Execution Time (ms - log scale)")
plt.xlabel("Query")
plt.xticks(rotation=45)

plt.tight_layout()
plt.savefig("graph_log_scale.png", dpi=300)
plt.close()

# =========================
# 3. SPEEDUP (MAIS IMPORTANTE)
# =========================
speedup = pivot["SNOWFLAKE"] / pivot["STAR"]

speedup.plot(kind="bar", figsize=(10,6))

plt.axhline(y=1, linestyle='--')  # linha neutra

plt.title("Speedup (Snowflake / Star)")
plt.ylabel("Speedup Ratio")
plt.xlabel("Query")
plt.xticks(rotation=45)

plt.tight_layout()
plt.savefig("graph_speedup.png", dpi=300)
plt.close()

# =========================
# 4. DIFERENÇA PERCENTUAL
# =========================
percent_diff = ((pivot["SNOWFLAKE"] - pivot["STAR"]) / pivot["STAR"]) * 100

percent_diff.plot(kind="bar", figsize=(10,6))

plt.title("Performance Degradation (%) Snowflake vs Star")
plt.ylabel("Percentage (%)")
plt.xlabel("Query")
plt.xticks(rotation=45)

plt.tight_layout()
plt.savefig("graph_percentage_diff.png", dpi=300)
plt.close()

print("✅ Gráficos gerados com sucesso!")