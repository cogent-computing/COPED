from django.apps import AppConfig
from django_registration.signals import user_activated


class CoreConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "core"

    def ready(self):
        from . import signals

        user_activated.connect(
            signals.user_activation_handler, dispatch_uid="user_activation_handler"
        )
