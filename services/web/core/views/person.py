from rules.contrib.views import PermissionRequiredMixin
from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django.forms import inlineformset_factory
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django_addanother.views import CreatePopupMixin
from extra_views import CreateWithInlinesView
from extra_views import UpdateWithInlinesView
from extra_views import InlineFormSetFactory

from .filter_view import FilteredListView
from ..models import Person, PersonOrganisation
from ..forms import PersonOrganisationForm, PersonForm
from ..filters import PersonFilter


class PersonOrganisationInline(InlineFormSetFactory):
    model = PersonOrganisation
    form_class = PersonOrganisationForm


class PersonOrganisationCreateInline(PersonOrganisationInline):
    factory_kwargs = {"extra": 1, "can_delete": False}


class PersonOrganisationUpdateInline(PersonOrganisationInline):
    factory_kwargs = {"extra": 0, "can_delete": True}


class PersonCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    CreateWithInlinesView,
):
    model = Person
    permission_required = "core.add_person"

    def get_permission_object(self):
        # Need to return None here as the inlines imply
        # get_object() is not None, but it also has no pk.
        return None

    form_class = PersonForm
    inlines = [PersonOrganisationCreateInline]
    template_name = "person_form.html"
    success_message = "Person added."

    def form_valid(self, form):
        form.instance.owner = self.request.user
        return super().form_valid(form)


class PersonUpdateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    UpdateWithInlinesView,
):
    model = Person
    permission_required = "core.change_person"
    form_class = PersonForm
    inlines = [PersonOrganisationUpdateInline]
    template_name = "person_form.html"
    success_message = "Person updated."


class PersonDetailView(generic.DetailView):
    model = Person
    template_name = "person_detail.html"


class PersonListView(FilteredListView):
    model = Person
    filterset_class = PersonFilter
    template_name = "person_list.html"
    paginate_by = 10
    order_by = "first_name"