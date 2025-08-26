#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/docker"

echo "🛑 Stopping Laravel stack..."

docker compose \
  -f compose.base.yml \
  -f compose.mysql.yml \
  -f compose.redis.yml \
  -f compose.app.yml \
  -f compose.nginx.yml \
  -f compose.elasticsearch.yml \
  -f compose.kibana.yml \
  down "$@"

echo "✅ Stack stopped!"
