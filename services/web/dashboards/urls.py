from django.urls import path
from .views import DashboardLandingView, DashboardEmbedView

app_name = "dashboards"

urlpatterns = [
    path("<uuid:public_uuid>/", DashboardEmbedView.as_view(), name="embed"),
    path("", DashboardLandingView.as_view(), name="index"),
]
