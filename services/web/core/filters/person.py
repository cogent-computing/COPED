from django_filters import FilterSet, CharFilter
from django import forms
from ..models import Person


class PersonFilter(FilterSet):
    last_name = CharFilter(
        label="Search by Name",
        # method="search_query_filter",
        widget=forms.TextInput(
            # set up advanced autocomplete for bootstrap autocomplete
            # see https://bootstrap-autocomplete.readthedocs.io/en/latest/
            attrs={
                "class": "form-control advancedAutoCompletePerson",
                "autocomplete": "off",
            }
        ),
        lookup_expr="icontains",
    )

    class Meta:
        model = Person
        fields = ["last_name"]
