from django.db.models import Count
from django.core.paginator import Paginator
from django.views import generic
from django.http import JsonResponse, HttpResponseRedirect
from django.urls import reverse
from django.contrib import messages
from django.shortcuts import render
from django.forms import inlineformset_factory
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import UserPassesTestMixin
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin
from elasticsearch_dsl.query import MoreLikeThis

from .models import (
    Address,
    GeoData,
    Organisation,
    Person,
    PersonOrganisation,
    Project,
    ProjectSubject,
    Subject,
    User,
    ExternalLink,
)
from .forms import (
    ProjectForm,
    ProjectForm2,
    ProjectSubjectsFormSet2,
    AddressForm,
    OrganisationForm,
    PersonOrganisationForm,
    PersonForm,
)
from .filters import ProjectFilter, OrganisationFilter, PersonFilter
from .documents import ProjectDocument


class FilteredListView(generic.ListView):
    filterset_class = None
    order_by = None

    def get_queryset(self):
        # Get the standard queryset, which will use the subclass "model" attribute.
        queryset = super().get_queryset()
        if self.order_by is not None:
            queryset = queryset.order_by(self.order_by)
        # Then use the query parameters and the queryset to
        # instantiate a filterset and save it as an attribute
        # on the view instance for use later when setting the context.
        self.filterset = self.filterset_class(self.request.GET, queryset=queryset)
        # Return the filtered queryset
        return self.filterset.qs.distinct()

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Pass the filterset to the template - it provides the form.
        context["filter"] = self.filterset
        return context


def index(request):
    return render(request, "index.html")


def visuals(request):
    return render(request, "visuals.html")


def visuals_dashboard(request):
    return render(request, "visuals_dashboard.html")


def visuals_dashboard_experiment(request):
    import jwt
    import time

    METABASE_SITE_URL = "http://localhost/metabase"
    METABASE_SECRET_KEY = (
        "156812543071f0108b459434ebb9997b56865770f45fb9c19ff348772e72c0e4"
    )

    payload = {
        "resource": {"dashboard": 1},
        "params": {},
        "exp": round(time.time()) + (60 * 10),  # 10 minute expiration
    }

    token = jwt.encode(payload, METABASE_SECRET_KEY, algorithm="HS256")

    iframeUrl = (
        METABASE_SITE_URL + "/embed/dashboard/" + token + "#bordered=false&titled=true"
    )

    return render(
        request, "visuals_dashboard_experiment.html", context={"iframeUrl": iframeUrl}
    )


@login_required
def visuals_dashboard2(request):
    return render(request, "visuals_dashboard2.html")


class UserDetailView(UserPassesTestMixin, generic.DetailView):
    model = User
    template_name = "users/user_detail.html"
    context_object_name = "user_record"

    def test_func(self):
        return self.request.user.id == self.get_object().id


class ProjectDetailView(generic.DetailView):
    model = Project
    template_name = "project_detail.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        addresses = Address.objects.filter(
            organisation__in=self.get_object().organisations.all()
        )
        location_list = [[a.geo.lat, a.geo.lon] for a in addresses]
        has_latlon = lambda loc: loc[0] != 0 or loc[1] != 0
        location_list = list(filter(has_latlon, location_list))
        print("LOCATIONS", location_list)
        context["location_list"] = location_list
        return context


class ProjectUpdateView(LoginRequiredMixin, SuccessMessageMixin, generic.UpdateView):

    model = Project
    form_class = ProjectForm
    template_name = "project_update_form.html"
    success_message = "Project saved."


class ProjectUpdateView2(generic.UpdateView):

    model = Project
    form_class = ProjectForm2
    template_name = "project_update_form2.html"
    success_messages = "Project2 saved."

    def form_valid(self, form):
        print("form:", dir(form))

        self.object = form.save()
        messages.success(self.request, "Changes to project saved")

        context = self.get_context_data(form=form)
        formset = context["project_subjects"]
        if formset.is_valid():
            response = super().form_valid(form)
            formset.instance = self.object
            formset.save()
            return response
        else:
            return super().form_invalid(form)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        if self.request.POST:
            context["project_subjects"] = ProjectSubjectsFormSet2(
                self.request.POST, instance=self.object
            )
            context["project_subjects"].full_clean()
        else:
            context["project_subjects"] = ProjectSubjectsFormSet2(instance=self.object)
        return context


class SubjectCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Subject
    template_name = "subject_form.html"
    fields = ["label"]
    success_message = "Subject created."


class GeoCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = GeoData
    template_name = "geo_form.html"
    fields = ["lat", "lon"]
    success_message = "Geo location created."


# class PersonCreateView(
#     LoginRequiredMixin,
#     SuccessMessageMixin,
#     CreatePopupMixin,
#     generic.CreateView,
# ):
#     model = Person
#     form_class = PersonForm
#     template_name = "person_form.html"
#     success_message = "Person created."


from extra_views import (
    CreateWithInlinesView,
    UpdateWithInlinesView,
    InlineFormSetFactory,
)


class PersonOrganisationInline(InlineFormSetFactory):
    model = PersonOrganisation
    form_class = PersonOrganisationForm
    factory_kwargs = {"extra": 1, "can_delete": False}


class AddressGeoInline(InlineFormSetFactory):
    model = GeoData
    fields = ["lat", "lon"]
    factory_kwargs = {"extra": 0}


class AddressDetailView(generic.DetailView):
    model = Address
    template_name = "address_detail.html"


class AddressCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Address
    form_class = AddressForm
    template_name = "address_form.html"
    success_message = "Address created."


class OrganisationCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Organisation
    form_class = OrganisationForm
    template_name = "organisation_form.html"
    success_message = "Organisation created."


class LinkCreateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = ExternalLink
    template_name = "link_form.html"
    fields = ["description", "link"]
    success_message = "External link created."


class AddressUpdateView(generic.UpdateView):
    model = Address
    form_class = AddressForm
    template_name = "address_form.html"


class PersonCreateView(CreateWithInlinesView):
    model = Person
    form_class = PersonForm
    inlines = [PersonOrganisationInline]
    template_name = "person_and_organisations.html"
    success_message = "Person added."


class PersonUpdateView2(UpdateWithInlinesView):
    model = Person
    inlines = [
        PersonOrganisationInline,
    ]
    fields = ["first_name", "last_name", "orcid_id"]
    template_name = "person_and_organisations.html"


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


class ExternalLinkUpdateView(
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.UpdateView,
):
    model = ExternalLink
    template_name = "external_link_form.html"
    fields = ["description", "link"]
    success_message = "External link updated."


class OrganisationDetailView(generic.DetailView):
    model = Organisation
    template_name = "organisation_detail.html"


class OrganisationListView(FilteredListView):
    model = Organisation
    filterset_class = OrganisationFilter
    template_name = "organisation_list.html"
    paginate_by = 10
    order_by = "name"


class PersonDetailView(generic.DetailView):
    model = Person
    template_name = "person_detail.html"


class PersonListView(FilteredListView):
    model = Person
    filterset_class = PersonFilter
    template_name = "person_list.html"
    paginate_by = 10
    order_by = "first_name"


def subject_suggest(request):
    """Provide a list of possible subjects to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        subjects = Subject.objects.filter(label__icontains=term).values_list("label")
        results = list(set([s[0] for s in subjects]))

    return JsonResponse({"results": results})


def organisation_suggest(request):
    """Provide a list of possible organisations to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        organisations = Organisation.objects.filter(name__icontains=term).values_list(
            "name"
        )
        results = list(set([s[0] for s in organisations]))

    return JsonResponse({"results": results})


def person_suggest(request):
    """Provide a list of possible people to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        # TODO: suggest based on full name (needs model annotation)
        people = Person.objects.filter(
            full_name_annotation__icontains=term
        ).values_list("full_name_annotation")
        results = list(set([s[0] for s in people]))

    return JsonResponse({"results": results})


def subject_list(request):
    subject_counts = (
        ProjectSubject.objects.all()
        .values("subject__label", "subject")
        .annotate(total=Count("subject"))
        .order_by("-total")
    )
    max_font_size = 30
    font_normalisation_factor = subject_counts[0]["total"] / max_font_size
    subjects_with_sizes = [
        {
            "label": s["subject__label"],
            "size": s["total"] / font_normalisation_factor,
            "count": s["total"],
        }
        for s in subject_counts
    ]
    return render(
        request, "project_subjects.html", context={"subjects": subjects_with_sizes}
    )


def project_list(request):
    """Main filterable search page for project searches."""

    # TODO: catch non numeric parameters
    more_like_this = request.GET.get("mlt", None)
    if more_like_this:
        more_like_this = int(more_like_this)
        s = ProjectDocument.search()
        s = s.query(
            MoreLikeThis(like={"_id": more_like_this}, fields=["title", "description"])
        )
        # TODO: think about thresholding on the result scores
        s = s.extra(size=400)
        qs = s.to_queryset()
    else:
        qs = Project.objects.all()

    f = ProjectFilter(request.GET, queryset=qs)
    paginate_by = 20
    paginator = Paginator(f.qs, paginate_by)
    page_number = request.GET.get("page", 1)
    page_obj = paginator.get_page(page_number)
    page_list_start_number = (int(page_number) - 1) * paginate_by + 1

    context = {
        "page_obj": page_obj,
        "is_paginated": True,
        "list_start": page_list_start_number,
        "filter": f,
    }
    if more_like_this:
        context.update({"more_like_this": Project.objects.get(pk=more_like_this)})

    print("QUERYSTRING in VIEW")
    print(request.GET)
    if request.GET.get("mlt", None):
        print("WANT MORE LIKE THIS")
    else:
        print("REGULAR SEARCH QUERY")

    return render(
        request,
        "project_list.html",
        context,
    )
