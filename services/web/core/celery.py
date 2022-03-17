# Configure Celery to use Redis and to discover tasks in tasks.py files in app directories.
# Note: settings.CELERY_IMPORTS can also be used to specify a list of modules that contain tasks.
# The second approach is useful when a module with tasks is not in the settings.INSTALLED_APPS list.

import os
from celery import Celery

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD")
REDIS_AUTH = (":" + REDIS_PASSWORD + "@") if REDIS_PASSWORD else ""
REDIS_PORT = os.environ.get("REDIS_PORT", 6379)

app = Celery("core", backend="redis", broker=f"redis://{REDIS_AUTH}redis:{REDIS_PORT}")

app.config_from_object("django.conf:settings", namespace="CELERY")

app.autodiscover_tasks()
