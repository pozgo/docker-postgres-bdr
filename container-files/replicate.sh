#!/bin/sh
set -eu
export TERM=xterm
# Bash Colors
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@";
  else echo; fi
}

message() {
  echo "========================================================================"
  echo "    You can now connect to this PostgreSQL Server using:                "
  echo "    psql -U $POSTGRES_USER -W $POSTGRES_PASSWORD -h<host> --port $POSTGRES_PORT"
  echo "                                                                        "
  echo "    For security reasons, you might want to change the above password.  "
  echo "============================================s============================"
}

if [ $MODE == 'master' ]; then
  sleep 5
  log "User Selected replication method: ${MODE}"
  while true; do if cat /var/lib/postgresql/data/pg_log/postgresql*.log | grep "database system is ready to accept connections"; then break; else sleep 1; fi done
  psql $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -c "CREATE EXTENSION IF NOT EXISTS btree_gist;"
  psql $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -c "CREATE EXTENSION IF NOT EXISTS bdr;"
  psql $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -c "SELECT bdr.bdr_group_create(
    local_node_name := '${HOSTNAME}',
    node_external_dsn := 'host=${HOSTNAME} port=${MASTER_PORT} dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}'
  );"
  message
  log "Database started in ${MODE} mode"
elif [ $MODE == 'slave' ]; then
  sleep 15
  log "User Selected replication method: ${MODE}"
  while true; do if cat /var/lib/postgresql/data/pg_log/postgresql*.log | grep "database system is ready to accept connections"; then break; else sleep 1; fi done
  psql $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -c "CREATE EXTENSION IF NOT EXISTS btree_gist;"
  psql $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -c "CREATE EXTENSION IF NOT EXISTS bdr;"
  psql $POSTGRES_DB -U $POSTGRES_USER -p $POSTGRES_PORT -c "SELECT bdr.bdr_group_join(
    local_node_name := '${HOSTNAME}',
    node_external_dsn := 'host=${HOSTNAME} port=${SLAVE_PORT} dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}',
    join_using_dsn := 'host=${MASTER_ADDRESS} port=${MASTER_PORT} dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}'
  );"
  message
  log "Database started in ${MODE} mode"
elif [ $MODE == 'single' ]; then
  message
  log "Database started in single mode. No replication!!!"
fi
