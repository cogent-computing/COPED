from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from ..models import Keyword


class KeywordCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Keyword
    template_name = "keyword_form.html"
    fields = ["text"]
    success_message = "Keyword(s) created."
