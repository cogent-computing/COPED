from django.apps import AppConfig
from django_registration.signals import user_registered
from django.contrib.auth import get_user_model
from django.db.models.signals import pre_save


class CoreConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "core"

    def ready(self):
        from . import signals

        user_registered.connect(
            signals.user_registration_handler,
            dispatch_uid="user_registration_handler",
        )
        pre_save.connect(
            signals.detect_password_change,
            sender=get_user_model(),
            dispatch_uid="detect_password_change",
        )
