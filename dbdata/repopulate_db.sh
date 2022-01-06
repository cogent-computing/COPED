#!/usr/bin/env bash

# NB: run this script from the top-level directory containing `docker-compose.yaml`
# Re-populate the development database on demand.
# Ensure the database names below matche what your environment uses.

coped_db=coped_development
coped_backup=dbdata/coped.backup.sql
metabase_db=metabase
metabase_backup=dbdata/metabase.backup.sql

echo "Stopping containers."
docker-compose down
docker-compose up -d db

echo "Repopulating CoPED database '${coped_db}' from backup."
docker-compose exec db psql -d postgres -c "SELECT pg_terminate_backend(psa.pid) FROM pg_stat_activity psa WHERE datname = '${coped_db}' AND pid <> pg_backend_pid();"
docker-compose exec db psql -d postgres -c "DROP DATABASE ${coped_db};"
docker-compose exec db psql -d postgres -c "CREATE DATABASE ${coped_db};"
docker-compose exec db psql -d ${coped_db} < ${coped_backup}

echo "Repopulating Metabase database '${metabase_db}' from backup."
docker-compose exec db psql -d postgres -c "SELECT pg_terminate_backend(psa.pid) FROM pg_stat_activity psa WHERE datname = '${metabase_db}' AND pid <> pg_backend_pid();"
docker-compose exec db psql -d postgres -c "DROP DATABASE ${metabase_db};"
docker-compose exec db psql -d postgres -c "CREATE DATABASE ${metabase_db};"
docker-compose exec db psql -d ${metabase_db} < ${metabase_backup}

echo "Data updated. Starting CoPED services."
docker-compose up -d

echo "Complete. You can now use the CoPED application."
