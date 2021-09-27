# Nginx Service

Reverse proxy for outward-facing services:

- `/` maps to the `web` service
- use of environment:
    - `${DASHBOARDS_ROOT}` maps to the `voila` service
    - `/static/` maps to the `${STATIC_LOCATION}` directory
        * This directory must correspond to a bind mount or volume that is __shared__ with the `web` service, so that Django can make all of the necessary static files available.

## ToDo

- Configure https with [Let's Encrypt](https://letsencrypt.org/)