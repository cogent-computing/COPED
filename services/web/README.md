# CoPED Web Application

This is the heart of the CoPED platform, based on a fairly standard Django web project setup.

It configures, implements and manages the following things:

- A [Django](https://docs.djangoproject.com/en/3.2/) website frontend.
- A [Django REST Framework](https://www.django-rest-framework.org/) API.
- CoPED energy project data schemas defining the [PostgreSQL database](https://www.postgresql.org/).
- Search indices in the [ElasticSearch](https://www.elastic.co/elasticsearch/) engine using [django-elasticsearch-dsl-drf](https://django-elasticsearch-dsl-drf.readthedocs.io/en/latest/quick_start.html).

The `core/` Django application:

- configures the overall project in `settings.py`
- wires up the project URL structure in `urls.py`
- sets up all of the core database schemas used by the CoPED platform in `models.py`
- configures which data can be managed in the Django administration interface in `admin.py`

The `api/` Django application:

- configures data representations in `serializers.py`
- connects these to the core application models in `views.py`

### Docker

The `Dockerfile` installs dependencies from `requirements.txt` then launches an `entrypoint.sh` script.

The script does the following things:

- Apply outstanding Django migrations to the PostgreSQL DB
- Gather static files from installed apps and put them where `nginx` can find them
