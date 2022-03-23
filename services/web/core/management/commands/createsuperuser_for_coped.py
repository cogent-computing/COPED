import requests
from getpass import getpass
from django.db.models import Q
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model

METABASE_API_URL = "http://metabase:3000/api"


class Command(BaseCommand):
    """
    Create a superuser with required data.
    User is created in the CoPED database and the Metabase database.
    Example:
        manage.py createsuperuser_for_coped --username admin \
        --email admin@example.com --first-name joe --last-name bloggs
    """

    def add_arguments(self, parser):
        parser.add_argument("--username", required=True)
        parser.add_argument("--email", required=True)
        parser.add_argument("--first-name", required=True)
        parser.add_argument("--last-name", required=True)

    def handle(self, *args, **options):

        User = get_user_model()
        superuser_exists = User.objects.filter(is_superuser=True).exists()
        if superuser_exists:
            self.stderr.write(
                "A superuser already exists. Please log in to CoPED/Metabase to add new ones."
            )
            return None

        username = options["username"]
        email = options["email"]
        first_name = options["first_name"]
        last_name = options["last_name"]
        password1 = getpass()
        password2 = getpass(prompt="Confirm password:")

        if password1 != password2:
            self.stderr.write("Passwords do not match. Aborting.")
            return None

        new_user = dict(
            username=username,
            password=password1,
            first_name=first_name,
            last_name=last_name,
            email=email,
        )

        if User.objects.filter(Q(username=username) | Q(email=email)).exists():
            self.stderr.write("Username or email already in use. Aborting")
            return None

        try:
            r = requests.get(f"{METABASE_API_URL}/session/properties")
            r.raise_for_status()
        except requests.exceptions.HTTPError as e:
            self.stderr.write("Error requesting Metabase token for initial setup.")
            self.stderr.write(r.text)
            return None

        setup_token = r.json().get("setup-token")
        if not setup_token:
            self.stderr.write(
                "No Metabase setup token received. Has Metabase already been configured?"
            )
            return None

        json_body = {
            "user": new_user,
            "prefs": {"site_name": "CoPED"},
            "token": setup_token,
        }
        try:
            r = requests.post(f"{METABASE_API_URL}/setup", json=json_body)
            r.raise_for_status()
        except requests.exceptions.HTTPError as e:
            self.stderr.write("Error creating Metabase superuser")
            self.stderr.write(r.text)
            return None

        self.stdout.write(f"Superuser '{username}' created in Metabase database")

        token = r.json().get("id")
        auth = {"X-Metabase-Session": token}

        try:
            r = requests.get(f"{METABASE_API_URL}/user/current", headers=auth)
            r.raise_for_status()
        except requests.exceptions.HTTPError as e:
            self.stderr.write(
                "Error getting user information to set 'metabase_id' for CoPED user. Aborting."
            )
            self.stderr.write(
                f"WARNING: There is now a Metabase superuser '{username}' with no corresponding CoPED superuser."
            )
            self.stderr.write(r.text)
            return None

        metabase_id = r.json().get("id")
        new_user.update({"metabase_id": metabase_id})
        User.objects.create_superuser(**new_user)

        self.stdout.write(f"Superuser '{username}' created in CoPED database")
