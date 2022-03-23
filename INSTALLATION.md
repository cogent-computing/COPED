# CoPED Installation

These instructions outline how to get the CoPED platform running locally for development as well as on a production host.

See the [overview](./OVERVIEW.md) for a description of the services that make up the application.

## Prerequisites

1. A recent Debian based OS [preferred]
2. Docker and Docker Compose
3. [Git Large File Storage](https://git-lfs.github.com/) (LFS) extension
   * [Debian/Ubuntu installation instructions](https://github.com/git-lfs/git-lfs/wiki/Installation#ubuntu).
4. Sufficient server resources
   * Test VPS system used 16GB RAM, 8 vCPUs, and 160GB SSD without any issues.


> Depending on the installed Docker Compose version the command(s) below will be either `docker compose` or `docker-compose`. These instructions assume version 2.x.x. 

## Install for Development

> TODO: information about setting up CAPTCHA and transactional email settings.

### Spin up the Docker Compose application

1. Clone the CoPED repository from [https://github.com/cogent-computing/COPED](https://github.com/cogent-computing/COPED).
2. Copy `.env.example` to `.env`.
3. From the main directory run `docker compose up -d` (and wait for the build if it is the first run...)

> You can now launch the application in a browser. However, you must set up a superuser as described below to access the Metabase analytics components.  
> Port mappings are provided in `docker-compose.override.yaml` in case you need to access services directly.  
> If the host is not `localhost` then update `DJANGO_ALLOWED_HOSTS` in `.env` accordingly, before Step 3.

### Set up a superuser

For a minimal approach use the following command once the app above is running.
It will create a superuser account in the CoPED and Metabase databases for managing the application.

```
$ docker compose exec web python /app/manage.py createsuperuser_for_coped --username <username> --email <email@example.com> --first-name <firstname> --last-name <lastname>
```

> Now update the `.env` file so that `METABASE_SUPERUSER_*` settings match the credentials you just set, and restart the `web` service.

You can now sign in as the superuser, administer the app, and access the Metabase analytics pages.

### Alternatively: use example data

To begin with some basic example data, including a superuser and projects, run the following commands.

> Warning: the following commands will destroy any existing database of the same name.

```
$ ./dbdata/repopulate_db.sh -d coped_development -f dbdata/coped.backup.sql
$ ./dbdata/repopulate_db.sh -d metabase -f dbdata/metabase.backup.sql
```

Now log in with the administrator account provided (username: "copedadmin", email: "copedadmin@example.com", password: "Password123!") to view and manage the test data.


## Install for Production

As above, with the following changes.

* At Step 2. The settings in `.env` should be updated to include any production values and credentials, and file permissions should be restricted.
* At Step 3. When spinning up the app use the explicit `-f` file option, as follows, to prevent use of the Docker Compose overrides.

```
$ docker compose up -d -f docker-compose.yaml
```
