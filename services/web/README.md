# Web Service

This is the main Django application service, running the frontend and the API.

Run Django administration commands from the top level with `python manage.py ...`.

### `Dockerfile`

Standard Python `pip install` for the dependencies.

### `requirements.txt`

Nothing special here.

### `entrypoint.sh`

- Waits for the PostgreSQL server to be accessible on the network.
- Flushes the database if running in `DEVELOPMENT`, otherwise skips and preserves existing data.
- Applies outstanding Django migrations to the DB
- Gathers static files from installed apps and puts them somewhere `nginx` can find them:
    - The `settings.py` file targets sets `STATIC_ROOT` using an environment variable of the same name, set by Docker compose.
