import requests
from getpass import getpass
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model

METABASE_API_URL = "http://metabase:3000/api"


class Command(BaseCommand):
    """
    Create a superuser with a required email field
    Example:
        manage.py createsuperuser_for_coped --user=admin --email=admin@example.com
    """

    def add_arguments(self, parser):
        parser.add_argument("--username", required=True)
        parser.add_argument("--email", required=True)
        parser.add_argument("--first-name", required=True)
        parser.add_argument("--last-name", required=True)

    def handle(self, *args, **options):

        User = get_user_model()
        superusers = User.objects.filter(is_superuser=True)
        if superusers.exists():
            self.stderr.write("There is already a superuser in the database. Aborting")
            return None

        try:
            r = requests.get(f"{METABASE_API_URL}/session/properties")
            r.raise_for_status()
        except requests.exceptions.HTTPError as e:
            self.stderr.write("Error requesting Metabase token")
            self.stderr.write(e)
            return None

        setup_token = r.json().get("setup-token")
        if not setup_token:
            self.stderr.write(
                "No Metabase setup token available. Has Metabase already been configured?"
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

        User.objects.create_superuser(**new_user)
        self.stdout.write(f"Superuser '{username}' created in CoPED database")

        # auth = {"X-Metabase-Session": setup_token}
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
            self.stderr.write(e)
            return None

        self.stdout.write(f"Superuser '{username}' created in Metabase database")
