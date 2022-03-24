from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django.forms import inlineformset_factory
from django.http import HttpResponseRedirect
from django.shortcuts import render
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


class PersonCreateView(LoginRequiredMixin, SuccessMessageMixin, CreateWithInlinesView):
    model = Person
    form_class = PersonForm
    inlines = [PersonOrganisationCreateInline]
    template_name = "person_form.html"
    success_message = "Person added."


class PersonUpdateView(LoginRequiredMixin, SuccessMessageMixin, UpdateWithInlinesView):
    model = Person
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


def manage_person_orgs(request, person_id):
    person = Person.objects.get(pk=person_id)
    OrganisationsInlineFormSet = inlineformset_factory(
        Person,
        PersonOrganisation,
        fields=["organisation", "role"],
        extra=1,
    )
    if request.method == "POST":
        formset = OrganisationsInlineFormSet(
            request.POST, request.FILES, instance=person
        )
        if formset.is_valid():
            formset.save()
            # Do something. Should generally end with a redirect. For example:
            return HttpResponseRedirect(person.get_absolute_url())
    else:
        formset = OrganisationsInlineFormSet(instance=person)
    return render(request, "manage_person_orgs.html", {"formset": formset})
