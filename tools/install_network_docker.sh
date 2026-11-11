#!/usr/bin/env bash
# claude-code-docker-container installer — Network-restricted Docker for AI agents
# Project: https://github.com/deancourse/claude-code-docker-container
set -euo pipefail
echo "=== Installing claude-code-docker-container ==="
command -v docker &>/dev/null || { echo "ERROR: Docker not found"; exit 1; }
git clone https://github.com/deancourse/claude-code-docker-container.git /opt/network-docker 2>/dev/null || true
echo "OK: cloned to /opt/network-docker"
echo "Edit whitelist IPs in /opt/network-docker, then run setup.sh"
echo "Usage: cd /opt/network-docker && ./setup.sh"
