from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin
from extra_views import InlineFormSetFactory

from ..models import Address, GeoData
from ..forms import AddressForm


class GeoCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = GeoData
    template_name = "geo_form.html"
    fields = ["lat", "lon"]
    success_message = "Geo location created."


class AddressGeoInline(InlineFormSetFactory):
    model = GeoData
    fields = ["lat", "lon"]
    factory_kwargs = {"extra": 0}


class AddressDetailView(generic.DetailView):
    model = Address
    template_name = "address_detail.html"


class AddressCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Address
    form_class = AddressForm
    template_name = "address_form.html"
    success_message = "Address created."


class AddressUpdateView(generic.UpdateView):
    model = Address
    form_class = AddressForm
    template_name = "address_form.html"
