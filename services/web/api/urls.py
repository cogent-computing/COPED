from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from api import views

urlpatterns = [
    path("persons/", views.PersonList.as_view(), name="person-list"),
    path("persons/<int:pk>/", views.PersonDetail.as_view(), name="person-detail"),
    path("funds/", views.FundList.as_view(), name="fund-list"),
    path("funds/<int:pk>/", views.FundDetail.as_view(), name="fund-detail"),
    path("organisations/", views.OrganisationList.as_view(), name="organisation-list"),
    path(
        "organisations/<int:pk>/",
        views.OrganisationDetail.as_view(),
        name="organisation-detail",
    ),
    path("projects/", views.ProjectList.as_view(), name="project-list"),
    path("projects/<int:pk>/", views.ProjectDetail.as_view(), name="project-detail"),
    path("", views.api_root),
]

urlpatterns = format_suffix_patterns(urlpatterns)
