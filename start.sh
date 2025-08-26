#!/bin/bash
set -euo pipefail

# Always run relative to this script's directory
cd "$(dirname "$0")/docker"

echo "🛑 Cleaning up old containers..."
docker compose \
  -f compose.base.yml \
  -f compose.mysql.yml \
  -f compose.redis.yml \
  -f compose.app.yml \
  -f compose.nginx.yml \
  -f compose.elasticsearch.yml \
  -f compose.kibana.yml \
  down --remove-orphans || true


echo "🚀 Building and starting Laravel stack..."

docker compose \
  -f compose.base.yml \
  -f compose.mysql.yml \
  -f compose.redis.yml \
  -f compose.app.yml \
  -f compose.nginx.yml \
  -f compose.elasticsearch.yml \
  -f compose.kibana.yml \
  up -d --build

echo "✅ All services are up!"
