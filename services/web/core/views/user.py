from django.views import generic
from django.urls import reverse
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin

from ..models import Project, User
from ..forms import UpdateUserForm


class UserDetailView(LoginRequiredMixin, generic.DetailView):
    model = User
    template_name = "users/user_detail.html"
    context_object_name = "user_record"

    def get_object(self, queryset=None):
        return User.objects.get(pk=self.request.user.id)


class UserDeleteView(LoginRequiredMixin, SuccessMessageMixin, generic.DeleteView):
    model = User
    template_name = "users/user_delete.html"
    success_message = "Your account has been deleted"
    context_object_name = "user_record"

    def get_success_url(self):
        return reverse("index")

    def get_object(self, queryset=None):
        return User.objects.get(pk=self.request.user.id)


class UserUpdateView(SuccessMessageMixin, LoginRequiredMixin, generic.UpdateView):

    model = User
    form_class = UpdateUserForm
    template_name = "users/user_update_form.html"
    success_message = "Changes saved."

    def get_success_url(self):
        return reverse("user-detail")

    def get_object(self, queryset=None):
        return User.objects.get(pk=self.request.user.id)


class ManagedProjectsListView(LoginRequiredMixin, generic.ListView):

    template_name = "users/managed_project_list.html"

    def get_queryset(self):
        user = self.request.user
        projects = Project.objects.filter(owner=user).all()
        return projects
