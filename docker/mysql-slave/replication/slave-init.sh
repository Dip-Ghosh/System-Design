#!/bin/bash
set -e

echo "Starting MySQL Slave initialization..."

# Wait for MySQL to be ready
until mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
  echo "Waiting for MySQL Slave to be ready..."
  sleep 2
done

# Wait for master to be ready
until mysql -h mysql_master -u$MYSQL_REPL_USER -p$MYSQL_REPL_PASSWORD -e "SELECT 1" >/dev/null 2>&1; do
  echo "Waiting for MySQL Master to be accessible..."
  sleep 5
done

echo "MySQL Slave is ready. Configuring replication..."

# Configure slave replication
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
  -- Stop slave if running
  STOP SLAVE;

  -- Reset slave configuration
  RESET SLAVE ALL;

  -- Configure master connection
  CHANGE MASTER TO
    MASTER_HOST='mysql_master',
    MASTER_PORT=3306,
    MASTER_USER='$MYSQL_REPL_USER',
    MASTER_PASSWORD='$MYSQL_REPL_PASSWORD',
    MASTER_AUTO_POSITION=1;

  -- Start slave
  START SLAVE;

  -- Show slave status
  SHOW SLAVE STATUS\G
EOSQL

echo "MySQL Slave initialization completed successfully!"
echo "Slave status:"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW SLAVE STATUS\G"
