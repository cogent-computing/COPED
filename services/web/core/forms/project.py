from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import (
    AddAnotherWidgetWrapper,
)

from ..models import Project, Subject, ProjectSubject


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


ProjectSubjectsFormSet2 = forms.models.inlineformset_factory(
    Project,
    ProjectSubject,
    fields=["id", "project", "subject", "score"],
    exclude=[],
    can_delete=True,
    max_num=21,
    extra=1,
)
