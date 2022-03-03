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

## Settings for admin

admin.site.site_header = "CoPED Adminstration"

urlpatterns = [
    #
    #
    ###############
    ## SUB-PATHS ##
    ###############
    #
    path("__debug__/", include(debug_toolbar.urls)),
    path("admin/", admin.site.urls),
    path("api/", include("api.urls")),
    path("select2/", include("django_select2.urls")),
    path(
        "accounts/register/",
        RegistrationView.as_view(form_class=CustomUserForm),
        name="django_registration_register",
    ),
    path("accounts/", include("django_registration.backends.activation.urls")),
    path("accounts/", include("django.contrib.auth.urls")),
    path(
        "projects/<int:pk>/request-data-change/",
        views.ProjectRequestDataChangeView.as_view(),
        name="project-request-data-change",
    ),
    path(
        "projects/<int:pk>/claim-ownership/",
        views.ProjectClaimOwnershipView.as_view(),
        name="project-claim-ownership",
    ),
    path("messages/", include("pinax.messages.urls", namespace="pinax_messages")),
    path(
        "messages/inbox/started/",
        views.InboxStartedThreadsView.as_view(),
        name="inbox-started-threads",
    ),
    #
    #
    ############
    ## PEOPLE ##
    ############
    #
    path("people/suggest/", views.person_suggest, name="person-suggest"),
    path(
        "people/<int:pk>/",
        views.PersonDetailView.as_view(),
        name="person-detail",
    ),
    path("people/", views.PersonListView.as_view(), name="person-list"),
    path("people/create/", views.PersonCreateView.as_view(), name="person-create"),
    path(
        "people/<int:pk>/update/",
        views.PersonUpdateView.as_view(),
        name="person-update",
    ),
    path(
        "people/<int:person_id>/manage_orgs/",
        views.manage_person_orgs,
        name="person-manage-orgs",
    ),
    #
    #
    ###################
    ## ORGANISATIONS ##
    ###################
    #
    path(
        "organisations/suggest/",
        views.organisation_suggest,
        name="organisation-suggest",
    ),
    path(
        "organisations/<int:pk>/",
        views.OrganisationDetailView.as_view(),
        name="organisation-detail",
    ),
    path(
        "organisations/<int:pk>/update/",
        views.OrganisationUpdateView.as_view(),
        name="organisation-update",
    ),
    path(
        "organisations/", views.OrganisationListView.as_view(), name="organisation-list"
    ),
    path(
        "organisations/create/",
        views.OrganisationCreateView.as_view(),
        name="organisation-create",
    ),
    #
    #
    ##############
    ## PROJECTS ##
    ##############
    #
    path(
        "projects/<int:pk>/update/",
        views.ProjectUpdateView3.as_view(),
        name="project-update",
    ),
    path(
        "projects/<int:pk>/history/",
        views.ProjectHistoryView.as_view(),
        name="project-history",
    ),
    path(
        "projects/<int:pk>/", views.ProjectDetailView.as_view(), name="project-detail"
    ),
    # path(
    #     "projects/<int:pk>/update2/",
    #     views.ProjectUpdateView2.as_view(),
    #     name="project-update",
    # ),
    path("projects/create/", views.ProjectCreateView.as_view(), name="project-create"),
    path("projects/", views.project_list, name="project-list"),
    #
    #
    ##############
    ## SUBJECTS ##
    ##############
    #
    path("subjects/suggest/", views.subject_suggest, name="subject-suggest"),
    path("subjects/create/", views.SubjectCreateView.as_view(), name="subject-create"),
    path("subjects/", views.subject_list, name="subject-list"),
    #
    #
    ################
    ## GEOGRAPHIC ##
    ################
    #
    path("geo/create/", views.GeoCreateView.as_view(), name="geo-create"),
    path("addresses/create/", views.AddressCreateView.as_view(), name="address-create"),
    path(
        "addresses/<int:pk>/", views.AddressDetailView.as_view(), name="address-detail"
    ),
    path(
        "addresses/<int:pk>/update/",
        views.AddressUpdateView.as_view(),
        name="address-update",
    ),
    #
    #
    ###########
    ## LINKS ##
    ###########
    #
    path("links/create/", views.LinkCreateView.as_view(), name="link-create"),
    #
    #
    #
    #
    ##############
    ## KEYWORDS ##
    ##############
    #
    path("keywords/create/", views.KeywordCreateView.as_view(), name="keyword-create"),
    #
    #
    ###########
    ## USERS ##
    ###########
    #
    path("users/<int:pk>/", views.UserDetailView.as_view(), name="user-detail"),
    #
    #
    ###########################
    ## VISUALS AND ANALYTICS ##
    ###########################
    #
    path("analysis/", views.analysis_view, name="analysis"),
    path("visuals/dashboard2/", views.visuals_dashboard2, name="visuals-dashboard2"),
    path("visuals/dashboard/", views.visuals_dashboard, name="visuals-dashboard"),
    path(
        "visuals/dashboard_experiment",
        views.visuals_dashboard_experiment,
        name="visuals-dashboard-experiment",
    ),
    path("visuals/", views.visuals, name="visuals-index"),
    #
    #
    ##################
    ## LANDING PAGE ##
    ##################
    #
    path("", views.index, name="index"),
]
