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
    - to avoid this behaviour comment out the relevant lines in `frontend/app/entrypoints.sh`.

### Production

Steps:

1. Create environment files `.env.prod` and `.env.prod.db`
    - use `.env.dev` and `.env.dev.db` as a template
2. Run `docker-compose -f docker-compose.prod.yml up -d`

Summary:

* no bind mounts - only volumes are used
* uses the Gunicorn production wsgi server
* uses an Nginx container to proxy HTTP requests
* shares a volume between `frontend` and `nginx` to collect static files
* access the web server on `localhost:1337`
* does not migrate databases automatically to protect existing data
    - run migrations manually in a container shell or with `docker-compose ... exec ...`


## TODOs

- Implement a non-root user for the `frontend-db` and `nginx` containers to improve security.
    - See `./frontend/Dockerfile.prod` for an example of how this is done


