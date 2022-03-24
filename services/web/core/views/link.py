from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from ..models import ExternalLink


class LinkCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = ExternalLink
    template_name = "link_form.html"
    fields = ["description", "link"]
    success_message = "External link created."


class ExternalLinkUpdateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.UpdateView,
):
    model = ExternalLink
    template_name = "external_link_form.html"
    fields = ["description", "link"]
    success_message = "External link updated."
