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

urlpatterns = [
    # Login and Register
    # TODO: remove modal based login and revert to default approach (needed for smooth redirections)
    path("login/", views.login, name="login"),
    path("logout/", views.logout, name="logout"),
    path("register/", views.register, name="register"),
    path("password_reset/", views.password_reset, name="password_reset"),
    path("password_update/", views.password_update, name="password_update"),
    path("__debug__/", include(debug_toolbar.urls)),
    path("admin/", admin.site.urls),
    path("api/", include("api.urls")),
    path("projects/<int:pk>", views.ProjectDetailView.as_view(), name="project-detail"),
    path("projects/", views.project_list, name="project-list"),
    path("users/<int:pk>", views.UserDetailView.as_view(), name="user-detail"),
    # path("accounts/", include("django.contrib.auth.urls")),
    path("", views.index, name="index"),
]
