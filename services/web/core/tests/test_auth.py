"""
Test that Metabase user records, sessions, and cookies are created/destroyed when required.
"""

import json
from django.test import TestCase
from unittest.mock import patch
from unittest.mock import Mock

from django.urls import reverse
from django.core import mail
from django.http import JsonResponse
from django.db.models.fields import CharField
from django.contrib.auth import get_user_model

User = get_user_model()

# Set up some user data for testing
regular_user = {
    "email": "user@example.com",
    "username": "testuser",
    "password": "Password123!",
    "is_active": True,
}
admin_user = {
    "email": "admin@example.com",
    "password": "Password123!",
    "username": "adminuser",
    "is_active": True,
    "is_staff": True,
    "is_superuser": True,
}


# @patch("core.forms.registration.ReCaptchaField", lambda: CharField(required=False))
class SignupAndLoginFlow(TestCase):
    """Tests to ensure registration and login are working."""

    @patch("core.forms.registration.ReCaptchaField.validate")
    @patch("core.signals.requests.post")
    def test_registration(self, mock_post, mock_recaptcha):
        """A regular user should be able to register with the site."""

        # Set up mocks to avoid hitting external dependencies
        mock_response = Mock()
        mock_response.json.return_value = {"id": "42"}
        mock_post.return_value = mock_response
        mock_recaptcha.return_value = True

        # Submit the registration form
        response = self.client.post(
            reverse("django_registration_register"),
            data={
                "username": regular_user["username"],
                "email": regular_user["email"],
                "password1": regular_user["password"],
                "password2": regular_user["password"],
            },
        )

        # Check expectations

        self.assertEqual(
            User.objects.all().count(), 1, "User was added to the database."
        )
        self.assertRedirects(
            response,
            expected_url=reverse("django_registration_complete"),
            status_code=302,
            target_status_code=200,
        )
        self.assertEqual(len(mail.outbox), 1, "A validation email was sent.")
