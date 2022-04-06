import jwt
import json
import time
from django.shortcuts import get_object_or_404
from django.views.generic import ListView, DetailView
from .models import Dashboard, Setting
from .utils import dashboard_embed_url


class DashboardLandingView(ListView):
    model = Dashboard


class DashboardEmbedView(DetailView):
    model = Dashboard

    def get_object(self, queryset=None):
        print("GOT UUID", self.kwargs.get("public_uuid"))
        dashboard = get_object_or_404(
            Dashboard, public_uuid=self.kwargs.get("public_uuid")
        )
        return dashboard

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["embed_url"] = dashboard_embed_url(self.object.id)
        return context
