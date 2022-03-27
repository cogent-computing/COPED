from rules.contrib.views import PermissionRequiredMixin
from django.db.models import Count
from django.views import generic
from django.shortcuts import render
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django_addanother.views import CreatePopupMixin

from ..models import ProjectSubject, Subject


class SubjectCreateView(
    PermissionRequiredMixin,
    LoginRequiredMixin,
    SuccessMessageMixin,
    CreatePopupMixin,
    generic.CreateView,
):
    model = Subject
    permission_required = "core.add_subject"
    template_name = "subject_form.html"
    fields = ["label"]
    success_message = "Subject created."


def subject_list(request):
    subject_counts = (
        ProjectSubject.objects.all()
        .values("subject__label", "subject")
        .annotate(total=Count("subject"))
        .order_by("-total")
    )
    max_font_size = 30
    font_normalisation_factor = subject_counts[0]["total"] / max_font_size
    subjects_with_sizes = [
        {
            "label": s["subject__label"],
            "size": s["total"] / font_normalisation_factor,
            "count": s["total"],
        }
        for s in subject_counts
    ]
    return render(
        request, "project_subjects.html", context={"subjects": subjects_with_sizes}
    )
