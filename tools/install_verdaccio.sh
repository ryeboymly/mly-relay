#!/usr/bin/env bash
# verdaccio installer — Private npm proxy registry
# Project: https://github.com/verdaccio/verdaccio | License: MIT
set -euo pipefail
echo "=== Installing verdaccio ==="
command -v npm &>/dev/null || { echo "ERROR: npm not found"; exit 1; }
npm install -g verdaccio
echo "OK: verdaccio installed"
echo "Usage: verdaccio (default port 4873)"
echo "Then: npm config set registry http://localhost:4873"
