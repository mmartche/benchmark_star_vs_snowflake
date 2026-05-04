#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash 01_build_tpcds_tools.sh /path/to/tpcds-kit/tools
# Example:
#   bash 01_build_tpcds_tools.sh ~/src/tpcds-kit/tools

TOOLS_DIR="${1:-}"
if [[ -z "$TOOLS_DIR" ]]; then
  echo "Usage: bash 01_build_tpcds_tools.sh /path/to/tpcds-kit/tools"
  exit 1
fi

cd "$TOOLS_DIR"
make clean || true
make

echo "Built dsdgen in: $TOOLS_DIR"
