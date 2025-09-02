#!/usr/bin/env bash
set -euo pipefail

# Wait until slave MySQL is ready
until mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
  echo "⏳ Waiting for mysql_slave..."
  sleep 2
done

# Wait until master is reachable
until mysql -h mysql_master -P 3306 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
  echo "⏳ Waiting for mysql_master..."
  sleep 2
done

echo "⚙️ Configuring replication from master to slave..."

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<'SQL'
STOP REPLICA;
RESET REPLICA ALL;
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='mysql_master',
  SOURCE_PORT=3306,
  SOURCE_USER='${MYSQL_REPL_USER}',
  SOURCE_PASSWORD='${MYSQL_REPL_PASSWORD}',
  SOURCE_AUTO_POSITION=1;
START REPLICA;
SQL

echo "✅ Replication configured!"
