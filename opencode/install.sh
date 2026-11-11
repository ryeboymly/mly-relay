#!/usr/bin/env bash
# OpenCode installer for C-CLAW (大头虾) environment
# Usage: bash install.sh
#
# This script will be populated with actual install steps
# once cap-webfetch connectivity is confirmed.

set -euo pipefail

echo "=== OpenCode Installer (mly-relay) ==="
echo "TODO: Populate with actual installation steps"
echo "Prerequisites: Node.js >= 18, npm"
echo ""
echo "Step 1: Check Node.js"
node --version 2>/dev/null || { echo "ERROR: Node.js not found"; exit 1; }
echo ""
echo "Step 2: Check npm"
npm --version 2>/dev/null || { echo "ERROR: npm not found"; exit 1; }
echo ""
echo "Step 3: Install OpenCode (placeholder)"
# npm install -g opencode-ai
echo "TODO: Uncomment after confirming npm registry access"
echo ""
echo "=== Done ==="
