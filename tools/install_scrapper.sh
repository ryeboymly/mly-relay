#!/usr/bin/env bash
# scrapper installer — Web scraper with REST API in Docker
# Project: https://github.com/amerkurev/scrapper | License: MIT
set -euo pipefail
echo "=== Installing scrapper ==="
command -v docker &>/dev/null || { echo "ERROR: Docker not found"; exit 1; }
docker pull amerkurev/scrapper
echo "OK: scrapper image pulled"
echo "Usage: docker run -d --name scrapper -p 8080:8080 amerkurev/scrapper"
echo "API: curl http://localhost:8080/?url=https://example.com"
