from django.db import models
from django.contrib.auth.models import AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from django.contrib.postgres.fields import ArrayField

from .managers import CustomUserManager
import uuid

class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(_('email address'), unique=True)
    first_name = models.CharField(max_length=250)
    last_name = models.CharField(max_length=250)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    u_id = models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True)
    date_joined = models.DateTimeField(default=timezone.now)
    res_perm_list =  ArrayField(
            models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True),
            size=100, default=list, null=True
        )
    subscriptions =  ArrayField(
            models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True),
            size=100, default=list, null=True
        )
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name','last_name']

    objects = CustomUserManager()

    def __str__(self):
        return self.email


class PasswChange(models.Model):
    """
    Model to handle password change
    """
    email = models.EmailField(_('email address'))
    sender = models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True)
    date_requested = models.DateTimeField(default=timezone.now)
    secret = models.CharField(max_length=50)
    used = models.BooleanField(default=False)
    # Metadata
    class Meta:
        ordering = ['email', 'sender', '-date_requested']

    def __str__(self):
        """String for representing the MyModelName object (in Admin site etc.)."""
        return "Passw_Change:" + str(self.email) + " on:" + str(self.date_requested) + "secret: " + str(self.secret)

