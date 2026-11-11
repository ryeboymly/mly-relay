#!/usr/bin/env bash
# ttyd installer — Web terminal sharing
# Project: https://github.com/tsl0922/ttyd | License: MIT
set -euo pipefail
echo "=== Installing ttyd ==="
if command -v ttyd &>/dev/null; then echo "SKIP: already installed"; exit 0; fi
# Try apt first
apt-get update -qq && apt-get install -y -qq ttyd 2>/dev/null && echo "OK: via apt" && exit 0
# Fallback: download binary
ARCH=$(uname -m)
case "$ARCH" in x86_64) ARCH="x86_64";; aarch64|arm64) ARCH="aarch64";; *) echo "ERROR: unsupported arch $ARCH"; exit 1;; esac
echo "Downloading ttyd binary (${ARCH})..."
curl -sL "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.${ARCH}" -o /usr/local/bin/ttyd
chmod +x /usr/local/bin/ttyd
echo "OK: ttyd installed"
ttyd --version
echo "Usage: ttyd --port 7681 bash"
