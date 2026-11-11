#!/usr/bin/env bash
# CF-GitHub-Proxy installer — GitHub mirror proxy via Cloudflare Workers
# Project: https://github.com/hubporg/CF-GitHub-Proxy | License: MIT
set -euo pipefail
echo "=== CF-GitHub-Proxy Setup ==="
echo "This tool deploys to Cloudflare Workers/Snippets."
echo "Please visit: https://github.com/hubporg/CF-GitHub-Proxy"
echo "Follow the README to deploy."
echo ""
echo "After deployment:"
echo "  git clone https://<worker>.workers.dev/https://github.com/user/repo.git"
