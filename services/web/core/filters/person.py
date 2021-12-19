from django_filters import FilterSet, CharFilter, OrderingFilter
from django import forms
from ..models import Person


class PersonFilter(FilterSet):
    full_name = CharFilter(
        label="Name",
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
    organisation = CharFilter(
        label="Organisation",
        widget=forms.TextInput(
            # set up advanced autocomplete for bootstrap autocomplete
            # see https://bootstrap-autocomplete.readthedocs.io/en/latest/
            attrs={
                "class": "form-control advancedAutoCompleteOrganisation",
                "autocomplete": "off",
            }
        ),
        lookup_expr="icontains",
        field_name="organisations__name",
    )
    o = OrderingFilter(
        label="Sort By",
        fields=("last_name", "first_name", "organisations__name"),
        field_labels={
            "organisations__name": "Organisation",
        },
    )

    class Meta:
        model = Person
        fields = ["full_name"]
