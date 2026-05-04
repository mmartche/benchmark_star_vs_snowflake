#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash 02_generate_tpcds_data.sh <scale_factor> <tools_dir> <output_dir>
# Example:
#   bash 02_generate_tpcds_data.sh 1 ~/src/tpcds-kit/tools ~/data/tpcds_sf1

SF="${1:-1}"
TOOLS_DIR="${2:-}"
OUT_DIR="${3:-}"

if [[ -z "$TOOLS_DIR" || -z "$OUT_DIR" ]]; then
  echo "Usage: bash 02_generate_tpcds_data.sh <scale_factor> <tools_dir> <output_dir>"
  exit 1
fi

mkdir -p "$OUT_DIR"
cd "$TOOLS_DIR"

./dsdgen -force -dir "$OUT_DIR" -scale "$SF"

echo "TPC-DS data generated in: $OUT_DIR"
echo "Expected files include: date_dim.dat, customer.dat, customer_address.dat, customer_demographics.dat, item.dat, store.dat, store_sales.dat"
