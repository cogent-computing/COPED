import secrets
import datetime
import pytz

from django.core.paginator import Paginator
from django.views import generic
from django.urls import reverse
from django.http import JsonResponse
from django.shortcuts import render
from django.shortcuts import redirect
from django.template.loader import render_to_string
from django.contrib import auth
from django.contrib import messages
from django.contrib.auth.mixins import UserPassesTestMixin

# from django.http import HttpRequest

from .models.project import Project
from .filters import ProjectFilter
from .models import User
from .models import Subject

from elasticsearch_dsl.query import MoreLikeThis
from .documents import ProjectDocument


def index(request):
    return render(request, "index.html")


class UserDetailView(UserPassesTestMixin, generic.DetailView):
    model = User
    template_name = "users/user_detail.html"
    context_object_name = "user_record"

    def test_func(self):
        return self.request.user.id == self.get_object().id


class ProjectDetailView(generic.DetailView):
    model = Project
    template_name = "project_detail.html"


def subject_suggest(request):
    """Provide a list of possible subjects to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        subjects = Subject.objects.filter(label__contains=term).values_list("label")
        results = [s[0] for s in subjects]

    return JsonResponse({"results": results})


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
        qs = Project.objects.all()

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
        "project_list.html",
        context,
    )
