"""
Django settings for app project.

Generated by 'django-admin startproject' using Django 3.2.7.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.2/ref/settings/
"""

import os
import sys
from pathlib import Path

# SECURITY WARNING: don't run with debug/testing turned on in production!
DEBUG = int(os.environ.get("DEBUG", default=0))
TESTING = int(os.environ.get("TESTING", default=0))
LOGLEVEL = os.environ.get("LOGLEVEL", default="INFO")
LOG_LEVEL = os.environ.get("LOG_LEVEL", default="INFO")

SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "%(asctime)s %(name)-12s %(levelname)-8s %(message)s",
        },
    },
    "handlers": {
        "console": {
            "level": LOGLEVEL,
            "class": "logging.StreamHandler",
            "stream": sys.stdout,
            "formatter": "verbose",
        },
    },
    "loggers": {
        "": {
            "handlers": ["console"],
            "level": LOGLEVEL,
            "propagate": True,
        },
    },
}

SITE_ID = 1

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get("SECRET_KEY")

ALLOWED_HOSTS = os.environ.get(
    "DJANGO_ALLOWED_HOSTS", default="localhost 127.0.0.1 [::1]"
).split(" ")

# Set which IPs are able to access the Django debug toolbar
if DEBUG:
    import socket  # only if you haven't already imported this

    hostname, _, ips = socket.gethostbyname_ex(socket.gethostname())
    INTERNAL_IPS = [ip[:-1] + "1" for ip in ips] + ["127.0.0.1", "10.0.2.2"]


# Ignore warnings over url names containing a colon
SILENCED_SYSTEM_CHECKS = ["urls.W003"]

# Application definition

INSTALLED_APPS = [
    "leaflet",  # Show locations on maps
    "django.contrib.gis",  # Allow using geospatial model fields
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.sites",  # Dependency of Django-invitations app and for making sitemaps
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django.contrib.humanize",
    "django.contrib.sitemaps",  # auto site map generation
    "maintenance_mode",  # https://github.com/fabiocaccamo/django-maintenance-mode
    "django_select2",  # usable select and multi-select in forms
    "django_addanother",  # allow adding new foreign key or many to many relations on forms
    "bootstrap4",  # Nice formatting for forms etc.
    "extra_views",  # Helpful class based views for using inline formsets
    "anymail",  # Mail sending with various providers
    "django_registration",  # Two stage activation
    "hcaptcha",  # Secure registration
    "debug_toolbar",  # Development dependency
    "django_elasticsearch_dsl",
    "django_filters",
    "rest_framework",
    "django_extensions",  # Development dependency
    "easyaudit",  # Paper trail of model changes
    "pinax.messages",  # User-to-user messaging
    "pinax.announcements",  # Site-wide announcements
    "invitations",  # Django-invitations allows sending invites to external users
    "celery",  # Run long tasks asynchronously
    "django_celery_results",  # Store celery results using Django ORM
    "django_celery_beat",  # Store periodic task schedules using Django ORM
    "rules.apps.AutodiscoverRulesConfig",  # Per-object permissions
    "core.apps.CoreConfig",  # Main application.
    "api.apps.ApiConfig",  # Django REST Framework API serializers and views.
    "crudevents.apps.CrudeventsConfig",  # Extend the easyaudit model to give related object histories.
    "messagethreads.apps.MessagethreadsConfig",  # Proxy the Pinax thread model to add a method
    "dashboards.apps.DashboardsConfig",  # Contains models to access the dashboards table in Metabase DB
    "metabase_user.apps.MetabaseUserConfig",  # Models to access Metabase user records in its DB
]

AUTHENTICATION_BACKENDS = (
    # Uses by the 'rules' package
    "rules.permissions.ObjectPermissionBackend",
    "django.contrib.auth.backends.ModelBackend",
)

DJANGO_EASY_AUDIT_REGISTERED_CLASSES = [
    # Note that m2m fields without custom through models are tracked automatically.
    "core.project",
    "core.projectfund",
    "core.projectorganisation",
    "core.projectperson",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "debug_toolbar.middleware.DebugToolbarMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "core.middleware.metabase.metabase_cookie_middleware",
    "easyaudit.middleware.easyaudit.EasyAuditMiddleware",
    "maintenance_mode.middleware.MaintenanceModeMiddleware",
]

ROOT_URLCONF = "core.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [
            os.path.join(BASE_DIR, "templates"),
            os.path.join(BASE_DIR, "scrapers", "templates"),
        ],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
                "pinax.messages.context_processors.user_messages",
                "core.context_processors.analytics_processor",
                "core.context_processors.metabase_path_processor",
            ],
        },
    },
]

WSGI_APPLICATION = "core.wsgi.application"


# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases

DATABASES = {
    "default": {
        "ENGINE": os.environ.get("SQL_ENGINE", "django.db.backends.sqlite3"),
        "NAME": os.environ.get("SQL_DATABASE", BASE_DIR / "db.sqlite3"),
        "USER": os.environ.get("SQL_USER", "user"),
        "PASSWORD": os.environ.get("SQL_PASSWORD", "password"),
        "HOST": os.environ.get("SQL_HOST", "localhost"),
        "PORT": os.environ.get("SQL_PORT", "5432"),
    },
    "metabase": {
        "ENGINE": os.environ.get("METABASE_ENGINE", "django.db.backends.sqlite3"),
        "NAME": os.environ.get("METABASE_DATABASE", BASE_DIR / "metabase.db.sqlite3"),
        "USER": os.environ.get("METABASE_USER", "user"),
        "PASSWORD": os.environ.get("METABASE_PASSWORD", "password"),
        "HOST": os.environ.get("METABASE_HOST", "localhost"),
        "PORT": os.environ.get("METABASE_PORT", "5432"),
    },
}
DATABASE_ROUTERS = [
    "dashboards.db_routers.DashboardRouter",
    "metabase_user.db_routers.MetabaseUserRouter",
]

CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.db.DatabaseCache",
        "LOCATION": "select2_cache_table",
    },
}

MIGRATION_MODULES = {
    "pinax_messages": "messagethreads.migrate__pinax_messages",
    "easyaudit": "crudevents.migrate__easyaudit",
}

SELECT2_CACHE_BACKEND = "default"


# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.2/howto/static-files/

STATIC_URL = "/static/"
STATIC_ROOT = os.environ.get("STATIC_ROOT", "/usr/share/django/staticfiles")

# Default primary key field type
# https://docs.djangoproject.com/en/3.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# Django REST Framework settings
# https://www.django-rest-framework.org/api-guide/settings/

REST_FRAMEWORK = {
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 10,
    "DEFAULT_RENDERER_CLASSES": [
        "rest_framework.renderers.JSONRenderer",
        "rest_framework.renderers.BrowsableAPIRenderer",
    ],
    "ORDERING_PARAM": "ordering",
}


# Config for django-elasticsearch-dsl
ELASTIC_HOSTNAME = os.environ.get("ELASTIC_HOSTNAME", "elasticsearch")
ELASTIC_PORT = os.environ.get("ELASTIC_PORT", 9200)
ELASTIC_USER = os.environ.get("ELASTIC_USER", "elastic")
ELASTIC_PASSWORD = os.environ.get("ELASTIC_PASSWORD", "password")
ELASTICSEARCH_DSL = {
    "default": {
        "hosts": f"{ELASTIC_HOSTNAME}:{ELASTIC_PORT}",
        "http_auth": (ELASTIC_USER, ELASTIC_PASSWORD),
    },
}


# Use a custom user model
AUTH_USER_MODEL = "core.User"


# Django-Registration
ACCOUNT_ACTIVATION_DAYS = 7  # One-week activation window
REGISTRATION_OPEN = True


# Site-wide URLs
LOGIN_REDIRECT_URL = "index"
LOGOUT_REDIRECT_URL = "index"


# hCaptcha
if not TESTING:
    HCAPTCHA_SITEKEY = os.environ.get("HCAPTCHA_SITEKEY")
    HCAPTCHA_SECRET = os.environ.get("HCAPTCHA_SECRET")


# Mail sending
if TESTING:
    EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"
else:
    EMAIL_BACKEND = "anymail.backends.mailjet.EmailBackend"

ANYMAIL = {
    "MAILJET_API_KEY": os.environ.get("MAILJET_API_KEY"),
    "MAILJET_SECRET_KEY": os.environ.get("MAILJET_SECRET_KEY"),
    "DEBUG_API_REQUESTS": DEBUG,
}
DEFAULT_FROM_EMAIL = os.environ.get("DEFAULT_FROM_EMAIL")
SERVER_EMAIL = os.environ.get("SERVER_EMAIL")
SUPPORT_EMAIL = os.environ.get("SUPPORT_EMAIL")
EMAIL_USE_TLS = True
EMAIL_USE_SSL = True

# Maps
LEAFLET_CONFIG = {
    # "SPATIAL_EXTENT": (5.0, 44.0, 7.5, 46),
    # "DEFAULT_CENTER": (53.55, -2.433),
    "DEFAULT_ZOOM": 15,
    "MIN_ZOOM": 1,
    "MAX_ZOOM": 18,
    "DEFAULT_PRECISION": 10,
    "PLUGINS": {
        "cluster": {
            "css": [
                "https://unpkg.com/leaflet.markercluster@1.1.0/dist/MarkerCluster.css",
                "https://unpkg.com/leaflet.markercluster@1.1.0/dist/MarkerCluster.Default.css",
            ],
            "js": "https://unpkg.com/leaflet.markercluster@1.1.0/dist/leaflet.markercluster.js",
            "auto-include": True,
        }
    },
}


# Invitations

INVITATIONS_GONE_ON_ACCEPT_ERROR = False
INVITATIONS_SIGNUP_REDIRECT = "django_registration_register"
INVITATIONS_LOGIN_REDIRECT = "login"
INVITATIONS_EMAIL_SUBJECT_PREFIX = "[CoPED] "


# Redis

REDIS_PORT = os.environ.get("REDIS_PORT", 6379)
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD", "secret")

# Celery

REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD")
REDIS_AUTH = (":" + REDIS_PASSWORD + "@") if REDIS_PASSWORD else ""
REDIS_PORT = os.environ.get("REDIS_PORT", 6379)
BROKER_URL = f"redis://{REDIS_AUTH}redis:{REDIS_PORT}"
CELERY_RESULT_BACKEND = f"django-db"
CELERY_ACCEPT_CONTENT = ["application/json"]
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"
CELERY_IMPORTS = [
    "taggers.subject_tagger",
    "taggers.keyword_tagger",
    "taggers.address_geotagger",
    "taggers.region_geotagger",
    "scrapers.celery_tasks",
    "tasks.indexing",
]

# recycle the pool worker process for every task
# CELERYD_MAX_TASKS_PER_CHILD = 1


# Maintenance mode
# https://github.com/fabiocaccamo/django-maintenance-mode
MAINTENANCE_MODE_IGNORE_ADMIN_SITE = True
MAINTENANCE_MODE_IGNORE_SUPERUSER = True
MAINTENANCE_MODE_REDIRECT_URL = None  # set a redirect URL if desired
MAINTENANCE_MODE_RETRY_AFTER = 60 * 60 * 24  # 1 day
MAINTENANCE_MODE_GET_TEMPLATE_CONTEXT = "core.maintenance_mode.get_context"
