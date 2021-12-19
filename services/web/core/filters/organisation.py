from django_filters import FilterSet, CharFilter, OrderingFilter
from django import forms
from ..models import Organisation


class OrganisationFilter(FilterSet):
    name = CharFilter(
        label="Name",
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
    o = OrderingFilter(label="Sort By", fields=("name",))

    class Meta:
        model = Organisation
        fields = ["name"]
