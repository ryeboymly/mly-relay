#!/usr/bin/env bash
# claude-code-devcontainer installer — Sandboxed devcontainer for AI agents
# Project: https://github.com/trailofbits/claude-code-devcontainer | License: Apache-2.0
set -euo pipefail
echo "=== Installing claude-code-devcontainer ==="
command -v docker &>/dev/null || { echo "ERROR: Docker not found"; exit 1; }
git clone https://github.com/trailofbits/claude-code-devcontainer.git /opt/claude-devcontainer 2>/dev/null || true
cd /opt/claude-devcontainer && docker build -t sandbox-agent .
echo "OK: sandbox-agent image built"
echo "Usage: docker run -it --rm sandbox-agent"
