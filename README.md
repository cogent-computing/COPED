# Develop-Deploy for COPED Containers

This repository contains the application microservices architecture for COPED, set up as a fully containerised Docker application.

The architecture is a skeleton and contains no COPED application code. Instead, it configures the development and production environments for easy setup and teardown.

> Integrating existing COPED application code into this framework will be done in a separate repository or in the main [COPED application repository](https://github.com/cogent-computing/COPED). This repo is used to experiment on and refine the microservice configuration so it works in multiple environments.

## Launching COPED microservices

_Note that the first `up` command will also build and cache the images. This will take a few minutes. Subsequent `up` commands use the cache and take a couple of seconds._

### Development

Steps:

1. Copy `docker-compose.override.yaml.example` to `docker-compose.override.yaml`
2. Copy `.env.example` to `.env` and ensure `ENVIRONMENT=DEVELOPMENT` is set.
3. Run: `docker-compose up -d`

Summary:

* tries to mirror as much of the _production_ build as possible
* application access point is `localhost:1337`
* uses the `docker-compose.override.yaml` for development mode
    - __turns on debugging__
    - uses bind mounts to enable direct code editing inside containers
        - VSCode's `Docker` extension is useful here :-)
* automatically flushes the database when spun up
    > to avoid this behaviour comment out the relevant line in `web/entrypoint.sh`.
* limits memory usage by the Elasticsearch service to avoid slowdowns

### Production

Steps:

1. Copy `.env.example` to `.env.prod` and ensure `ENVIRONMENT=PRODUCTION` is set.
2. Run: `docker-compose up -d`
    > Ensure that there is no `docker-compose.override.yaml` file present. It is explicitly ignored in `.gitignore` to help with this.

Summary:

* application access point is `localhost:1337`
* no bind mounts - only volumes are used
* does not flush database to protect existing data

### Rebuilds

Docker will generally notice changes and rebuild and recache images when necessary. To force an image rebuild, add the `--build` flag to the `docker-compose` commands above.

## TODOs

- Ensure Elasticsearch is protected with environment-specific credentials (currently no auth)
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
