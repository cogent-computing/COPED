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

# from core import views
# from core.models import project
from core.views import (
    action_view,
    address,
    announcement,
    favourite,
    keyword,
    link,
    message,
    organisation,
    page_view,
    person,
    project,
    subject,
    suggestion_view,
    user,
)
from django.contrib.sitemaps.views import sitemap
from .sitemaps import ProjectSitemap
from django_registration.backends.activation.views import RegistrationView

from .forms import CustomUserForm

app_name = "core"
sitemaps = {"project": ProjectSitemap}

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
    path("invitations/", include("invitations.urls", namespace="invitations")),
    path(
        "accounts/register/",
        RegistrationView.as_view(form_class=CustomUserForm),
        name="django_registration_register",
    ),
    path(
        "accounts/activate/resend/",
        user.UserResendActivationEmailView.as_view(),
        name="resend-activation-email",
    ),
    path("accounts/", include("django_registration.backends.activation.urls")),
    path("accounts/", include("django.contrib.auth.urls")),
    path(
        "projects/<int:pk>/request-data-change/",
        message.ProjectRequestDataChangeView.as_view(),
        name="project-request-data-change",
    ),
    path(
        "projects/<int:pk>/claim-ownership/",
        message.ProjectClaimOwnershipView.as_view(),
        name="project-claim-ownership",
    ),
    path(
        "projects/<int:pk>/contact-owner/",
        message.ProjectContactOwnerView.as_view(),
        name="project-contact-owner",
    ),
    path(
        "projects/<int:pk>/favourite/",
        action_view.favourite_project,
        name="project-favourite",
    ),
    path(
        "projects/<int:pk>/unsubscribe/",
        action_view.unfavourite_project,
        name="project-unfavourite",
    ),
    path("messages/inbox/", message.InboxView.as_view(), name="pinax_messages:inbox"),
    path("messages/", include("pinax.messages.urls", namespace="pinax_messages")),
    path(
        "announcements/",
        announcement.AnnouncementListView.as_view(),
        name="pinax_announcements:announcement_list",
    ),
    path(
        "announcements/propose/",
        message.ProposeAnnouncementView.as_view(),
        name="propose-announcement",
    ),
    path(
        "announcements/",
        include("pinax.announcements.urls", namespace="pinax_announcements"),
    ),
    #
    #
    ############
    ## PEOPLE ##
    ############
    #
    path("people/suggest/", suggestion_view.person_suggest, name="person-suggest"),
    path(
        "people/<int:pk>/",
        person.PersonDetailView.as_view(),
        name="person-detail",
    ),
    path("people/", person.PersonListView.as_view(), name="person-list"),
    path("people/create/", person.PersonCreateView.as_view(), name="person-create"),
    path(
        "people/<int:pk>/update/",
        person.PersonUpdateView.as_view(),
        name="person-update",
    ),
    path(
        "people/<int:pk>/delete/",
        person.PersonDeleteView.as_view(),
        name="person-delete",
    ),
    path(
        "people/<int:pk>/request-data-change/",
        message.PersonRequestDataChangeView.as_view(),
        name="person-request-data-change",
    ),
    path(
        "people/<int:pk>/claim-ownership/",
        message.PersonClaimOwnershipView.as_view(),
        name="person-claim-ownership",
    ),
    path(
        "people/<int:pk>/contact-owner/",
        message.PersonContactOwnerView.as_view(),
        name="person-contact-owner",
    ),
    path(
        "people/<int:pk>/favourite/",
        action_view.favourite_person,
        name="person-favourite",
    ),
    path(
        "people/<int:pk>/unsubscribe/",
        action_view.unfavourite_person,
        name="person-unfavourite",
    ),
    #
    #
    ###################
    ## ORGANISATIONS ##
    ###################
    #
    path(
        "organisations/suggest/",
        suggestion_view.organisation_suggest,
        name="organisation-suggest",
    ),
    path(
        "organisations/<int:pk>/",
        organisation.OrganisationDetailView.as_view(),
        name="organisation-detail",
    ),
    path(
        "organisations/<int:pk>/update/",
        organisation.OrganisationUpdateView.as_view(),
        name="organisation-update",
    ),
    path(
        "organisations/",
        organisation.OrganisationListView.as_view(),
        name="organisation-list",
    ),
    path(
        "organisations/create/",
        organisation.OrganisationCreateView.as_view(),
        name="organisation-create",
    ),
    #
    #
    ##############
    ## PROJECTS ##
    ##############
    #
    path("projects/suggest/", suggestion_view.title_suggest, name="title-suggest"),
    path(
        "projects/<int:pk>/update/",
        project.ProjectUpdateView3.as_view(),
        name="project-update",
    ),
    path(
        "projects/<int:pk>/delete/",
        project.ProjectDeleteView.as_view(),
        name="project-delete",
    ),
    path(
        "projects/<int:pk>/history/",
        project.ProjectHistoryView.as_view(),
        name="project-history",
    ),
    path(
        "projects/<int:pk>/", project.ProjectDetailView.as_view(), name="project-detail"
    ),
    path(
        "projects/create/", project.ProjectCreateView.as_view(), name="project-create"
    ),
    path("projects/", project.project_list, name="project-list"),
    #
    #
    ##############
    ## SUBJECTS ##
    ##############
    #
    path("subjects/suggest/", suggestion_view.subject_suggest, name="subject-suggest"),
    path(
        "subjects/create/", subject.SubjectCreateView.as_view(), name="subject-create"
    ),
    path("subjects/", subject.subject_list, name="subject-list"),
    #
    #
    ################
    ## GEOGRAPHIC ##
    ################
    #
    path("geo/create/", address.GeoCreateView.as_view(), name="geo-create"),
    path(
        "addresses/create/", address.AddressCreateView.as_view(), name="address-create"
    ),
    path(
        "addresses/<int:pk>/",
        address.AddressDetailView.as_view(),
        name="address-detail",
    ),
    #
    #
    ###########
    ## LINKS ##
    ###########
    #
    path("links/create/", link.LinkCreateView.as_view(), name="link-create"),
    #
    #
    ##############
    ## KEYWORDS ##
    ##############
    #
    path(
        "keywords/create/", keyword.KeywordCreateView.as_view(), name="keyword-create"
    ),
    #
    #
    ###########
    ## USERS ##
    ###########
    #
    path("favourites/", favourite.FavouriteListView.as_view(), name="user-favourites"),
    path(
        "managed/",
        user.ManagedProjectsListView.as_view(),
        name="user-managed-projects",
    ),
    path(
        "request-contributor-permissions/",
        message.RequestContributorPermissionsView.as_view(),
        name="request-contributor-permissions",
    ),
    path("profile/", user.UserDetailView.as_view(), name="user-detail"),
    path("profile/update/", user.UserUpdateView.as_view(), name="user-update"),
    path("profile/delete/", user.UserDeleteView.as_view(), name="user-delete"),
    #
    #
    ###########################
    ## VISUALS AND ANALYTICS ##
    ###########################
    #
    path("analysis/", page_view.analysis_view, name="analysis"),
    path(
        "visuals/dashboard2/", page_view.visuals_dashboard2, name="visuals-dashboard2"
    ),
    path("visuals/dashboard/", page_view.visuals_dashboard, name="visuals-dashboard"),
    path(
        "visuals/dashboard_experiment",
        page_view.visuals_dashboard_experiment,
        name="visuals-dashboard-experiment",
    ),
    path("visuals/", page_view.visuals, name="visuals-index"),
    path("dashboards/", include("dashboards.urls", namespace="dashboards")),
    #
    #
    ##############################
    ## LANDING PAGE AND SITEMAP ##
    ##############################
    #
    path("", page_view.index, name="index"),
    path(
        "sitemap.xml",
        sitemap,
        {"sitemaps": sitemaps},
        name="django.contrib.sitemaps.views.sitemap",
    ),
]
