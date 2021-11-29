from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    class Meta:
        db_table = "auth_user"


# from django.db import models
# from django.contrib.auth.models import AbstractBaseUser
# from django.contrib.auth.models import PermissionsMixin
# from django.contrib.auth.base_user import BaseUserManager
# from django.contrib.postgres.fields import ArrayField
# from django.utils.translation import gettext_lazy as _
# from django.utils import timezone
# import uuid

# # from coped_controller.coped_controller_local import Coped_Controller

# # c_con = Coped_Controller()


# class CustomUserManager(BaseUserManager):
#     """
#     Custom user model manager where email is the unique identifiers
#     for authentication instead of usernames.
#     """

#     def create_user(self, email, password, first_name, last_name, **extra_fields):
#         """
#         Create and save a User with the given email and password.
#         """
#         if not email:
#             raise ValueError(_("The Email must be set"))
#         email = self.normalize_email(email)
#         user = self.model(
#             email=email, first_name=first_name, last_name=last_name, **extra_fields
#         )
#         user.set_password(password)
#         # u_id = c_con.create_user(user)
#         # user.u_id = u_id
#         # permission to own page
#         # user.res_perm_list = [user.u_id]
#         user.save()
#         return user

#     def create_superuser(self, email, password, first_name, last_name, **extra_fields):
#         """
#         Create and save a SuperUser with the given email and password.
#         """
#         extra_fields.setdefault("is_staff", True)
#         extra_fields.setdefault("is_superuser", True)
#         extra_fields.setdefault("is_active", True)

#         if extra_fields.get("is_staff") is not True:
#             raise ValueError(_("Superuser must have is_staff=True."))
#         if extra_fields.get("is_superuser") is not True:
#             raise ValueError(_("Superuser must have is_superuser=True."))
#         return self.create_user(email, password, first_name, last_name, **extra_fields)


# class User(AbstractBaseUser, PermissionsMixin):
#     email = models.EmailField(_("email address"), unique=True)
#     first_name = models.CharField(max_length=250)
#     last_name = models.CharField(max_length=250)
#     is_staff = models.BooleanField(default=False)
#     is_active = models.BooleanField(default=True)
#     coped_id = models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True)
#     date_joined = models.DateTimeField(default=timezone.now)
#     # res_perm_list = ArrayField(
#     #     models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True),
#     #     size=100,
#     #     default=list,
#     #     null=True,
#     # )
#     # subscriptions = ArrayField(
#     #     models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True),
#     #     size=100,
#     #     default=list,
#     #     null=True,
#     # )
#     USERNAME_FIELD = "email"
#     REQUIRED_FIELDS = ["first_name", "last_name"]

#     objects = CustomUserManager()

#     def __str__(self):
#         return self.email


# # class PasswChange(models.Model):
# #     """
# #     Model to handle password change
# #     """

# #     email = models.EmailField(_("email address"))
# #     sender = models.UUIDField(primary_key=False, default=uuid.uuid4, editable=True)
# #     date_requested = models.DateTimeField(default=timezone.now)
# #     secret = models.CharField(max_length=50)
# #     used = models.BooleanField(default=False)
# #     # Metadata
# #     class Meta:
# #         ordering = ["email", "sender", "-date_requested"]

# #     def __str__(self):
# #         """String for representing the MyModelName object (in Admin site etc.)."""
# #         return (
# #             "Passw_Change:"
# #             + str(self.email)
# #             + " on:"
# #             + str(self.date_requested)
# #             + "secret: "
# #             + str(self.secret)
# #         )
