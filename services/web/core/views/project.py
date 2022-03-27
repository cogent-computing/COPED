from rules.contrib.views import PermissionRequiredMixin
from django.core.paginator import Paginator
from django.views import generic
from django.shortcuts import render
from django.contrib.auth import get_user_model
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from elasticsearch_dsl.query import MoreLikeThis
from extra_views import CreateWithInlinesView
from extra_views import UpdateWithInlinesView
from extra_views import InlineFormSetFactory

from ..models import (
    Address,
    Project,
    ProjectSubscription,
    ProjectFund,
    ProjectOrganisation,
    ProjectPerson,
)
from ..forms import (
    ProjectFundForm,
    ProjectOrganisationForm,
    ProjectPersonForm,
    ProjectFormWithInlines,
)
from ..filters import ProjectFilter
from ..documents import ProjectDocument


class ProjectHistoryView(generic.DetailView):

    model = Project
    template_name = "project_history.html"


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
        context["location_list"] = location_list

        subscriber_ids = ProjectSubscription.objects.filter(
            project=self.get_object()
        ).values_list("user_id", flat=True)
        subscribers = get_user_model().objects.filter(id__in=subscriber_ids)
        context["subscribers"] = subscribers

        return context


class ProjectFundInline(InlineFormSetFactory):
    model = ProjectFund
    form_class = ProjectFundForm
    prefix = "project-fund-form"


class ProjectFundUpdateInline(ProjectFundInline):
    factory_kwargs = {"extra": 0, "can_delete": True}


class ProjectFundCreateInline(ProjectFundInline):
    factory_kwargs = {"extra": 1, "can_delete": False}


class ProjectOrganisationInline(InlineFormSetFactory):
    model = ProjectOrganisation
    form_class = ProjectOrganisationForm
    prefix = "project-organisation-form"


class ProjectOrganisationUpdateInline(ProjectOrganisationInline):
    factory_kwargs = {"extra": 0, "can_delete": True}


class ProjectOrganisationCreateInline(ProjectOrganisationInline):
    factory_kwargs = {"extra": 1, "can_delete": False}


class ProjectPersonInline(InlineFormSetFactory):
    model = ProjectPerson
    form_class = ProjectPersonForm
    prefix = "project-person-form"


class ProjectPersonUpdateInline(ProjectPersonInline):
    factory_kwargs = {"extra": 0, "can_delete": True}


class ProjectPersonCreateInline(ProjectPersonInline):
    factory_kwargs = {"extra": 1, "can_delete": False}


class ProjectUpdateView3(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    UpdateWithInlinesView,
):
    model = Project
    permission_required = "core.change_project"
    inlines = [
        ProjectFundUpdateInline,
        ProjectPersonUpdateInline,
        ProjectOrganisationUpdateInline,
    ]
    form_class = ProjectFormWithInlines
    template_name = "project_form_with_inlines.html"
    success_message = "Project updated."


class ProjectCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreateWithInlinesView,
):

    model = Project
    permission_required = "core.add_project"

    def get_permission_object(self):
        # Need to return None here as the inlines imply
        # get_object() is not None, but it also has no pk.
        return None

    inlines = [
        ProjectFundCreateInline,
        ProjectPersonCreateInline,
        ProjectOrganisationCreateInline,
    ]
    form_class = ProjectFormWithInlines
    template_name = "project_form_with_inlines.html"
    success_message = "Project created."

    def form_valid(self, form):
        form.instance.owner = self.request.user
        return super().form_valid(form)


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
