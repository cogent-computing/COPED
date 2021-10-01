# COPED: Catalogue of Projects on Energy Data

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

1. Copy `docker-compose.override.yaml.example` to `docker-compose.override.yaml`
2. Copy `.env.example` to `.env` and ensure `ENVIRONMENT=DEVELOPMENT` is set.
3. Run: `docker-compose up -d`

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

4. Docker will generally notice changes and rebuild and recache images when necessary. To force an image rebuild, add the `--build` flag to the `docker-compose` commands above.

## Production

### Steps

1. Copy `.env.example` to `.env.prod` and ensure `ENVIRONMENT=PRODUCTION` is set.
2. Run: `docker-compose --env-file .env.prod up -d`
    > Ensure that there is no `docker-compose.override.yaml` file present. It is explicitly ignored in `.gitignore` to help with this.

### Summary

* application access point is `localhost:1337`
* no bind mounts - only volumes are used
* does not flush database to protect existing data

## Environments

An example file `.env.example` is provided as a template. This can be copied and renamed to allow multiple environment configurations.

A basic setup with two environments is:

- `.env` for development settings
- `.env.prod` for production settings

The `.env` file is used automatically by `docker-compose` when spinning up the cluster.

To apply production settings, set the `--env-file .env.prod` flag on `docker-compose`. Generally this would be done when also _ignoring_ the default `docker-compose.override.yaml` overrides in one of the following ways:

- do not have a `docker-compose.override.yaml` in production environments - the file is ignored in git by default to help with this
- use the `-f` flag to specify the file to use with `docker-compose -f docker-compose.yaml --env-file .env.prod up -d`




## TODOs

- Integrate Kibana via Nginx proxy
- Ensure Elasticsearch is protected with environment-specific credentials (currently no auth beyond standard `elastic` user)
- Split the Docker internal networking:
    1. data microservices (Elasticsearch etc.)
    2. web and API containers exposed to the host 
- Move to three environments:
    - Dev, Staging/CI, Production
    - Use Docker [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) to ensure Production containers do not contain any dev/test/CI dependencies
    - Ensure a container registry such as the [GitHub Container Registry](https://ghcr.io) is used to push to production via GH Actions, rather than pulling from GitHub with a Git client.
- Check for other [container anti-patterns](https://codefresh.io/containers/docker-anti-patterns/) and mitigate them.
- Ensure the Voila container is properly configured to cull idle or slow kernels.


### Done


- ~~**IMPORTANT** switch away from the `alpine` base images for containers~~
    - These have only short term support in terms of security
    - More practically, they do not fully support ARM architectures (e.g. new Macs)
    - Need to move to Debian-based images such as `buster` or `buster-slim`
- ~~Use [Docker compose override](https://docs.docker.com/compose/extends/) configurations to reduce duplication across the `docker-compose*` files.~~
- ~~Investigate whether using [environment variable substitution](https://docs.docker.com/compose/environment-variables/) in compose files can reduce duplication even further.~~
