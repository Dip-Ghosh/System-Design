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

if [[ "${1:-}" == "--fresh" ]]; then
  echo "🛑 Removing containers, images, and volumes..."
  docker compose $COMPOSE_FILES down --rmi all --volumes --remove-orphans || true
  shift || true
fi

echo "🚀 Starting stack..."
docker compose $COMPOSE_FILES up -d --build "$@"

echo "✅ All services are up!"
