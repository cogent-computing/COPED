from datetime import datetime
from django import forms
from haystack.forms import SearchForm
from core.models.project import Project


class ProjectSearchForm(SearchForm):
    q = forms.CharField(
        required=False,
        label="Search",
        widget=forms.TextInput(
            attrs={"type": "search", "onKeyUp": "showResults(this.value)"}
        ),
    )

    CHOICES = (
        (None, "All"),
        ("Active", "Active"),
        ("Closed", "Closed"),
    )
    status = forms.ChoiceField(
        choices=CHOICES,
        required=False,
        help_text="Is the project active?",
    )
    start = forms.DateField(
        required=False,
        widget=forms.widgets.DateInput(attrs={"type": "date"}),
        label="Starting after",
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

    def no_query_found(self):
        return self.searchqueryset.all()
