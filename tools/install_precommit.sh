#!/usr/bin/env bash
# pre-commit Installer for C-CLAW (大头虾) environment
# Usage: bash install_precommit.sh
set -euo pipefail

echo "=== pre-commit Installer (mly-relay) ==="
echo ""

echo "[1/4] Checking Python..."
command -v python3 &>/dev/null || { echo "  ERROR: Python3 not found."; exit 1; }
echo "  OK: $(python3 --version)"

echo ""
echo "[2/4] Checking pip..."
python3 -m pip --version &>/dev/null 2>&1 || { echo "  ERROR: pip not found."; exit 1; }
echo "  OK: pip available"

echo ""
echo "[3/4] Installing pre-commit..."
command -v pre-commit &>/dev/null && echo "  SKIP: $(pre-commit --version)" || {
    python3 -m pip install pre-commit
    echo "  OK: installed"
}

echo ""
echo "[4/4] Setting up git hooks..."
if [ -d ".git" ]; then
    pre-commit install
    echo "  OK: hooks installed"
else
    echo "  SKIP: not a git repo (run 'pre-commit install' in your repo)"
fi

echo ""
echo "=== Done ==="
echo "Copy config/.pre-commit-config.yaml to your repo, then:"
echo "  pre-commit install && pre-commit run --all-files"
