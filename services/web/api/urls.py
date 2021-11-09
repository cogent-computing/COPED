from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.schemas import get_schema_view
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
    path(
        "openapi",
        get_schema_view(
            title="CoPED",
            description="Catalogue of Projects on Energy Data",
            version="1.0.0",
        ),
        name="openapi-schema",
    ),
    path("", views.api_root),
]

urlpatterns = format_suffix_patterns(urlpatterns)
