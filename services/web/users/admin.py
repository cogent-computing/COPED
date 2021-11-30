from django.contrib import admin
from .models import User
from django.contrib.auth.admin import UserAdmin
from django.forms import Textarea


class UserAdminConfig(UserAdmin):
    model = User
    search_fields = (
        "email",
        "first_name",
    )
    list_filter = ("email", "first_name", "is_active", "is_staff")
    ordering = ("-date_joined",)
    list_display = ("email", "first_name", "is_active", "is_staff")
    fieldsets = (
        (None, {"fields": ("email", "first_name")}),
        ("Permissions", {"fields": ("is_staff", "is_active")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "first_name",
                    "last_name",
                    "password1",
                    "u_id",
                    "password2",
                    "is_active",
                    "is_staff",
                ),
            },
        ),
    )


admin.site.register(User, UserAdminConfig)
