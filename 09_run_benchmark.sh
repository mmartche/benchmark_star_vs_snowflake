#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash 09_run_benchmark.sh <database> <user> [host] [port]
# Example:
#   bash 09_run_benchmark.sh dwbench postgres localhost 5432

DB="${1:-dwbench}"
USER_NAME="${2:-postgres}"
HOST_NAME="${3:-localhost}"
PORT_NO="${4:-5432}"
SQL_FILE="07_benchmark_queries_tpcds.sql"
OUT_DIR="benchmark_results"
mkdir -p "$OUT_DIR"

for run in 1 2 3 4; do
  echo "Running benchmark iteration $run"
  psql -h "$HOST_NAME" -p "$PORT_NO" -U "$USER_NAME" -d "$DB" \
    -v ON_ERROR_STOP=1 \
    -c "\\timing on" \
    -f "$SQL_FILE" \
    > "$OUT_DIR/run_${run}.txt"
done

echo "Saved benchmark outputs in $OUT_DIR/"
