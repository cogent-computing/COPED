"""
Application signal handlers.
"""

import os
import requests
import logging
from django.utils import timezone
from django.conf import settings
from django.contrib.auth import get_user_model
from .models import MetabaseSession

METABASE_API_URL = "http://metabase:3000/api"
User = get_user_model()


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
    logging.debug("Superuser session token for Metabase: %s", token)
    return token


def add_user_to_metabase(sender, **kwargs):
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
    password = body.get("password") or body.get(
        "password1"
    )  # field name differs for registration vs login

    user_to_save_in_metabase = {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "password": password,
    }

    logging.debug("User to save in Metabase: %s", user_to_save_in_metabase)

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

    if coped_user.is_superuser:
        # Make the user a superuser in Metabase too.
        # TODO: check response code is OK
        r = requests.put(
            f"{METABASE_API_URL}/user/{metabase_id}",
            json={"is_superuser": True},
            headers=auth,
        )
        if settings.DEBUG:
            logging.debug(r.text)


def detect_password_change(sender, instance, **kwargs):
    """
    Check if the user changed their password and update it in Metabase if so.
    """

    if instance._password is None:
        logging.debug(
            "Looking for a password that has changed but can't find one. Aborting Metabase update."
        )
        return

    try:
        user = User.objects.get(id=instance.id)
    except User.DoesNotExist:
        logging.error(
            "A password was changed but it's not clear who changed it! Aborting Metabase update."
        )
        return

    if not user.metabase_id:
        logging.warning(
            "The user changing the password doesn't have a Metabase user entry! They'll receive a new one on next login."
        )
        return

    logging.debug("Changing Metabase password for user: %s", user)
    new_password = {"password": instance._password}
    token = get_metabase_superuser_access_token()
    auth = {"X-Metabase-Session": token}
    try:
        r = requests.put(
            f"{METABASE_API_URL}/user/{user.metabase_id}/password",
            json=new_password,
            headers=auth,
        )
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        logging.error("Failed to update Metabase password for user %s. Aborting.", user)
        logging.error(r.text)
        return
    else:
        logging.debug("Changed Metabase password for user: %s", user)
        logging.debug(r.text)


def user_logout_handler(sender, request, user, **kwargs):
    """
    Remove any Metabase session record corresponding to the user logging out.
    """
    logging.debug(
        "Logout by %s at %s. Attempting to remove Metabase token.", user, timezone.now()
    )
    token = request.COOKIES.get("metabase.SESSION")
    if token is not None:
        auth = {"X-Metabase-Session": token}
        r = requests.delete(
            f"{METABASE_API_URL}/session",
            json={"metabase-session-id": token},
            headers=auth,
        )
        logging.debug("Response from Metabase API: %s", r.text)
    session = user.metabasesession_set.filter(token=token)
    if session.exists():
        session.delete()


def user_login_handler(sender, request, user, **kwargs):
    """
    Get or create a valid Metabase auth token for this user.
    """
    logging.debug(
        "Login by %s at %s. Attempting to get Metabase token.", user, timezone.now()
    )

    # First, catch any rogue instances without a metabase_id
    if not user.metabase_id:
        logging.warning(
            "WARNING: the user %s does not have a Metabase ID! Adding them now", user
        )
        add_user_to_metabase(None, user=user, request=request)

    def get_user_token():
        metabase_token_url = f"{METABASE_API_URL}/session"
        request_data = {
            "username": user.email,
            "password": request.POST["password"],
        }

        logging.debug("Requesting token : %s : %s", metabase_token_url, request_data)

        # TODO: check response status code is OK
        r = requests.post(metabase_token_url, json=request_data)
        token = r.json().get("id")

        logging.debug("Response from Metabase: %s : %s", r.text, token)

        return token

    session_info = MetabaseSession.objects.create(user=user, token=get_user_token())
    logging.debug("User %s logged in.", user)
    logging.debug("Now using MetabaseSession instance %s", session_info)
