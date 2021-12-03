"""Custom User model for CoPED.

See https://docs.djangoproject.com/en/3.2/topics/auth/customizing/ for details
and considerations when using a custom model. In particular, note the following.

> Instead of referring to User directly, you should reference the user model using
> django.contrib.auth.get_user_model(). This method will return the currently active
> user model – the custom user model if one is specified, or User otherwise.

> When you define a foreign key or many-to-many relations to the user model, you
> should specify the custom model using the AUTH_USER_MODEL setting.

There are various other requirements, on which see the link above.
"""

# class User(AbstractBaseUser):
#     class Meta:
#         # Set the custom user model to have the standard Django database table name
#         db_table = "auth_user"

from django.conf import settings
from django.db import models
from django.core.mail import send_mail
from django.contrib.auth.models import AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.postgres.fields import ArrayField
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from uuid import uuid4

# # from coped_controller.coped_controller_local import Coped_Controller

# # c_con = Coped_Controller()


class UserManager(BaseUserManager):
    """
    Custom user model manager where email is the unique identifiers
    for authentication instead of usernames.
    """

    def create_user(self, email, password, first_name, last_name, **extra_fields):
        """
        Create and save a User with the given email and password.
        """
        if not email:
            raise ValueError(_("The Email must be set"))
        email = self.normalize_email(email)
        user = self.model(
            email=email, first_name=first_name, last_name=last_name, **extra_fields
        )
        user.set_password(password)
        # u_id = c_con.create_user(user)
        # user.u_id = u_id
        # permission to own page
        # user.res_perm_list = [user.u_id]
        user.save()
        return user

    def create_superuser(self, email, password, first_name, last_name, **extra_fields):
        """
        Create and save a SuperUser with the given email and password.
        """
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError(_("Superuser must have is_staff=True."))
        if extra_fields.get("is_superuser") is not True:
            raise ValueError(_("Superuser must have is_superuser=True."))
        return self.create_user(email, password, first_name, last_name, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    username = models.CharField(_("username"), max_length=256, unique=True)
    email = models.EmailField(_("email address"), unique=True)
    first_name = models.CharField(max_length=250)
    last_name = models.CharField(max_length=250)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    date_joined = models.DateTimeField(default=timezone.now)
    # res_perm_list = ArrayField(
    #     models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True),
    #     size=100,
    #     default=list,
    #     null=True,
    # )
    # subscriptions = ArrayField(
    #     models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True),
    #     size=100,
    #     default=list,
    #     null=True,
    # )
    USERNAME_FIELD = "username"
    REQUIRED_FIELDS = ["first_name", "last_name"]

    objects = UserManager()

    class Meta:
        # Set the custom user model to have the standard Django database table name
        db_table = "auth_user"

    def email_user(self, subject, message, from_email=None, **kwargs):
        if from_email is None:
            from_email = settings.DEFAULT_FROM_EMAIL
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

    def __str__(self):
        return self.email
