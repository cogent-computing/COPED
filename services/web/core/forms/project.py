from unittest import mock
from django import forms
from django_select2 import forms as s2forms

from ..models import Project


class SubjectWidget(s2forms.ModelSelect2MultipleWidget):
    search_fields = [
        "label__icontains",
    ]


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
            "subjects": SubjectWidget,
        }
