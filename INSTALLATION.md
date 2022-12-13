# CoPED Installation

These instructions outline how to get the CoPED platform running locally for development as well as on a production host.

See the [overview](./OVERVIEW.md) for a description of the services that make up the application.

## Prerequisites

1. A recent Debian based OS [preferred]
2. Docker and Docker Compose
   * Use command `docker-compose` or `docker compose` depending on your version.
3. [Git Large File Storage](https://git-lfs.github.com/) (LFS) extension
   * [Debian/Ubuntu installation instructions](https://github.com/git-lfs/git-lfs/wiki/Installation#ubuntu).
   * Use command `git lfs pull origin` to force the download of LFS files if needed.
4. Sufficient server resources
   * As a guide: a laptop with 8GB RAM and 256GB SSD is more than sufficient for development.

## Install for Development

### Spin up the Docker Compose application

1. Clone the CoPED repository from [https://github.com/cogent-computing/COPED](https://github.com/cogent-computing/COPED).
2. Copy `.env.example` to `.env`.
3. From the main directory run `docker compose up -d` (and wait for the build if it is the first run...)

You can now launch the application in a browser. However, you must set up a superuser as described below to access the Metabase analytics components.

Port mappings are provided in `docker-compose.override.yaml` in case you need to access services directly.  

> If your host is not `localhost` then update `DJANGO_ALLOWED_HOSTS` in `.env` accordingly, before Step 3.

### Set up a superuser

For a minimal approach use the following command once the app above is running.
It will create a superuser account in the CoPED and Metabase databases for managing the application.

```
$ docker compose exec web python /app/manage.py createsuperuser_for_coped --username <username> --email <email@example.com> --first-name <firstname> --last-name <lastname>
```

> Now update the `.env` file so that `METABASE_SUPERUSER_*` settings match the credentials you just set, and restart the `web` service.

You can now sign in as the superuser, administer the app, and access the Metabase analytics pages.

### Populate the application settings

A data fixture is provided to pre-populate the application settings for CoPED. Run the following command to use it.

```
$ python manage.py loaddata --app core --ignorenonexistent --format json core/fixtures/app_setting.json
```

After the data is loaded, adjust the values of the application settings using the admin interface.

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
  * IMPORTANT: when configuring Metabase through its Admin UI, the database password for CoPED must correspond to the password set in `.env`
* At Step 3. When spinning up the app use the explicit `-f` file option, as follows, to prevent use of the Docker Compose overrides.

```
$ docker compose up -d -f docker-compose.yaml
```

## Maintenance mode

During updates/management that require downtime, the CoPED application can be put into maintenance mode by setting the flag in `maintenance_mode_state.txt` to 1. This file is in the `core` app of the Django project.

Maintenance mode allows administrators to authenticate against the admin login at path `/admin`, which then allows access to the rest of the site while under maintenance.

## External dependencies

### Email

#### Providers

The application uses Django's `anymail` app so it can be hooked to any of the compatible email providers [listed here](https://anymail.dev/en/stable/esps/), with a few lines of code changes. Currently it uses [Mailjet](https://www.mailjet.com/) and sets the API keys in the `.env` file.

#### SMTP

Alternatively, Django's default email backend can be used with appropriate SMTP settings in `settings.py`.

### Captcha

To prevent bot registrations the application embeds an [hCaptcha](https://www.hcaptcha.com/) challenge in the registration form. A free hCaptcha account is needed to supply the API key, in the `.env` file, to make this work. 

### Traffic Analysis

The application embeds a Google Analytics script to record usage and engagement. A Google Analytics ID is needed to do this, which can be [created here](https://analytics.google.com/analytics) and must be set in the CoPED administration under `Core > Application Settings > Google Analytics ID`.
