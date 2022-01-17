from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import (
    AddAnotherWidgetWrapper,
)

from ..models import Project


class ProjectForm(forms.ModelForm):
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
