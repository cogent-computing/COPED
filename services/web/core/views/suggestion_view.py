from django.http import JsonResponse

from ..models import Organisation, Person, Subject, Project


def subject_suggest(request):
    """Provide a list of possible subjects to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        subjects = Subject.objects.filter(label__icontains=term).values_list("label")
        results = list(set([s[0] for s in subjects]))

    return JsonResponse({"results": results})


def title_suggest(request):
    """Provide a list of possible titles to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("q", "")
    if len(term) > 2:
        keywords = Project.objects.filter(title__icontains=term).values_list(
            "title", flat=True
        )
        results = list(set(keywords))

    return JsonResponse({"results": results})


def organisation_suggest(request):
    """Provide a list of possible organisations to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        organisations = Organisation.objects.filter(name__icontains=term).values_list(
            "name"
        )
        results = list(set([s[0] for s in organisations]))

    return JsonResponse({"results": results})


def person_suggest(request):
    """Provide a list of possible people to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        # TODO: suggest based on full name (needs model annotation)
        people = Person.objects.filter(
            full_name_annotation__icontains=term
        ).values_list("full_name_annotation")
        results = list(set([s[0] for s in people]))

    return JsonResponse({"results": results})
