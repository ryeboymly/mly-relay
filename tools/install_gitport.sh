#!/usr/bin/env bash
# gitport-github installer — GitHub accelerator with real IP table
# Project: https://github.com/zhidian-cmd/gitport-github | License: Apache-2.0
set -euo pipefail
echo "=== Installing gitport-github ==="
command -v cargo &>/dev/null || { echo "ERROR: Rust/Cargo not found. Install Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"; exit 1; }
git clone https://github.com/zhidian-cmd/gitport-github.git /tmp/gitport-github 2>/dev/null || true
cd /tmp/gitport-github && cargo build --release
cp target/release/gitport-github /usr/local/bin/ 2>/dev/null || true
echo "OK: gitport-github built"
echo "Usage: ./gitport-github (default port 8181)"
echo "Then: git config --global http.proxy http://127.0.0.1:8181"
