"""
Application signal handlers.
"""

import requests
import os


def user_registration_handler(sender, **kwargs):
    """
    Add a user profile into Metabase when a user confirms and activates their CoPED account.

    This allows user access to the functionality of Metabase in a more seamless way.
    """
    print("A user was registered!")
    print("Sender", sender)
    print("kwargs", kwargs)
    request = kwargs.get("request")
    print("request", request)
    body = request.POST
    print("body", body)
    password = body.get("password1")
    print("password", password)
    metabase_superuser_email = os.environ.get("METABASE_SUPERUSER_EMAIL")
    metabase_superuser_password = os.environ.get("METABASE_SUPERUSER_PASSWORD")
    metabase_api_url = "http://metabase:3000/api"
    request_data = {
        "username": metabase_superuser_email,
        "password": metabase_superuser_password,
    }
    r = requests.post(f"{metabase_api_url}/session", json=request_data)
    token = r.json().get("id")
    print("Metabase admin session token", token)

    coped_user = kwargs["user"]
    user_to_save_in_metabase = {
        "first_name": coped_user.first_name
        if coped_user.first_name
        else coped_user.username,
        "last_name": coped_user.last_name
        if coped_user.last_name
        else coped_user.username,
        "email": coped_user.email,
        "password": password,
    }
    print("User to save", user_to_save_in_metabase)

    auth = {"X-Metabase-Session": token}
    r = requests.post(
        f"{metabase_api_url}/user", json=user_to_save_in_metabase, headers=auth
    )
    result = r.json()
    print("Response from Metabase API", result)
