# Develop-Test-Deploy for COPED Containers

This repository contains the application microservices architecture for COPED, set up as a fully containerised Docker application.

The architecture is a skeleton and contains no COPED application code. Instead, it configures the development and production environments for easy setup and teardown.

> Integrating existing COPED application code into this framework will be done on a development branch of the main [COPED application repository](https://github.com/cogent-computing/COPED). This repo is used to experiment on and refine the microservice configuration so it works across multiple environments.

## Launching COPED microservices

### Development (Local Machine)

> `docker-compose up -d`

* uses bind mounts from the local filesystem to enable direct code editing
* uses Docker volumes for data storage
* uses Django's built-in wsgi development server
* maps container ports to the host machine for direct access
* automatically migrates the development database when spun up
    - to avoid this behaviour comment out the relevant lines in `frontend/app/entrypoints.sh`.

### Production (Local or Remote Machine)

> `docker-compose -f docker-compose.prod.yml up -d`

* does not bind the local filesystem
* uses Docker volumes for data storage
* uses the Gunicorn production wsgi server
* uses an Nginx container to proxy HTTP requests
    - this provides the only ports exposed to the host
* does not migrate databases automatically to protect existing data
    - run migrations manually in a container shell or with `docker-compose ... exec ...`

