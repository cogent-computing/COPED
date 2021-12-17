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
        selenium_web_port = os.environ.get("SELENIUM_WEB_PORT", "4444")
        cls.selenium = webdriver.Remote(
            command_executor=f"http://coped_selenium:{selenium_web_port}/wd/hub",
            desired_capabilities=DesiredCapabilities.FIREFOX,
        )
        cls.selenium.implicitly_wait(5)

    @classmethod
    def tearDownClass(cls):
        cls.selenium.quit()
        super().tearDownClass()


class AdminTest(BaseTestCase):
    fixtures = ["users"]

    def test_login(self):
        """
        As a superuser with valid credentials, I should gain
        access to the Django admin.
        """
        # self.selenium.get(self.live_server_url)
        admin_path = reverse("admin:index")
        self.selenium.get(self.live_server_url + admin_path)
        username_input = self.selenium.find_element_by_name("username")
        username_input.send_keys("george")
        password_input = self.selenium.find_element_by_name("password")
        password_input.send_keys("password1234")
        self.selenium.find_element_by_xpath('//input[@value="Log in"]').click()

        path = urlparse(self.selenium.current_url).path
        self.assertEqual(admin_path, path)

        body_text = self.selenium.find_element_by_tag_name("body").text
        self.assertIn("WELCOME, GEORGE.", body_text)
