import re
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.http import JsonResponse, HttpResponse
from django.http.request import QueryDict
from django.views import generic
from django.shortcuts import render
from haystack.generic_views import SearchView
from haystack.query import SearchQuerySet

from api.serializers import project
from .models.project import Project
from .forms import ProjectSearchForm
from .filters import ProjectFilter

from elasticsearch_dsl.query import MoreLikeThis
from .documents import ProjectDocument


def index(request):
    return render(request, "index.html")


class ProjectListView(generic.ListView):
    model = Project
    paginate_by = 10


class ProjectDetailView(generic.DetailView):
    model = Project


def autocomplete(request):
    # return autocomplete_word(request)
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
        s = []
        for result in sqs:
            title = result.title
            title_words = title.split()
            for w in title_words:
                if query in w:
                    s.append({"value": w, "data": result.object.get_absolute_url()})
        output = {"suggestions": s[:10]}
        return JsonResponse(output)


class ProjectSearchView(SearchView):
    form_class = ProjectSearchForm
    template_name = "core/project_list.html"
    paginate_by = 10
    context_object_name = "project_list"


class MoreLikeThisView(ProjectSearchView):
    pass


def mlt_view(request, pk):
    project = Project.objects.get(pk=pk)
    mlt = SearchQuerySet().more_like_this(project)
    paginator = Paginator(mlt, 10)
    page_number = request.GET.get("page", 1)
    page_obj = paginator.get_page(page_number)
    print(page_obj.object_list)
    return render(
        request,
        "core/project_list.html",
        {
            "page_obj": page_obj,
            "form": ProjectSearchForm,
            "project_list": page_obj.object_list,
            "is_paginated": True,
            "page": page_obj,
        },
    )


# def more_like_this(request, pk):
#     """Query the search index for similar documents."""

#     number_to_show = 40
#     s = ProjectDocument.search()
#     s = s.query(MoreLikeThis(like={"_id": pk}, fields=["title", "description"]))
#     return render(
#         request,
#         "core/project_list.html",
#         {"page_obj": s[:number_to_show].to_queryset()},
#     )


def project_list(request):
    """Main filterable search page for project searches."""

    # TODO: catch non numeric parameters
    more_like_this = request.GET.get("mlt", None)
    if more_like_this:
        more_like_this = int(more_like_this)
        s = ProjectDocument.search()
        s = s.query(
            MoreLikeThis(like={"_id": more_like_this}, fields=["title", "description"])
        )
        # TODO: think about thresholding on the result scores
        s = s.extra(size=400)
        qs = s.to_queryset()
    else:
        qs = Project.objects.all().order_by("status")

    f = ProjectFilter(request.GET, queryset=qs)
    paginate_by = 20
    paginator = Paginator(f.qs, paginate_by)
    page_number = request.GET.get("page", 1)
    page_obj = paginator.get_page(page_number)
    page_list_start_number = (int(page_number) - 1) * paginate_by + 1

    context = {
        "page_obj": page_obj,
        "is_paginated": True,
        "list_start": page_list_start_number,
        "filter": f,
    }
    if more_like_this:
        context.update({"more_like_this": Project.objects.get(pk=more_like_this)})

    print("QUERYSTRING in VIEW")
    print(request.GET)
    if request.GET.get("mlt", None):
        print("WANT MORE LIKE THIS")
    else:
        print("REGULAR SEARCH QUERY")

    return render(
        request,
        "core/project_list.html",
        context,
    )
