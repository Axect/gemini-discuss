#!/bin/sh
# recent-files.sh - Find recently modified files
# Usage: sh recent-files.sh [project_root] [minutes]

PROJECT_ROOT="${1:-.}"
MINUTES="${2:-30}"

cd "$PROJECT_ROOT" 2>/dev/null || exit 1

echo "=== Files modified in the last ${MINUTES} minutes ==="

FILES=$(find . -type f -mmin "-${MINUTES}" \
    -not -path './.git/*' \
    -not -path './node_modules/*' \
    -not -path './__pycache__/*' \
    -not -path './target/*' \
    -not -path './.venv/*' \
    -not -path './venv/*' \
    -not -path './dist/*' \
    -not -path './build/*' \
    -not -path './.next/*' \
    2>/dev/null | sort)

echo "$FILES"
echo ""
echo "Total: $(echo "$FILES" | grep -c '^') files"
