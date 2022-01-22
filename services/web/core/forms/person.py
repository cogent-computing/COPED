from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper
from ..models import PersonOrganisation, Organisation, Person, ExternalLink


class PersonOrganisationForm(forms.ModelForm):
    class Meta:
        model = PersonOrganisation
        fields = ["organisation", "role"]
        widgets = {
            "organisation": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2Widget(
                    model=Organisation,
                    search_fields=["name__icontains"],
                ),
                reverse_lazy("organisation-create"),
            )
        }


class PersonForm(forms.ModelForm):
    class Meta:
        model = Person
        fields = [
            "first_name",
            "other_name",
            "last_name",
            "email",
            "orcid_id",
            "external_links",
        ]
        widgets = {
            "external_links": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2MultipleWidget(
                    model=ExternalLink,
                    search_fields=["link__icontains", "description__icontains"],
                ),
                reverse_lazy("link-create"),
            ),
        }
