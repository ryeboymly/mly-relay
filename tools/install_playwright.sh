#!/usr/bin/env bash
# Playwright Chromium Installer for C-CLAW (大头虾) environment
# Usage: bash install_playwright.sh
set -euo pipefail

echo "=== Playwright Chromium Installer (mly-relay) ==="
echo ""

echo "[1/4] Checking Node.js..."
command -v node &>/dev/null || { echo "  ERROR: Node.js not found."; exit 1; }
echo "  OK: $(node --version)"

echo ""
echo "[2/4] Checking npm..."
command -v npm &>/dev/null || { echo "  ERROR: npm not found."; exit 1; }
echo "  OK: npm $(npm --version)"

echo ""
echo "[3/4] Installing Playwright package..."
npm ls -g playwright 2>/dev/null | grep -q playwright && echo "  SKIP: already installed" || npm install -g playwright
echo "  OK"

echo ""
echo "[4/4] Installing Chromium browser engine (~150MB)..."
npx playwright install chromium && echo "  OK: Chromium installed" || {
    echo "  npx failed, trying python fallback..."
    python3 -m playwright install chromium || { echo "  ERROR: Both methods failed"; exit 1; }
}

echo ""
echo "=== Verification ==="
npx playwright install --dry-run chromium 2>/dev/null && echo "SUCCESS" || echo "Run 'npx playwright install chromium' manually"
echo ""
echo "Usage:"
echo "  from playwright.sync_api import sync_playwright"
echo "  with sync_playwright() as p:"
echo "      browser = p.chromium.launch()"
