#!/usr/bin/env bash

# USAGE:
#       ./backup_db.sh -d <name_of_database> -f <name_of_data_file>

# NB: run this script from the top-level directory containing `docker compose.yaml`
# Backs up the specified database to a psql data dump (.sql file) on demand.
# Ensure the database name and file are given on the command line via the option flags.

while getopts :d:f: flag
do
    case "${flag}" in
        d) database_name=${OPTARG};;
        f) data_file=${OPTARG};;
    esac
done

echo "Backing up database '${database_name}' to backup file '${data_file}'."
echo "WARNING: this will replace ${data_file} if it already exists."

read -p "Are you sure you wish to continue? [yes|no]"
if [ "$REPLY" != "yes" ]; then
   exit
fi

echo "Ensuring database container is up..."
docker compose up -d db

echo "Dumping database '${database_name}' to file '${data_file}'."
docker compose exec db pg_dump ${database_name} > ${data_file}

echo "Complete."
