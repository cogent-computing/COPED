# Pipeline Tasks and How to Run Them

This directory contains CoPED data pipeline processing tasks.

Each task is:

- packaged with all of its dependencies as a Dockerised script
- runnable manually using `docker-compose run` or automatically using Apache Airflow's `DockerOperator`
- generally long running

> To run tasks manually use:
> 
> `docker-compose run --rm -w <container_working_directory> <name_of_service> <task_command> <task_options>`

## Task Details

### Crawl UKRI API - Status:Complete

Working directory: `/app/ukri/ukri`
Name of service: `ukri_crawler`

```
Usage: scrapy crawl ukri-projects-spider [OPTIONS]

OPTIONS

-a queries=TEXT     [required] Comma separated list of words or "phrases" to search for.

ENVIRONMENT [defaults]

$COUCHDB_HOST [localhost]       Hostname for the CouchDB server. 
$COUCHDB_PORT [5984]            Port for the CouchDB server.
$COUCHDB_USER [coped]           Username for DB operations.
$COUCHDB_PASSWORD [password]    Password for the user above.
$COUCHDB_DB [ukri-dev-data]     DB name in CouchDB to store the data.

DESCRIPTION

Use the given query term(s) to find projects in the UKRI database. Result list is recursively parsed to find related resources such as people, organisations, and so on. All resources are saved to the given CouchDB database.
```

### Populate UKRI Resources - Status:Todo

Working directory: `/app`
Name of service: `ukri_resources`

```
Usage: populate-ukri-resources

ENVIRONMENT

$COUCHDB_HOST [localhost]                   Hostname for the CouchDB server. 
$COUCHDB_PORT [5984]                        Port for the CouchDB server.
$COUCHDB_USER [coped]                       Username for DB operations.
$COUCHDB_PASSWORD [password]                Password for the user above.
$COUCHDB_DB [ukri-dev-data]                 DB name in CouchDB to store the data.
$POSTGRES_HOST [localhost]                  Hostname for the PostgreSQL server. 
$POSTGRES_PORT [5432]                       Port for the PostgreSQL server.
$POSTGRES_USER [coped]                      Username for DB operations.
$POSTGRES_PASSWORD [password]               Password for the user above.
$POSTGRES_DB [coped-dev-db]                 PostgreSQL database to use.

DESCRIPTION

Record UKRI resources in PostgreSQL. The given CouchDB database is queried for all documents. Their `_id` (UUIDv4) is added to the PostgreSQL `coped_resource` table with a foreign key to the `coped_resource_type` table.
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
