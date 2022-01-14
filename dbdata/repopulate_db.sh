#!/usr/bin/env bash

# USAGE:
#       ./repopulate_db.sh -d <name_of_database> -f <name_of_data_file>

# NB: run this script from the top-level directory containing `docker-compose.yaml`
# Re-populates or creates the specified database from an existing psql data dump on demand.
# Ensure the database name and file are given on the command line.

while getopts :d:f: flag
do
    case "${flag}" in
        d) database_name=${OPTARG};;
        f) data_file=${OPTARG};;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

echo "Repopulating (or creating) database '${database_name}' from backup file '${data_file}'."

read -p "Are you sure you wish to continue? [yes|no]"
if [ "$REPLY" != "yes" ]; then
   exit
fi

echo "Stopping containers."
docker-compose down
docker-compose up -d db

echo "Repopulating database '${database_name}' from file '${data_file}'."
docker-compose exec db psql -d postgres -c "SELECT pg_terminate_backend(psa.pid) FROM pg_stat_activity psa WHERE datname = '${database_name}' AND pid <> pg_backend_pid();"
docker-compose exec db psql -d postgres -c "DROP DATABASE ${database_name};"
docker-compose exec db psql -d postgres -c "CREATE DATABASE ${database_name};"
docker-compose exec db psql -d ${database_name} < ${data_file}

echo "Data updated. Restarting container services."
docker-compose up -d

echo "Complete."
