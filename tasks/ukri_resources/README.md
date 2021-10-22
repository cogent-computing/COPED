# UKRI Resources

This task transfers the IDs of UKRI resources in CouchDB to the CoPED PostgreSQL DB.

It also adds the appropriate resource types against the IDs in the PostgreSQL resource table.

## Running the Resource ID Transfer

To manually initiale the transfer use:

`docker-compose run --rm -w /app ./populate-ukri-resources.py`
