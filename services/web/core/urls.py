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
from .forms import ProjectSearchForm

# from search import urls as search_urls

urlpatterns = [
    path("__debug__/", include(debug_toolbar.urls)),
    path("admin/", admin.site.urls),
    path("api/", include("api.urls")),
    # path(r"search/", include(search_urls)),
    # path("search/", include("search.urls")),
    path("projects/<int:pk>", views.ProjectDetailView.as_view(), name="project-detail"),
    # path(
    #     "projects/<int:pk>/more-like-this",
    #     views.MoreLikeThisView.as_view(),
    #     name="more-like-this",
    # ),
    path(
        "projects/<int:pk>/more-like-this",
        views.mlt_view,
        name="more-like-this",
    ),
    # path("projects/", views.ProjectListView.as_view(), name="projects"),
    path("projects/autocomplete/", views.autocomplete),
    path(
        "projects/",
        views.ProjectSearchView.as_view(),
        name="projects",
    ),
    path("", views.index, name="index"),
]
