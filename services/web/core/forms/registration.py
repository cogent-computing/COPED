from django_registration.forms import RegistrationForm
from hcaptcha.fields import hCaptchaField

from ..models import User


class CustomUserForm(RegistrationForm):
    captcha = hCaptchaField()

    class Meta(RegistrationForm.Meta):
        model = User
        fields = ["username", "email", "first_name", "last_name"]
