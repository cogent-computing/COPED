import re
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
    sqs = SearchQuerySet().autocomplete(title_auto=request.GET.get("q", ""))[:10]
    s = []
    for result in sqs:
        d = {"value": result.title, "data": result.object.get_absolute_url()}
        s.append(d)
    output = {"suggestions": s}
    return JsonResponse(output)


def autocomplete_word(request):
    query = request.GET.get("q", "")
    if len(query) <= 2:
        return JsonResponse({"suggestions": []})
    else:
        sqs = SearchQuerySet().autocomplete(title_auto=request.GET.get("q", ""))[:100]
        s = set()
        for result in sqs:
            title = result.title
            title_words = re.split("(\W+?)", title)
            match_words = [w for w in title_words if query in w]
            s.update(match_words)
        output = {"suggestions": s}
        return JsonResponse(output)


# Now create your own that subclasses the base view
class ProjectSearchView(SearchView):
    form_class = ProjectSearchForm
    template_name = "core/project_list.html"
    paginate_by = 50
    context_object_name = "project_list"
