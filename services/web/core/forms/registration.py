from django_registration.forms import RegistrationForm
from captcha.fields import ReCaptchaField

from ..models import User


class CustomUserForm(RegistrationForm):
    captcha = ReCaptchaField()

    class Meta(RegistrationForm.Meta):
        model = User
