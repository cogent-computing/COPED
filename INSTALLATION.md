# CoPED Installation

These instructions outline how to get the CoPED platform running locally for development as well as on a production host.
The steps are very similar except for the use of different `.env` environment files and `.yaml` Docker Compose files depending on the deployment.

## Overview

The CoPED platform consists of the services defined in `docker-compose.yaml` and `docker-compose.override.yaml`. It is built around the Django web application in the `web` service.

### Core services

* `web` - Django web application
  * Main application settings are in `./services/web/core/settings.py`
  * Management operations and daemons needed for the service are specified in `./services/web/entrypoint.sh`
    * This is run by the service container on each boot
* `db` - PostgreSQL used by `web` and `metabase` services to store their DBs
* `metabase` - An analytics and visualisation web server that queries (read-only) the data in `db`
* `elasticsearch` - Indexing of objects in `db` for better text searches
* `redis` - Message queues for async and/or long process communication

> NB: The `web` service contains all business logic.  
> Other services are basically *stock Docker Hub images* with their configuration controlled by `.env` environment files and minor tweaks in a `Dockerfile` build file, when needed.

### Extra services

* `nginx` - Reverse HTTP proxy
  * Can be used in production if an existing proxy is not available
  * Bare bones configuration appears in `./configs/nginx-default.conf.template`

### Development services

* `selenium` - Available for running automated tests in a virtual browser.

## Install

### Prerequisites

1. A recent Debian based OS is preferred, i.e. Ubuntu or Debian.
   * Debian 10 "Buster" was used for this guide.
   * Any OS with Docker available should work, such as MacOS for local development.
2. Docker and Docker Compose must be available.
   * Docker 20.10.13 and Docker Compose 2.2.3 were used for this guide.
3. [Git Large File Storage](https://git-lfs.github.com/) (LFS) extension installed, for example by using the [Debian/Ubuntu installation instructions](https://github.com/git-lfs/git-lfs/wiki/Installation#ubuntu).
4. Sufficient server resources for the CoPED Docker services to run.
   * Test VPS system used 16GB RAM, 8 vCPUs, and 160GB SSD
   * There were no resource issues with this configuration. However, over time the DB and logs will grow, and CPU requirements for the DB and ElasticSearch indexing will increase, so adjust accordingly.

> Note that this guide uses a Docker Compose version 2.x.x so the command `docker compose` is used.  
> Recent versions of Docker Compose 1.x.x should also work, in wich case use the command `docker-compose` instead.

### Development

#### Empty database

1. Clone the CoPED repository from [https://github.com/cogent-computing/COPED](https://github.com/cogent-computing/COPED).
2. Copy `.env.example` to `.env`.
3. From the main directory run `docker compose up -d` and wait for the build if it is the first run.

You can now launch the application in a local browser, either through the Nginx proxy using `http://localhost`, or using `http://localhost:8000` to access the server directly.
The address with port 8000 provides a Django debug toolbar (top right) and will show tracebacks in the browser on errors.

At this point there are no users or data in the application database.
You will probably want to create at least one user account that is a superuser, as follows. Run the following command from inside the `COPED/` main directory.

4. `docker compose exec web python /app/manage.py createsuperuser`

#### Add some data

The steps above 

1. Load some test users and test data by populating the two application databases:
   1. `./dbdata/repopulate_db.sh -d coped_development -f dbdata/coped.backup.sql`
   2. `./dbdata/repopulate_db.sh -d metabase -f dbdata/metabase.backup.sql`

