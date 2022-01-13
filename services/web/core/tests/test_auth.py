"""
Test authentication flows:
* Ensure registration, email activation, login, logout, and password change all function.
* Ensure corresponding Metabase user records are created/modified during these actions.
* Ensure the corresponding signal handlers run correctly.
* Ensure client cookies are set and deleted at the appropriate stages.
* Ensure the correct confirmation / validation emails are sent to users when required.
"""

from django.test import TestCase
from unittest.mock import patch
from unittest.mock import Mock

import re
from django.urls import reverse
from django.core import mail
from django.contrib.auth import get_user_model

User = get_user_model()

# Set up some data for testing
regular_user = {
    "email": "user@example.com",
    "username": "testuser",
    "password": "Password123!",
    "is_active": True,
    "metabase_id": 42,
    "metabase_auth_token": "000-000",
}
admin_user = {
    "email": "admin@example.com",
    "password": "Password123!",
    "username": "adminuser",
    "is_active": True,
    "is_staff": True,
    "is_superuser": True,
    "metabase_auth_token": "111-111",
}


class SignupAndLoginFlow(TestCase):
    """Tests to ensure registration and login are working."""

    @patch("core.forms.registration.ReCaptchaField.validate")
    @patch("core.signals.requests.post")
    def test_registration(self, mock_post, mock_recaptcha):
        """A regular user can register on the site and is added to Metabase when they do."""

        # Mock the POST calls to the Metabase API
        # TODO: check that the correct POST request is sent to the Metabase API to get an admin token
        # TODO: check that the correct POST request is sent to the Metabase API to add a user
        mock_response = Mock()
        mock_response.json.side_effect = [
            # First Metabase API call returns a superuser auth token.
            {"id": admin_user["metabase_auth_token"]},
            # Second Metabase API call returns the newly saved user and their MB id.
            {"id": regular_user["metabase_id"]},
        ]
        mock_post.return_value = mock_response

        # Mock the recaptcha field validation result so the form will submit.
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

        # Registration flow
        self.assertEqual(
            mock_post.call_count,
            2,
            "Metabase API should be called twice: 1. create superuser session, 2. add new user record",
        )
        self.assertEqual(
            User.objects.all().count(),
            1,
            "User should be added to the database.",
        )
        self.assertRedirects(
            response,
            expected_url=reverse("django_registration_complete"),
            status_code=302,
            target_status_code=200,
            msg_prefix="Successful registration form submission should be confirmed.",
        )

        # New user attributes
        self.assertFalse(
            User.objects.get(username=regular_user["username"]).is_active,
            "New user should not be active by default.",
        )
        self.assertEqual(
            User.objects.get(username=regular_user["username"]).metabase_id,
            regular_user["metabase_id"],
            "New user's metabase id should be set from the Metabase API response.",
        )

        # Activation email and link validity
        self.assertEqual(
            len(mail.outbox),
            1,
            "A validation email should be sent.",
        )
        activation_link_match = re.search(
            "(?P<url>https?://[^\s]+)", mail.outbox[0].body
        )
        self.assertIsNotNone(
            activation_link_match,
            "Email should contain an activation link",
        )
        activation_link = activation_link_match.group("url")
        response = self.client.get(activation_link, follow=True)
        self.assertEqual(
            response.status_code,
            200,
            "Activation link should work",
        )
        self.assertTemplateUsed(
            response,
            "django_registration/activation_complete.html",
            msg_prefix="Activation link should be valid on first use.",
        )
        self.assertTrue(
            User.objects.get(username=regular_user["username"]).is_active,
            "New user should now be active after using activation link.",
        )
        response = self.client.get(activation_link, follow=True)
        self.assertTemplateUsed(
            response,
            "django_registration/activation_failed.html",
            "Activation link should be invalid after user has followed it.",
        )

    @patch("core.signals.requests.post")
    def test_login(self, mock_post):
        """A registered and active user can log in to the site"""

        # Mock the POST call to the Metabase API. Return a session token for Metabase as the id value.
        mock_response = Mock()
        mock_response.json.return_value = {"id": regular_user["metabase_auth_token"]}
        mock_post.return_value = mock_response

        # Add the user to the DB
        User.objects.create_user(
            username=regular_user["username"],
            email=regular_user["email"],
            password=regular_user["password"],
            is_active=regular_user["is_active"],
            metabase_id=regular_user["metabase_id"],
        )
        self.assertEqual(User.objects.all().count(), 1)

        # Log in with incorrect password
        response = self.client.post(
            reverse("login"),
            data={"username": regular_user["username"], "password": "wrong_pass"},
        )
        self.assertContains(
            response,
            "Please enter a correct username and password.",
            msg_prefix="Login form error should display.",
        )

        # Log in with incorrect username
        response = self.client.post(
            reverse("login"),
            data={"username": "fake_user", "password": "password"},
        )
        self.assertContains(
            response,
            "Please enter a correct username and password.",
            msg_prefix="Login form error should display.",
        )

        # Log in with correct credentials: check cookies and redirection.
        response = self.client.post(
            reverse("login"),
            data={
                "username": regular_user["username"],
                "password": regular_user["password"],
            },
        )
        self.assertRedirects(response, reverse("index"), 302, 200)
        self.assertEqual(
            response.client.cookies["metabase.SESSION"].value,
            regular_user["metabase_auth_token"],
            "Client should receive correct Metabase session token value in cookie.",
        )
