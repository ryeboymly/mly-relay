#!/usr/bin/env bash
# camofox-browser installer — Stealth headless browser for AI agents
# Project: https://github.com/jo-inc/camofox-browser | License: MIT
set -euo pipefail
echo "=== Installing camofox-browser ==="
command -v npm &>/dev/null || { echo "ERROR: npm not found"; exit 1; }
npm install -g camofox-browser 2>/dev/null || npm install camofox-browser
echo "OK: camofox-browser installed"
echo "Usage: const { browser } = require('camofox-browser');"
