from django.urls import reverse
from rules.contrib.views import PermissionRequiredMixin
from django.views import generic
from django.contrib.auth import get_user_model
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from .filter_view import FilteredListView
from ..models import Organisation, OrganisationSubscription
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

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        subscriber_ids = OrganisationSubscription.objects.filter(
            organisation=self.get_object()
        ).values_list("user_id", flat=True)
        subscribers = get_user_model().objects.filter(id__in=subscriber_ids)
        context["subscribers"] = subscribers

        return context


class OrganisationListView(FilteredListView):
    model = Organisation
    filterset_class = OrganisationFilter
    template_name = "organisation_list.html"
    paginate_by = 10
    order_by = "name"


class OrganisationDeleteView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    generic.DeleteView,
):
    model = Organisation
    template_name = "organisation_delete.html"
    permission_required = "core.delete_organisation"
    success_message = "Organisation deleted"

    def get_success_url(self):
        return reverse("organisation-list")
