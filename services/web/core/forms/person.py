from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper
from ..models import PersonOrganisation, Organisation, Person, ExternalLink


class PersonOrganisationForm(forms.ModelForm):
    class Meta:
        model = PersonOrganisation
        fields = ["organisation", "role"]
        help_texts = {
            "role": "How is the person associated with this organisation?",
        }
        widgets = {
            "organisation": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2Widget(
                    model=Organisation,
                    search_fields=["name__icontains"],
                    attrs={
                        "data-placeholder": "Search for an existing organisation here, or add one with the '+' below"
                    },
                ),
                reverse_lazy("organisation-create"),
            )
        }


class PersonForm(forms.ModelForm):
    class Meta:
        model = Person
        fields = [
            "is_locked",
            "first_name",
            "other_name",
            "last_name",
            "email",
            "orcid_id",
            "linkedin_url",
            "external_links",
        ]
        labels = {
            "external_links": "External URL links",
            "orcid_id": "ORCiD",
            "other_name": "Other name(s)",
            "email": "Email address",
        }
        help_texts = {
            "email": "Please only use public (e.g. work) email addresses.",
            "orcid_id": "Find out more about the Open Researcher and Contributor ID (ORCiD) at <a target='_blank' href='https://info.orcid.org/what-is-orcid/'>https://info.orcid.org</a>.",
            "linkedin_url": "Your LinkedIn public profile is usually at a URL beginning <a class='link'>https://www.linkedin.com/in/</a>.",
        }
        widgets = {
            "external_links": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2MultipleWidget(
                    model=ExternalLink,
                    search_fields=["link__icontains", "description__icontains"],
                    attrs={
                        "data-placeholder": "Search for an existing URL here, or add one with the '+' below"
                    },
                ),
                reverse_lazy("link-create"),
            ),
        }
