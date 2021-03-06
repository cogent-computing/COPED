from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper

from core.models.external_link import ExternalLink

from ..models import (
    Project,
    ProjectFund,
    Subject,
    Organisation,
    ProjectOrganisation,
    ProjectPerson,
    Person,
    Keyword,
)


class ProjectOrganisationForm(forms.ModelForm):
    def get_context(self):
        context = super().get_context()
        context["form_name"] = "project_organisation_form"
        return context

    class Meta:
        model = ProjectOrganisation
        fields = ["organisation", "role"]
        help_texts = {
            "role": "How is this organisation involved in the project?",
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


class ProjectFundForm(forms.ModelForm):
    class Meta:
        model = ProjectFund
        fields = ["organisation", "amount", "start_date", "end_date"]
        labels = {"organisation": "Funding organisation"}
        help_texts = {"amount": "Value of the funding (GBP £)"}
        widgets = {
            "start_date": forms.widgets.DateInput(attrs={"type": "date"}),
            "end_date": forms.widgets.DateInput(attrs={"type": "date"}),
            "organisation": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2Widget(
                    model=Organisation,
                    search_fields=["name__icontains"],
                    attrs={
                        "data-placeholder": "Search for an existing organisation here, or add one with the '+' below"
                    },
                ),
                reverse_lazy("organisation-create"),
            ),
        }


class ProjectPersonForm(forms.ModelForm):
    class Meta:
        model = ProjectPerson
        fields = ["person", "role"]
        labels = {}
        help_texts = {
            "role": "How is this person involved in the project?",
        }
        widgets = {
            "person": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2Widget(
                    model=Person,
                    search_fields=[
                        "first_name__icontains",
                        "other_name__icontains",
                        "last_name__icontains",
                    ],
                    attrs={
                        "data-placeholder": "Search for an existing person here, or add one with the '+' below"
                    },
                ),
                reverse_lazy("person-create"),
            )
        }


class ProjectFormWithInlines(forms.ModelForm):
    class Meta:
        model = Project
        fields = [
            "is_locked",
            "title",
            "status",
            "start",
            "end",
            "description",
            "extra_text",
            "subjects",
            "keywords",
            "external_links",
        ]
        widgets = {
            "start": forms.widgets.DateInput(attrs={"type": "date"}),
            "end": forms.widgets.DateInput(attrs={"type": "date"}),
            "subjects": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2MultipleWidget(
                    model=Subject, search_fields=["label__icontains"]
                ),
                reverse_lazy("subject-create"),
            ),
            "external_links": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2MultipleWidget(
                    model=ExternalLink,
                    search_fields=["description__icontains", "link__icontains"],
                ),
                reverse_lazy("link-create"),
            ),
            "keywords": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2MultipleWidget(
                    model=Keyword,
                    search_fields=["text__icontains"],
                ),
                reverse_lazy("keyword-create"),
            ),
        }
        help_texts = {
            "start": "Project start date (optional). Defaults to earliest funding start date.",
            "end": "Project end date (optional). Defaults to latest funding end date.",
            "description": "The project description will be used for searches and for evaluating similarity to other projects.",
            "extra_text": "The project extra text can expand on the main description if you wish to add further details.",
        }
        labels = {
            "start": "Start date",
            "end": "End date",
        }
