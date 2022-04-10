import logging
from django.views import generic
from django.urls import reverse
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_registration.backends.activation.views import RegistrationView

from ..models import Project, User
from ..forms import UpdateUserForm, ResendActivationEmailForm


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


class UserResendActivationEmailView(RegistrationView):
    template_name = "users/resend_activation_email.html"
    form_class = ResendActivationEmailForm

    def post(self, request, *args, **kwargs):

        email = request.POST.get("email")
        logging.debug("activation email requested for %s", email)
        user = User.objects.filter(email=email).first()

        if user and not user.is_active:
            logging.debug("sending user %s an activation email", user)
            RegistrationView.send_activation_email(self, user)
        elif user and user.is_active:
            logging.debug("user %s is already active, not sending email", user)
        else:
            logging.debug("email %s does not correspond to a registered user", email)

        messages.warning(
            request,
            "If the email was recognised, and your account is not already active, then you will receive account activation instructions shortly.",
        )
        return redirect("login")
