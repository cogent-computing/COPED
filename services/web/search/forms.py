from datetime import datetime
from django import forms
from haystack.forms import SearchForm
from core.models.project import Project


class ProjectSearchForm(SearchForm):
    CHOICES = (
        (None, "All"),
        ("Active", "Active"),
        ("Closed", "Closed"),
    )
    YEAR_CHOICES = (
        (2020, 2020),
        (2021, 2021),
        (2022, 2022),
        (2023, 2023),
    )
    status = forms.ChoiceField(
        choices=CHOICES,
        required=False,
        help_text="Is the project active?",
    )
    start = forms.DateField(
        required=False,
        widget=forms.widgets.RadioSelect(choices=YEAR_CHOICES),
        help_text="Starting year",
    )

    def search(self):

        sqs = super().search()

        if not self.is_valid():
            return self.no_query_found()

        if self.cleaned_data["status"]:
            sqs = sqs.filter(status=self.cleaned_data["status"])

        if self.cleaned_data["start"]:
            sqs = sqs.filter(start__gte=self.cleaned_data["start"])

        return sqs
