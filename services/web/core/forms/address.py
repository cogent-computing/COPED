from django import forms
from django.urls import reverse_lazy
from django.core.exceptions import ValidationError
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper
from ..models import Address


class GeoWidget(s2forms.ModelSelect2Widget):
    search_fields = ["lat__icontains", "lon__icontains"]

    def label_from_instance(self, obj):
        return f"{obj.lat}, {obj.lon}"


class AddressForm(forms.ModelForm):
    class Meta:
        model = Address
        fields = [
            "line1",
            "line2",
            "line3",
            "line4",
            "line5",
            "city",
            "county",
            "region",
            "postcode",
            "country",
            "geo",
        ]

        labels = {
            "line1": "Line 1",
            "line2": "Line 2",
            "line3": "Line 3",
            "line4": "Line 4",
            "line5": "Line 5",
            "geo": "Longitude & Latitude",
        }
        help_texts = {
            "geo": "Please add a longitude and latitude if you wish the location to appear on map searches.<br>The following link can help: <a target='_blank' href='https://www.latlong.net/convert-address-to-lat-long.html'>https://www.latlong.net/convert-address-to-lat-long.html</a>"
        }
        widgets = {
            "geo": AddAnotherWidgetWrapper(GeoWidget, reverse_lazy("geo-create"))
        }

    def clean(self):
        super().clean()
        provided_values = 0
        for key, value in self.cleaned_data.items():
            if key != "geo" and value:
                provided_values += 1
        if provided_values <= 1:
            raise ValidationError("Please provide at least two address fields")
