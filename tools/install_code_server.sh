#!/usr/bin/env bash
# code-server installer — VS Code in browser
# Project: https://github.com/coder/code-server | License: MIT
set -euo pipefail
echo "=== Installing code-server ==="
if command -v code-server &>/dev/null; then echo "SKIP: already installed"; exit 0; fi
curl -fsSL https://code-server.dev/install.sh | sh
echo "OK: code-server installed"
code-server --version
echo "Usage: code-server --bind-addr 0.0.0.0:8080"
