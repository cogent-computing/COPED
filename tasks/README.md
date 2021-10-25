# Pipeline Tasks and How to Run Them

This directory contains CoPED data pipeline processing tasks.

Each task is runnable manually using `docker compose run` or automatically using Apache Airflow. Tasks are generally long running and have dependencies, which can be managed in Airflow.

> To run tasks manually use:
> 
> `docker compose run --rm -w <container_working_directory> <name_of_service> <task_command> <task_options>`

- The container working directory is where to run the task from. It always begins with `/tasks` followed by the relevant task directory, for example `/tasks/ukri_crawler` for the crawler.
- The name of the service is the name in the `docker-compose.yaml` file, which also corresponds to the directory name of the task. For example, `ukri_crawler` for the crawler.
- The task command is an executable script, either on the path of the container such as `scrapy` for the crawler, or in the referenced working directory, such as `./ukri_link_extractor.py` for the link extractor.

## Task Overviews

NB: For more details of the UKRI crawler, see the dedicated section below these task overviews.

### Crawl UKRI API

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

### Populate UKRI Resources

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

### Populate UKRI Relations

```
Usage: populate-ukri-relations [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to read. [required]
--sql_db TEXT       Name of PostgreSQL database to update.  [required]
--sql_table TEXT    Name of PostgreSQL table to update.  [required]

DESCRIPTION

Extract relations between UKRI resources in the given CouchDB database. The discovered relations are inserted in the PostgreSQL table.
```

### Crawl UKWA Website

```
Usage: crawl-ukwa-website [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to write to. [required]
                    DB is created if it does not already exist.
--search_term TEXT  Word or "phrase" to search for in the UKWA archive. [required]

DESCRIPTION

Use the given search term to find archived UK web pages. Discovered pages are saved to the given CouchDB database.
```

### Extract Named Entities

```
Usage: extract-named-entities [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to update. [required]

DESCRIPTION

Run NLP for named entity extraction on records in the given database. Discovered entities are recorded in the document metadata for downstream processing.
```

### Populate UKWA Resources

```
Usage: populate-ukwa-resources [OPTIONS]

OPTIONS

--couch_db TEXT     Name of CouchDB database to read.  [required]
--sql_db TEXT       Name of PostgreSQL database to update.  [required]
--sql_table TEXT    Name of PostgreSQL table to update.  [required]

DESCRIPTION

Record UK Web Archive resources into PostgreSQL. The given CouchDB database is queried for all documents. Their `_id` (UUIDv4), `item_type`, and a basic text summary are added to the PostgreSQL table.
``` 


----------


# URKI Crawler Information

Crawler for project meta-data API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

## Running the Crawler

To manually run the crawler use:

`docker compose run --rm -w /tasks/ukri_crawler ukri_crawler scrapy crawl ukri-projects-crawler -a queries=<queries>`

Here `<queries>` should be a comma separated list of words and "double quoted phrases" to search for.

## Entrypoints

For each search term, the following API endpoint is used to find matching projects.

`https://gtr.ukri.org/gtr/api/projects?q={search_term}`

## Related Data

Given a project from a returned search, related entities from its links are also parsed and saved when present.

- Persons
- Organisations
- Funds
- Outcomes:
    * Key Findings
    * Impact Summaries
    * Publications
    * Collaborations
    * Intellectual Properties
    * Further Fundings
    * Policy Influences
    * Products
    * Research Materials
    * Spinouts
    * Disseminations

## Related Data `rel` Descriptors

The relations documented for the UKRI API are:

- `PI_PER` Principal Investigator
- `COI_PER` Co-Investigator
- `PM_PER` Project Manager
- `FELLOW_PER` Fellow
- `EMPLOYEE` Employee
- `ORCID_ID` Person's ORCID ID details
- `EMPLOYED` Employer
- `LEAD_ORG` Lead research organisation
- `COLLAB_ORG` Collaborating organisation
- `FELLOW_ORG` Fellow organisation
- `COFUND_ORG` Co-Funder
- `PP_ORG` Project partner
- `FUNDER` Funder
- `FUND` Fund
- `PROJECT` Project
- `ARTISTIC_AND_CREATIVE_PRODUCT` Artistic and creative product
- `COLLABORATION` Collaboration
- `DISSEMINATION` Dissemination
- `FURTHER_FUNDING` Further funding
- `IMPACT_SUMMARY` Impact summary
- `IP` Intellectual property
- `KEY_FINDING` Key finding
- `POLICY` Policy influence
- `PRODUCT` Product intervention
- `PUBLICATION` Publication
- `RESEARCH_DATABASE_AND_MODEL` Research DB and model
- `RESEARCH_MATERIAL` Research material
- `SOFTWARE_AND_TECHNICAL_PRODUCT` Software and technical product
- `SPIN_OUT` Spin out
