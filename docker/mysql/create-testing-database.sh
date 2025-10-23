#!/usr/bin/env bash
set -e

if [[ -z "$MYSQL_USER" || -z "$MYSQL_PASSWORD" ]]; then
  echo "Variáveis MYSQL_USER ou MYSQL_PASSWORD não estão definidas. Abortando criação do usuário."
  exit 1
fi

mysql --user=root --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS testing;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON testing.* TO '$MYSQL_USER'@'%';
    FLUSH PRIVILEGES;
EOSQL
