import jwt
import json
import time
from django.shortcuts import get_object_or_404
from django.views.generic import ListView, DetailView
from .models import Dashboard, Setting

class DashboardLandingView(ListView):
    model = Dashboard

class DashboardEmbedView(DetailView):
    model = Dashboard

    def get_object(self, queryset=None):
        print("GOT UUID", self.kwargs.get("public_uuid"))
        dashboard = get_object_or_404(Dashboard, public_uuid=self.kwargs.get("public_uuid"))
        return dashboard

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        embedding_secret_key = get_object_or_404(Setting, key="embedding-secret-key").value
        metabase_site_url = get_object_or_404(Setting, key="site-url").value
        payload = {
            "resource": {
                "dashboard": self.object.id
            },
            "params": {},
            "exp": round(time.time()) + (60 * 10) # 10 minute expiration
        }
        token = jwt.encode(payload, embedding_secret_key, algorithm="HS256")
        context["embed_url"] = metabase_site_url + "/embed/dashboard/" + token + "#bordered=false&titled=true"
        return context
    