#!/usr/bin/env bash
set -euo pipefail

# Go to docker folder (one level up from scripts/)
cd "$(dirname "$0")/.."

COMPOSE_FILES="
    -f compose.base.yml
    -f compose.app.yml
    -f compose.nginx.yml
    -f compose.mysql.yml
    -f compose.redis.yml
    -f compose.elasticsearch.yml
    -f compose.kibana.yml
    -f compose.worker.yml
"

echo "🛑 Stopping all services..."
docker compose $COMPOSE_FILES down --remove-orphans
