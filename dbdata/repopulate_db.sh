#!/usr/bin/env bash

# NB: run this script from the top-level directory containing `docker-compose.yaml`
# Re-populate the development database on demand.
# Ensure the database name below (default = 'coped_development') matches what your development environment uses.

echo "Stopping containers and repopulating the db."

docker-compose down
docker-compose up -d db
docker-compose exec db psql -d postgres -c "SELECT pg_terminate_backend(psa.pid) FROM pg_stat_activity psa WHERE datname = 'coped_development' AND pid <> pg_backend_pid();"
docker-compose exec db psql -d postgres -c "DROP DATABASE coped_development;"
docker-compose exec db psql -d postgres -c "CREATE DATABASE coped_development;"
docker-compose exec db psql -d coped_development < dbdata/coped.backup.sql

echo "Data updated. Starting web container."

docker-compose up -d web

echo "Web container now running."
