from django_filters import FilterSet, CharFilter
from django import forms
from ..models import Organisation


class OrganisationFilter(FilterSet):
    name = CharFilter(
        label="Organisation Name",
        # method="search_query_filter",
        widget=forms.TextInput(
            # set up advanced autocomplete for bootstrap autocomplete
            # see https://bootstrap-autocomplete.readthedocs.io/en/latest/
            attrs={
                "class": "form-control advancedAutoCompleteOrganisation",
                "autocomplete": "off",
            }
        ),
        lookup_expr="icontains",
    )

    def search_query_filter(self, queryset, name, value):
        print(name)
        print(value)
        return queryset.filter(name__icontains=value)

    class Meta:
        model = Organisation
        fields = ["name"]
