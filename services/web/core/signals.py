"""
Application signal handlers.
"""

import os
import requests
from django.utils import timezone
from django.conf import settings
from django.contrib.auth import get_user_model
from .models import MetabaseSession

METABASE_API_URL = "http://metabase:3000/api"


def get_metabase_superuser_access_token():
    """
    Each request to add a new user to Metabase must be authenticated using a token.

    TODO: save this in the DB during its validity period to avoid excessive token requests.
    TODO: superuser credentials should be set up at service build time or through an entrypoint script.
    """
    metabase_superuser_email = os.environ.get("METABASE_SUPERUSER_EMAIL")
    metabase_superuser_password = os.environ.get("METABASE_SUPERUSER_PASSWORD")
    metabase_token_url = f"{METABASE_API_URL}/session"
    request_data = {
        "username": metabase_superuser_email,
        "password": metabase_superuser_password,
    }
    r = requests.post(metabase_token_url, json=request_data)
    token = r.json().get("id")
    if settings.DEBUG:
        print("Superuser session token for Metabase", token)
    return token


def user_registration_handler(sender, **kwargs):
    """
    Add a user profile into Metabase when a user registers a CoPED account.

    This allows user access to the functionality of Metabase in a more seamless way.
    Stores the Metabase user ID in the field User.metabase_id for reference later.
    """

    coped_user = kwargs["user"]

    first_name = coped_user.first_name if coped_user.first_name else coped_user.username
    last_name = coped_user.last_name if coped_user.last_name else coped_user.username
    email = coped_user.email

    request = kwargs["request"]
    body = request.POST
    password = body.get("password1")

    user_to_save_in_metabase = {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "password": password,
    }

    if settings.DEBUG:
        print("User to save in Metabase", user_to_save_in_metabase)

    token = get_metabase_superuser_access_token()
    auth = {"X-Metabase-Session": token}

    # Add the user to Metabase.
    r = requests.post(
        f"{METABASE_API_URL}/user", json=user_to_save_in_metabase, headers=auth
    )
    result = r.json()

    # Record the Metabase user ID in the CoPED user record.
    metabase_id = result["id"]
    coped_user.metabase_id = metabase_id
    coped_user.save(update_fields=["metabase_id"])


def detect_password_change(sender, instance, **kwargs):
    """
    Check if the user changed their password and update it in Metabase if so.
    """

    if instance._password is None:
        return

    try:
        user = get_user_model().objects.get(id=instance.id)
    except get_user_model().DoesNotExist:
        return

    if not user.metabase_id:
        if settings.DEBUG:
            print(f"No metabase_id for user {user}. Cannot update password.")
        return

    if settings.DEBUG:
        print(f"Changing Metabase password for user: {user}")

    new_password = {"password": instance._password}
    token = get_metabase_superuser_access_token()
    auth = {"X-Metabase-Session": token}
    r = requests.put(
        f"{METABASE_API_URL}/user/{user.metabase_id}/password",
        json=new_password,
        headers=auth,
    )
    result = r.json()
    if settings.DEBUG:
        print("Response from Metabase API", result)


def user_logout_handler(sender, request, user, **kwargs):
    """
    Remove any Metabase session record corresponding to the user logging out.
    """
    if settings.DEBUG:
        print(
            f"Logout by {user} at {timezone.now()}. Attempting to remove any Metabase token."
        )
    token = request.COOKIES.get("metabase.SESSION")
    if token is not None:
        auth = {"X-Metabase-Session": token}
        r = requests.delete(
            f"{METABASE_API_URL}/session",
            json={"metabase-session-id": token},
            headers=auth,
        )
        if settings.DEBUG:
            print("Response from Metabase API", r)
    try:
        user.metabasesession.delete()
    except MetabaseSession.DoesNotExist:
        if settings.DEBUG:
            print("No metabase session stored for user", user)


def user_login_handler(sender, request, user, **kwargs):
    """
    Get or create a valid Metabase auth token for this user.
    """
    if settings.DEBUG:
        print(f"Login by {user} at {timezone.now()}. Attempting to get Metabase token.")

    # First, catch any rogue instances without a metabase_id
    if not user.metabase_id:
        if settings.DEBUG:
            print(f"WARNING: the user {user} does not have a Metabase ID.")
            print(f"They will need to log in to Metabase analytics manually.")
        return

    def get_user_token():
        metabase_token_url = f"{METABASE_API_URL}/session"
        request_data = {
            "username": user.email,
            "password": request.POST["password"],
        }

        if settings.DEBUG:
            print("Requesting token")
            print(metabase_token_url)
            print(request_data)

        r = requests.post(metabase_token_url, json=request_data)
        token = r.json().get("id")

        if settings.DEBUG:
            print("Response from Metabase")
            print(r)
            print(token)

        return token

    session_info, created = MetabaseSession.objects.get_or_create(
        user=user, expires__gte=timezone.now(), defaults={"token": get_user_token}
    )
    if settings.DEBUG:
        print(f"User {user} logged in.")
        print(f"Created new session record: {created}.")
        print(f"Now using MetabaseSession instance {session_info}")
