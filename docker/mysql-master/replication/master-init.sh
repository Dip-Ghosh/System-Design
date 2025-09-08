#!/bin/bash
set -e

echo "Starting MySQL Master initialization..."

# Wait for MySQL to be ready
until mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
  echo "Waiting for MySQL Master to be ready..."
  sleep 2
done

echo "MySQL Master is ready. Running initialization script..."

# Run SQL using env vars
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
  -- Create database
  CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;

  -- Create application user with access from any host
  CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
  GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';

  -- Create replication user
  CREATE USER IF NOT EXISTS '$MYSQL_REPL_USER'@'%' IDENTIFIED BY '$MYSQL_REPL_PASSWORD';
  GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPL_USER'@'%';

  -- Allow root from any host (for Docker networking)
  CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

  -- Refresh privileges
  FLUSH PRIVILEGES;

  -- Show master status for slave configuration
  SHOW MASTER STATUS;

  -- Verify users were created
  SELECT user, host FROM mysql.user WHERE user IN ('root', '$MYSQL_USER', '$MYSQL_REPL_USER');
EOSQL

echo "MySQL Master initialization completed successfully!"
echo "Master status:"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW MASTER STATUS\G"
