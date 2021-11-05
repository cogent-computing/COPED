from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from rest_api import views

urlpatterns = [
    path("persons/", views.PersonList.as_view()),
    path("persons/<int:pk>/", views.PersonDetail.as_view()),
    path("funds/", views.FundList.as_view()),
    path("funds/<int:pk>/", views.FundDetail.as_view()),
    path("organisations/", views.OrganisationList.as_view()),
    path("organisations/<int:pk>/", views.OrganisationDetail.as_view()),
    path("projects/", views.ProjectList.as_view()),
    path("projects/<int:pk>/", views.ProjectDetail.as_view()),
]

urlpatterns = format_suffix_patterns(urlpatterns)
