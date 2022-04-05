from django.urls import path
from .views import DashboardLandingView

app_name = "dashboards"

urlpatterns = [
    path("", DashboardLandingView.as_view(), name="index"),
]
