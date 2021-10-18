# Pipeline Tasks

This directory contains CoPED data pipeline processing tasks.

Each task is:

- packaged with all of its dependencies as a Dockerised script
- runnable internally from its container's shell or externally using Apache Airflow's `DockerOperator`
- long running

> To run internally use:
> 
> `docker-compose run --rm -w /path/to/task <name_of_service> <task_command> <task_options>`

## Task Details

### Crawl UKRI API - Status:Complete

Task location: `/app/ukri/ukri`

```
Usage: scrapy crawl ukri-projects-spider [OPTIONS]

OPTIONS

-a queries=TEXT     Comma separated list of words or "phrases" to search for. [required]

ENVIRONMENT

$COUCHDB_HOST [localhost]       Hostname for the CouchDB server. 
$COUCHDB_PORT [5984]            Port for the CouchDB server.
$COUCHDB_USER [coped]           Username for DB operations.
$COUCHDB_PASSWORD [password]    Password for the user above.
$COUCHDB_NAME [ukri-data]       DB name in CouchDB to store the data.

DESCRIPTION

Use the given query term(s) to find projects in the UKRI database. Result list is recursively parsed to find related resources such as people, organisations, and so on. All resources are saved to the given CouchDB database.
```

### Populate UKRI Resources - Status:Todo

```
Usage: populate-ukri-resources [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to read.  [required]
--sql_db TEXT       Name of PostgreSQL database to update.  [required]
--sql_table TEXT    Name of PostgreSQL table to update.  [required]

DESCRIPTION

Record UKRI resources in PostgreSQL. The given CouchDB database is queried for all documents. Their `_id` (UUIDv4), `item_type`, and a basic text summary are added to the PostgreSQL table.
``` 

### Populate UKRI Relations - Status:Todo

```
Usage: populate-ukri-relations [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to read. [required]
--sql_db TEXT       Name of PostgreSQL database to update.  [required]
--sql_table TEXT    Name of PostgreSQL table to update.  [required]

DESCRIPTION

Extract relations between UKRI resources in the given CouchDB database. The discovered relations are inserted in the PostgreSQL table.
```

### Crawl UKWA Website - Status:Todo

```
Usage: crawl-ukwa-website [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to write to. [required]
                    DB is created if it does not already exist.
--search_term TEXT  Word or "phrase" to search for in the UKWA archive. [required]

DESCRIPTION

Use the given search term to find archived UK web pages. Discovered pages are saved to the given CouchDB database.
```

### Extract Named Entities - Status:Todo

```
Usage: extract-named-entities [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to update. [required]

DESCRIPTION

Run NLP for named entity extraction on records in the given database. Discovered entities are recorded in the document metadata for downstream processing.
```

### Populate UKWA Resources - Status:Todo

```
Usage: populate-ukwa-resources [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to read.  [required]
--sql_db TEXT       Name of PostgreSQL database to update.  [required]
--sql_table TEXT    Name of PostgreSQL table to update.  [required]

DESCRIPTION

Record UK Web Archive resources into PostgreSQL. The given CouchDB database is queried for all documents. Their `_id` (UUIDv4), `item_type`, and a basic text summary are added to the PostgreSQL table.
``` 
