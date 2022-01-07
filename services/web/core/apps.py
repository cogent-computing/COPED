from django.apps import AppConfig
from django_registration.signals import user_registered
from django.contrib.auth import get_user_model
from django.db.models.signals import pre_save
from django.contrib.auth.signals import user_logged_in
from django.contrib.auth.signals import user_logged_out


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

        user_logged_in.connect(
            signals.user_login_handler,
            sender=get_user_model(),
            dispatch_uid="user_login_handler",
        )

        user_logged_out.connect(
            signals.user_logout_handler,
            sender=get_user_model(),
            dispatch_uid="user_logout_handler",
        )
