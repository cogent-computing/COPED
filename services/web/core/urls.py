"""core URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
import debug_toolbar
from django.contrib import admin
from django.urls import include, path
from core import views
from django_registration.backends.activation.views import RegistrationView

from .forms import CustomUserForm

urlpatterns = [
    # Login and Register
    # TODO: remove modal based login and revert to default approach (needed for smooth redirections)
    path("__debug__/", include(debug_toolbar.urls)),
    path("admin/", admin.site.urls),
    path("api/", include("api.urls")),
    path("projects/<int:pk>", views.ProjectDetailView.as_view(), name="project-detail"),
    path("projects/", views.project_list, name="project-list"),
    path(
        "organisations/suggest/",
        views.organisation_suggest,
        name="organisation-suggest",
    ),
    path(
        "organisations/<int:pk>",
        views.OrganisationDetailView.as_view(),
        name="organisation-detail",
    ),
    path(
        "organisations/", views.OrganisationListView.as_view(), name="organisation-list"
    ),
    path("subjects/suggest/", views.subject_suggest, name="subject-suggest"),
    path("people/suggest/", views.person_suggest, name="person-suggest"),
    path(
        "people/<int:pk>",
        views.PersonDetailView.as_view(),
        name="person-detail",
    ),
    path("people/", views.PersonListView.as_view(), name="person-list"),
    path("users/<int:pk>", views.UserDetailView.as_view(), name="user-detail"),
    path(
        "accounts/register/",
        RegistrationView.as_view(form_class=CustomUserForm),
        name="django_registration_register",
    ),
    path("accounts/", include("django_registration.backends.activation.urls")),
    path("accounts/", include("django.contrib.auth.urls")),
    path("subjects/suggest/", views.subject_suggest, name="subject-suggest"),
    path("subjects/", views.subject_list, name="subject-list"),
    path("visuals/", views.visuals, name="visuals-index"),
    path("", views.index, name="index"),
]
