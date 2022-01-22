from django import forms
from django.urls import reverse_lazy
from django_select2 import forms as s2forms
from django_addanother.widgets import AddAnotherWidgetWrapper

from ..models import Person, PersonOrganisation, Organisation


# class OrganisationWidget(s2forms.ModelSelect2MultipleWidget):
#     model = PersonOrganisation
#     search_fields = ["organisation__name__icontains"]
#     queryset = PersonOrganisation.objects.none()

#     def label_from_instance(self, obj):
#         return f"{obj.organisation.name} ({obj.role})"

#     def get_queryset(self):
#         print("GETTING QUERYSET", dir(self))
#         return super().get_queryset()


class OrganisationWidget(s2forms.ModelSelect2MultipleWidget):
    search_fields = ["name__icontains"]


class PersonForm(forms.ModelForm):

    # organisations = forms.MultipleChoiceField(widget=OrganisationWidget)

    class Meta:
        model = Person
        fields = [
            "first_name",
            "other_name",
            "last_name",
            "email",
            "orcid_id",
            "organisations",
        ]

        # widgets = {
        #     "organisations": AddAnotherWidgetWrapper(
        #         OrganisationWidget, reverse_lazy("organisation-create")
        #     ),
        #     #     # "external_links": AddAnotherWidgetWrapper(
        #     #     #     LinksWidget, reverse_lazy("link-create")
        #     #     # ),
        # }


class PersonOrganisationForm(forms.ModelForm):
    class Meta:
        model = PersonOrganisation
        fields = ["organisation", "role"]
        widgets = {
            "organisation": AddAnotherWidgetWrapper(
                s2forms.ModelSelect2Widget(
                    model=Organisation,
                    search_fields=["name__icontains"],
                ),
                reverse_lazy("organisation-create"),
            )
        }
