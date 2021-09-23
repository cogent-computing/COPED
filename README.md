# Develop-Deploy for COPED Containers

This repository contains the application microservices architecture for COPED, set up as a fully containerised Docker application.

The architecture is a skeleton and contains no COPED application code. Instead, it configures the development and production environments for easy setup and teardown.

> Integrating existing COPED application code into this framework will be done on a development branch of the main [COPED application repository](https://github.com/cogent-computing/COPED). This repo is used to experiment on and refine the microservice configuration so it works in multiple environments.

## Launching COPED microservices

### Development

Steps:

1. Run: `docker-compose up -d`

Summary:

* uses bind mounts from the local filesystem to enable direct code editing
* uses Django's built-in wsgi development server
* access the web server on `localhost:8000`
* automatically migrates the development database when spun up
    - to avoid this behaviour comment out the relevant lines in `web/empty_app/entrypoints.sh`.

### Production

Steps:

1. Create appropriate environment files in the `./envs/prod/` directory
    - use `./envs/prod-example/` as a template
2. Run `docker-compose -f docker-compose.prod.yml up -d`

Summary:

* no bind mounts - only volumes are used
* uses the Gunicorn production wsgi server
* uses an Nginx container to proxy HTTP requests
* shares a volume between `web` and `nginx` to collect static files
* access the web server on `localhost:1337`
* does not migrate databases automatically, to protect existing data
    - run migrations manually in a container shell or with `docker-compose ... exec ...`


## TODOs

- Split the Docker internal networking:
    1. data microservices (Elasticsearch etc.)
    2. web and API containers exposed to the host 
- Use [Docker compose override](https://docs.docker.com/compose/extends/) configurations to reduce duplication across the `docker-compose*` files.
- Investigate whether using [environment variable substitution](https://docs.docker.com/compose/environment-variables/) in compose files can reduce duplication even further.  
- Move to three environments:
    - Dev, Staging, Production
    - Use Docker [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) to ensure Production containers do not contain any dev/test/CI dependencies
    - Ensure a container registry such as the [GitHub Container Registry](https://ghcr.io) is used to push to production via GH Actions, rather than pulling from GitHub with a Git client.
- Implement a non-root user for the `db` and `nginx` containers to improve security.
    - See `./web/Dockerfile.prod` for an example of how this is done
- Check for other [container anti-patterns](https://codefresh.io/containers/docker-anti-patterns/) and mitigate them.
