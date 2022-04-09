"""
Custom User model for CoPED.

See https://docs.djangoproject.com/en/3.2/topics/auth/customizing/ for details
and considerations when using a custom model. In particular, note the following.

> Instead of referring to User directly, you should reference the user model using
> django.contrib.auth.get_user_model(). This method will return the currently active
> user model – the custom user model if one is specified, or User otherwise.

> When you define a foreign key or many-to-many relations to the user model, you
> should specify the custom model using the AUTH_USER_MODEL setting.

There are various other requirements, related to how Django-Registration works with
the User model. See https://django-registration.readthedocs.io/en/3.2/custom-user.html
for specifics on this.
"""

from django.conf import settings
from django.db import models
from django.core.mail import send_mail
from django.contrib.auth.models import AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.contrib.auth.models import UserManager
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from uuid import uuid4
from metabase_user.models import MetabaseUser


class User(AbstractBaseUser, PermissionsMixin):
    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    username = models.CharField(
        _("username"),
        max_length=256,
        unique=True,
    )
    email = models.EmailField(
        _("email address"),
        unique=True,
    )
    first_name = models.CharField(max_length=250)
    last_name = models.CharField(max_length=250)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    is_contributor = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)

    # A cross-db "foreign key" field is used to associate this user with a Metabase profile:
    metabase_id = models.IntegerField(
        editable=False, null=True, verbose_name="Metabase ID"
    )

    USERNAME_FIELD = "username"  # Needed for Django-Registration

    objects = UserManager()  # Every custom User model needs an explicit manager

    class Meta:
        # Set the custom user model to have the standard Django database table name
        db_table = "auth_user"

    def email_user(self, subject, message, from_email=None, **kwargs):
        if from_email is None:
            from_email = settings.DEFAULT_FROM_EMAIL
        if settings.DEBUG:
            print(f"SENDING EMAIL TO USER WITH ID {self.id}")
            print("subject:", subject)
            print("message:", message)
            print("from_email", from_email)
        send_mail(
            subject=subject,
            message=message,
            from_email=from_email,
            recipient_list=[self.email],
        )

    def delete(self):
        # When a user deletes their account, the corresponding Metabase account must also be deleted.
        metabase_id = self.metabase_id
        metabase_user = MetabaseUser.objects.filter(id=metabase_id)
        metabase_user.delete()
        return super().delete()

    def __str__(self):
        return self.username
