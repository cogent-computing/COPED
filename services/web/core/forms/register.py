from django.forms import ModelForm, EmailInput, PasswordInput
from django import forms
from ..models import User


class RegisterForm(ModelForm):
    first_name = forms.CharField(max_length=100, label="First Name")
    last_name = forms.CharField(max_length=100, label="Last Name")
    email = forms.CharField(widget=EmailInput)
    password = forms.CharField(widget=PasswordInput)

    class Meta:
        model = User
        fields = ["email", "password", "first_name", "last_name"]
