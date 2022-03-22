from getpass import getpass
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model


class Command(BaseCommand):
    """
    Create a superuser with a required email field
    Example:
        manage.py createsuperuser_for_coped --user=admin --email=admin@example.com
    """

    def add_arguments(self, parser):
        parser.add_argument("--username", required=True)
        parser.add_argument("--email", required=True)

    def handle(self, *args, **options):

        User = get_user_model()

        username = options["username"]
        email = options["email"]
        password = getpass()

        User.objects.create_superuser(username=username, password=password, email=email)

        self.stdout.write(f'Superuser "{username}" was created')
