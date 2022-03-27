from rules.contrib.views import PermissionRequiredMixin
from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from ..models import Address, GeoData
from ..forms import AddressForm


class GeoCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = GeoData
    permission_required = "core.add_geo_data"
    template_name = "geo_form.html"
    fields = ["lat", "lon"]
    success_message = "Geo location created."


class AddressDetailView(generic.DetailView):
    model = Address
    template_name = "address_detail.html"


class AddressCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Address
    permission_required = "core.add_address"
    form_class = AddressForm
    template_name = "address_form.html"
    success_message = "Address created."


class AddressUpdateView(PermissionRequiredMixin, generic.UpdateView):
    model = Address
    permission_required = "core.change_address"
    form_class = AddressForm
    template_name = "address_form.html"
