from rules.contrib.views import PermissionRequiredMixin
from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from ..models import ExternalLink


class LinkCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = ExternalLink
    permission_required = "core.add_link"
    template_name = "link_form.html"
    fields = ["description", "link"]
    success_message = "External link created."
