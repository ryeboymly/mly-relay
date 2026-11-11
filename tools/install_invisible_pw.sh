#!/usr/bin/env bash
# invisible_playwright installer — Anti-detection Playwright
# Project: https://github.com/feder-cr/invisible_playwright | License: MIT
set -euo pipefail
echo "=== Installing invisible_playwright ==="
command -v python3 &>/dev/null || { echo "ERROR: Python3 not found"; exit 1; }
python3 -m pip install invisible-playwright 2>/dev/null || {
    echo "pip install failed, trying git clone..."
    git clone https://github.com/feder-cr/invisible_playwright.git /tmp/invisible_pw 2>/dev/null || true
    cd /tmp/invisible_pw && python3 -m pip install -e .
}
echo "OK: invisible_playwright installed"
echo "Usage: from invisible_playwright import sync_playwright"
