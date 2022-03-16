import os

from celery import Celery

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD")
REDIS_AUTH = (":" + REDIS_PASSWORD + "@") if REDIS_PASSWORD else ""
REDIS_PORT = os.environ.get("REDIS_PORT", 6379)

app = Celery("core", backend="redis", broker=f"redis://{REDIS_AUTH}redis:{REDIS_PORT}")

app.config_from_object("django.conf:settings", namespace="CELERY")

app.autodiscover_tasks()


@app.task(bind=True)
def debug_task(self):
    print(f"Request: {self.request}")
