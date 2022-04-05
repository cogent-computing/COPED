from django.shortcuts import get_object_or_404
from django.views.generic import ListView, DetailView
from .models import Dashboard

class DashboardLandingView(ListView):
    model = Dashboard

class DashboardEmbedView(DetailView):
    model = Dashboard
    def get_object(self, queryset=None):
        return get_object_or_404(Dashboard, public_uuid=self.kwargs.get("public_uuid"))
