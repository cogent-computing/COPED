from django.shortcuts import render
from django.views import generic
from .models.project import Project


def index(request):
    return render(request, "index.html")


class ProjectListView(generic.ListView):
    model = Project
    paginate_by = 10


class ProjectDetailView(generic.DetailView):
    model = Project
