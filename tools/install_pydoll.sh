#!/usr/bin/env bash
# pydoll installer — Browser automation without WebDriver (CDP direct)
# Project: https://github.com/autoscrape-labs/pydoll | License: MIT
set -euo pipefail
echo "=== Installing pydoll ==="
command -v python3 &>/dev/null || { echo "ERROR: Python3 not found"; exit 1; }
python3 -m pip install pydoll
echo "OK: pydoll installed"
echo "Usage: from pydoll.browser.chromium import Chrome"
