from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper
from ..models import Organisation


class AddressWidget(s2forms.ModelSelect2MultipleWidget):
    search_fields = [
        "line1__icontains",
        "line2__icontains",
        "line3__icontains",
        "line4__icontains",
        "line5__icontains",
        "city__icontains",
        "county__icontains",
        "region__icontains",
        "postcode__icontains",
        "country__icontains",
    ]


class LinksWidget(s2forms.ModelSelect2MultipleWidget):
    search_fields = ["link__icontains", "description__icontains"]


class OrganisationForm(forms.ModelForm):
    class Meta:
        model = Organisation
        fields = ["name", "about", "addresses", "external_links"]

        widgets = {
            "addresses": AddAnotherWidgetWrapper(
                AddressWidget, reverse_lazy("address-create")
            ),
            "external_links": AddAnotherWidgetWrapper(
                LinksWidget, reverse_lazy("link-create")
            ),
        }
