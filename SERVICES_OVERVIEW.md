# Overview

The CoPED platform consists of the services defined in `docker-compose.yaml` and `docker-compose.override.yaml`. It is built around the Django web application in the `web` service.

## Core services

* `web` - Django web application
  * Main application settings are in `./services/web/core/settings.py`
  * Management operations and daemons needed for the service are specified in `./services/web/entrypoint.sh`
    * This is run by the service's container on each boot
* `db` - PostgreSQL used by `web` and `metabase` services to store their DBs
* `metabase` - An analytics and visualisation web server that queries (read-only) the data in `db`
* `elasticsearch` - Text indexing for objects in `db`
* `redis` - Message queues for async and/or long process communication

> NB: The `web` service contains all the business logic.  
> Other services are basically *stock Docker Hub images* with their configuration controlled by `.env` environment files and minor tweaks in a `Dockerfile` build file, when needed.

## Extra services

* `nginx` - Reverse HTTP proxy
  * Can be used in production if an existing proxy is not available
  * Required configuration appears in `./configs/nginx-default.conf.template`
    * This is mainly used to proxy specific URL paths to the different Compose services

## Development services

* `selenium` - Available for running automated tests in a virtual browser.

## External dependencies

* [hCaptcha](https://www.hcaptcha.com/) for bot protection
* [MailJet](https://www.mailjet.com/) for transactional email (configurable)
