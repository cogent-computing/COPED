from rules.contrib.views import PermissionRequiredMixin
from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from .filter_view import FilteredListView
from ..models import Organisation
from ..forms import OrganisationForm
from ..filters import OrganisationFilter


class OrganisationCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Organisation
    permission_required = "core.add_organisation"
    form_class = OrganisationForm
    template_name = "organisation_form.html"
    success_message = "Organisation created."

    def form_valid(self, form):
        form.instance.owner = self.request.user
        return super().form_valid(form)


class OrganisationUpdateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.UpdateView,
):
    model = Organisation
    permission_required = "core.change_organisation"
    form_class = OrganisationForm
    template_name = "organisation_form.html"
    success_message = "Organisation updated."


class OrganisationDetailView(generic.DetailView):
    model = Organisation
    template_name = "organisation_detail.html"


class OrganisationListView(FilteredListView):
    model = Organisation
    filterset_class = OrganisationFilter
    template_name = "organisation_list.html"
    paginate_by = 10
    order_by = "name"
