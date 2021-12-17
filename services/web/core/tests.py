import os
import socket
from urllib.parse import urlparse

from django.contrib.staticfiles.testing import StaticLiveServerTestCase
from django.test import override_settings, tag
from django.urls import reverse

from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities


@tag("selenium")
@override_settings(ALLOWED_HOSTS=["*"])
class BaseTestCase(StaticLiveServerTestCase):
    """
    Provides base test class which connects to the Docker
    container running selenium.
    """

    host = "0.0.0.0"

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.host = socket.gethostbyname(socket.gethostname())
        selenium_host = os.environ.get("SELENIUM_HOST", "coped_selenium")
        selenium_port = os.environ.get("SELENIUM_PORT", "4444")
        cls.selenium = webdriver.Remote(
            command_executor=f"http://{selenium_host}:{selenium_port}/wd/hub",
            desired_capabilities=DesiredCapabilities.FIREFOX,
        )
        cls.selenium.implicitly_wait(5)

    @classmethod
    def tearDownClass(cls):
        cls.selenium.quit()
        super().tearDownClass()


class AdminLoginTest(BaseTestCase):
    fixtures = ["users"]
    admin_login_path = reverse("admin:login")

    def fill_and_submit_admin_login_form(self, username, password):
        self.selenium.get(self.live_server_url + self.admin_login_path)
        username_input = self.selenium.find_element_by_name("username")
        username_input.send_keys(username)
        password_input = self.selenium.find_element_by_name("password")
        password_input.send_keys(password)
        self.selenium.find_element_by_xpath('//input[@value="Log in"]').click()

    def test_admin_login(self):
        """
        A superuser with valid credentials should gain access to the Django admin.
        """
        self.fill_and_submit_admin_login_form("george", "password1234")
        path = urlparse(self.selenium.current_url).path
        admin_path = reverse("admin:index")
        self.assertEqual(
            admin_path,
            path,
            "Administrators should be redirected to the admin landing page.",
        )

        body_text = self.selenium.find_element_by_tag_name("body").text
        self.assertIn(
            "WELCOME, GEORGE.",
            body_text,
            "Administrators should see a welcome on the admin landing page.",
        )

    def test_admin_login_without_admin_permission(self):
        """
        A registered regular user should not gain access to the Django admin.
        """
        self.fill_and_submit_admin_login_form("cosmo", "password1234")
        path = urlparse(self.selenium.current_url).path
        self.assertEqual(
            self.admin_login_path,
            path,
            "Non administrators should be held at the login page.",
        )

        error_text = self.selenium.find_element_by_class_name("errornote").text
        self.assertIn(
            "Please enter the correct username and password for a staff account.",
            error_text,
            "Non administrators should see a login error message.",
        )


class SiteLoginTest(BaseTestCase):
    fixtures = ["users"]
    site_login_path = reverse("login")

    def fill_and_submit_login_form(self, username, password):
        self.selenium.get(self.live_server_url + self.site_login_path)
        username_input = self.selenium.find_element_by_id("id_username")
        username_input.send_keys(username)
        password_input = self.selenium.find_element_by_id("id_password")
        password_input.send_keys(password)
        self.selenium.find_element_by_xpath(
            '//button[@type="submit"][text()="Log in"]'
        ).click()

    def test_site_login(self):
        """
        A user with valid credentials can log in and will be redirected to the main page.
        """
        self.fill_and_submit_login_form("cosmo", "password1234")

        path = urlparse(self.selenium.current_url).path
        main_page_path = reverse("index")
        self.assertEqual(main_page_path, path, "URL path should be redirected to home")

        logged_in_email = self.selenium.find_element_by_id("dropdownMenuButton2").text
        self.assertIn(
            "pennypacker@vandelayindustries.com",
            logged_in_email,
            "Logged in email should be shown in dropdown",
        )

    def test_site_login_fail(self):
        """
        A user with invalid credentials cannot log in and sees an error message.
        """
        self.fill_and_submit_login_form("cosmo", "fakepassword")

        path = urlparse(self.selenium.current_url).path
        self.assertEqual(
            self.site_login_path,
            path,
            "URL path should remain at site login",
        )

        # Ensure an error message is presented.
        alerts = self.selenium.find_elements_by_class_name("alert")
        alert_texts = [a.text.strip() for a in alerts]
        error_text = "Please enter a correct username and password."
        self.assertTrue(
            any([error_text in a for a in alert_texts]),
            "Login error message should be shown",
        )
