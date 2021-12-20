# CoPED Web Application

This is the heart of the CoPED platform, based on a fairly standard Django web project setup.

It configures, implements and manages the following things:

- A [Django](https://docs.djangoproject.com/en/3.2/) website frontend.
- CoPED energy project data schemas defining the [PostgreSQL database](https://www.postgresql.org/).
- A simple [Django REST Framework](https://www.django-rest-framework.org/) API.
- Search indices in the [ElasticSearch](https://www.elastic.co/elasticsearch/) engine using [django-elasticsearch-dsl](https://django-elasticsearch-dsl.readthedocs.io/en/latest/quickstart.html).
- Long running extract and transform operations including [Scrapy](https://docs.scrapy.org/en/latest/) web crawling, NLP, and resource relation extraction.

### Core Django app

- Configures the Django project (see `settings.py` for main options)
- Defines all data schema models
- Implements the front end interface

### API Django app

- Configures a simple RESTful API for access to CoPED data.

### Scrapers directory

- Contains web scraping configuration to gather CoPED data automatically.

### Tasks directory

- Individual long-running scripts needed to process CoPED data for extraction and transformation.

### Templates directory

- Django site templates.

### Users directory

- Custom user model.

### Entrypoint script

- Applies outstanding Django migrations to the PostgreSQL DB.
- Gathers static files from installed apps to put them where `nginx` can find them.
- Re-indexes all projects in the database to ElasticSearch.
