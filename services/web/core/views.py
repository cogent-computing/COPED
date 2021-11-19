from django.http import JsonResponse
from django.views import generic
from django.shortcuts import render
from haystack.generic_views import SearchView
from haystack.query import SearchQuerySet
from .models.project import Project
from .forms import ProjectSearchForm


def index(request):
    return render(request, "index.html")


class ProjectListView(generic.ListView):
    model = Project
    paginate_by = 10


class ProjectDetailView(generic.DetailView):
    model = Project


def autocomplete(request):
    sqs = SearchQuerySet().autocomplete(text__exact=request.GET.get("q", "")[:8])
    s = []
    for result in sqs:
        print(result)
        d = {"value": result.title, "data": result.object.get_absolute_url()}
        s.append(d)
    output = {"suggestions": s}
    return JsonResponse(output)


# Now create your own that subclasses the base view
class ProjectSearchView(SearchView):
    form_class = ProjectSearchForm
    template_name = "core/project_list.html"
    paginate_by = 50
    context_object_name = "project_list"

    # def get_queryset(self):
    #     return super().get_queryset()
