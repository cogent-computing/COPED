import datetime
from django.http import JsonResponse
from haystack.generic_views import SearchView
from haystack.query import SearchQuerySet

from core.models.project import Project
from .forms import ProjectSearchForm


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
    template_name = "search_result.html"
    # template_name = "core/project_list.html"
    paginate_by = 5
    context_object_name = "project_list"
