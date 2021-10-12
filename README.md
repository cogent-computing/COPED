# COPED: Catalogue of Projects on Energy Data

> __Development Status:__ Pre-Alpha - service orchestration, continuous integration setup, refactoring of prototype features.

![screenshot_coped](docs/images/coped-landing.png "Figure 1 - Screenshot of Coped")

**Fig 1 - COPED Front Page Screenshot**

COPED, or the Catalogue of Projects on Energy Data aims to unify various information stores and existing portals for energy projects under a single extendable umbrella that has two key roles:

1. Update, curate and correct information pertaining to the existing energy project landscape through manual and automated processes.
2. Offer a wide range of visual aids, query tools and metrics that enable users to synthesize information across the energy projects landscape at a given time.

COPED aims to provide diverse insights for various user groups, while being able to continuously expand its data capture sources and the analytics and visualisations it can perform.

As a platform, COPED aims to be extensible. As COPED reaches maturity and wide adoption, the product aims to allow individuals and institutions to contribute extensions and features to the product, as well as uploading, curating, and analysing existing data.
  

----

  
# COPED Development

This repository contains the COPED application code which is based around a microservices architecture, implemented as a fully containerised Docker application.

The codebase aims to allow easy setup and teardown of development and testing environments, and easy deployment of the production environment after updates.

The following guidance provides an overview of the development process for contributors.

> Links to user documentation will be added above once the codebase matures and user features are fully developed. 

## Development

[Docker compose](https://docs.docker.com/compose/) is used to orchestrate COPED services.

### Steps

1. Clone the repository.
2. Run `docker-compose up -d`

### Summary

* tries to mirror as much of the _production_ build as possible
* application access point is `localhost:1337`
* uses the `docker-compose.override.yaml` for development mode
    - __turns on debugging__
    - uses bind mounts to enable direct code editing inside containers
        - VSCode's `Docker` extension is useful here :-)
* automatically flushes the database when spun up
    > to avoid this behaviour comment out the relevant line in `web/entrypoint.sh`.
* limits memory usage by the Elasticsearch and Logstash services to avoid slowdowns

### Notes

1. The first `up` command will also build and cache the images. This will take many minutes on a slow connection. Subsequent `up` commands use the cache and take a couple of seconds.

2. The [ELK stack](https://www.elastic.co/what-is/elk-stack) (Elasticsearch, Logstash, Kibana) is hungry for memory. When developing on a low-powered machine (desktop/laptop) ensure that the Docker Desktop application is configured with a reasonable amount of memory, otherwise the Java heap will use all the allocated memory and cause issues. A setting of __4GB__ for Docker Desktop on Mac seems to work, as a rough guide. 

3. The Logstash service can be fussy on first launch, when the volume is also created, since it seems to require an existing volume with prior bootstrap configuration saved. If this happens (which can be confirmed by looking at the Logstash logs) simply restart the Logstash container over the now-existing volume.

## Production

To run a sample "deployment" version of CoPED do the following.

### Steps

1. _Delete or rename `docker-compose.override.yaml`._
2. Copy `.env` to `.env.prod` and ensure `ENVIRONMENT=PRODUCTION` is set.
3. Update permissions `chmod 0600 .env.prod` and update the production credentials.
4. Run: `docker-compose --env-file .env.prod up -d`

### Summary

* application access point is `localhost:1337`
* volumes rather than binds are used where possible
* does not flush database to protect existing data

## Continuous Integration

Pull requests targeting the `main` branch are automatically tested using a GitHub Actions CI workflow. Check out `.github/workflows` to view the current checks.
