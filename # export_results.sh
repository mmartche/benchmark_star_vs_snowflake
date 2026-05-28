# ============================================================
# export_results.sh
# ============================================================

mkdir -p results

psql -U postgres -d dwbench -c "
COPY (
    SELECT
        query_name,
        schema_type,
        execution_time_ms
    FROM benchmark_results
    ORDER BY query_name, schema_type
) TO STDOUT WITH CSV HEADER;
" > results/results.csv

echo "✅ results.csv exported!"