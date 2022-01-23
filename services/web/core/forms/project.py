from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper

from ..models import (
    Project,
    ProjectFund,
    Subject,
    ProjectSubject,
    Organisation,
    ProjectOrganisation,
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
            "role": "How is the project linked to this organisation?",
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
        help_texts = {}
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


class ProjectFormWithInlines(forms.ModelForm):
    class Meta:
        model = Project
        fields = ["title", "description", "status"]


class ProjectForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields["funds"].queryset = self.instance.funds
        self.fields["subjects"].queryset = self.instance.subjects
        self.fields["external_links"].queryset = self.instance.external_links
        self.fields["persons"].queryset = self.instance.persons
        self.fields["organisations"].queryset = self.instance.organisations

    class Meta:
        model = Project
        fields = [
            "title",
            "description",
            "status",
            "funds",
            "subjects",
            "external_links",
            "persons",
            "organisations",
        ]
        widgets = {
            "subjects": AddAnotherWidgetWrapper(
                s2forms.Select2MultipleWidget,
                reverse_lazy("subject-create"),
            ),
            "external_links": AddAnotherWidgetWrapper(
                s2forms.Select2MultipleWidget,
                reverse_lazy("link-create"),
            ),
            "persons": AddAnotherWidgetWrapper(
                s2forms.Select2MultipleWidget,
                reverse_lazy("link-create"),
            ),
            "organisations": AddAnotherWidgetWrapper(
                s2forms.Select2MultipleWidget,
                reverse_lazy("link-create"),
            ),
            "funds": AddAnotherWidgetWrapper(
                s2forms.Select2MultipleWidget,
                reverse_lazy("link-create"),
            ),
        }


class ProjectForm2(forms.ModelForm):
    class Meta:
        model = Project
        fields = ("title", "status")


class ProjectSubjectsForm2(forms.ModelForm):
    class Meta:
        model = ProjectSubject
        fields = (
            "id",
            "project",
            "score",
        )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if "fields" in dir(self):
            self.base_fields["subject"] = forms.CharField()
            self.fields["subject"] = forms.CharField()
            self.fields["subject"].initial = "this is hard work"
            print("fields:", self.fields["subject"].initial)
            self.fields["subject"].initial = self.instance.subject
            print("self.fields['subject']:", self.fields["subject"].initial)

        print("kwargs yourself dir: ", dir(kwargs))
        print("kwargs yourself dict: ", dict(kwargs))
        # self.fields["subject"] = "hell, initial description"


ProjectSubjectsFormSet2 = forms.models.inlineformset_factory(
    Project,
    ProjectSubject,
    form=ProjectSubjectsForm2,
    # fields=["id", "project", "subject", "score"],
    # exclude=[],
    can_delete=True,
    max_num=21,
    extra=0,
)
