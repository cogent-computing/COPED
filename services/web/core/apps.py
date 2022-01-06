from django.apps import AppConfig
from django_registration.signals import user_registered


class CoreConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "core"

    def ready(self):
        from . import signals

        user_registered.connect(
            signals.user_registration_handler, dispatch_uid="user_registration_handler"
        )
