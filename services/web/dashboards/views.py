from django.shortcuts import render
from django.views.generic import ListView
from .models import Dashboard

class DashboardLandingView(ListView):
    model = Dashboard
    