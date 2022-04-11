from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required

from ..models import (
    Project,
    ProjectSubscription,
    Person,
    PersonSubscription,
    Organisation,
    OrganisationSubscription,
)


@login_required
def favourite_project(request, pk):
    if request.method == "GET":
        sub, created = ProjectSubscription.objects.get_or_create(
            user=request.user, project=Project.objects.get(pk=pk)
        )
        if created:
            messages.success(request, "Favourite added")
        elif sub.id:
            messages.warning(request, "Already a favourite")
        else:
            messages.error(request, "Error adding favourite")
        return redirect("project-detail", pk=pk)


@login_required
def favourite_person(request, pk):
    if request.method == "GET":
        sub, created = PersonSubscription.objects.get_or_create(
            user=request.user, person=Person.objects.get(pk=pk)
        )
        if created:
            messages.success(request, "Favourite added")
        elif sub.id:
            messages.warning(request, "Already a favourite")
        else:
            messages.error(request, "Error adding favourite")
        return redirect("person-detail", pk=pk)


@login_required
def favourite_organisation(request, pk):
    if request.method == "GET":
        sub, created = OrganisationSubscription.objects.get_or_create(
            user=request.user, organisation=Organisation.objects.get(pk=pk)
        )
        if created:
            messages.success(request, "Favourite added")
        elif sub.id:
            messages.warning(request, "Already a favourite")
        else:
            messages.error(request, "Error adding favourite")
        return redirect("organisation-detail", pk=pk)


@login_required
def unfavourite_project(request, pk):
    if request.method == "GET":

        try:
            project = Project.objects.get(pk=pk)
            sub = ProjectSubscription.objects.get(user=request.user, project=project)
        except ProjectSubscription.DoesNotExist:
            messages.warning(request, "Not a favourite")
            return redirect("project-detail", pk=pk)

        deleted, _ = ProjectSubscription.objects.filter(
            user=request.user, project=Project.objects.get(pk=pk)
        ).delete()

        if deleted:
            messages.success(request, "Favourite removed")
        else:
            messages.error(request, "Error removing favourite")

        return redirect("project-detail", pk=pk)


@login_required
def unfavourite_person(request, pk):
    if request.method == "GET":

        try:
            person = Person.objects.get(pk=pk)
            sub = PersonSubscription.objects.get(user=request.user, person=person)
        except PersonSubscription.DoesNotExist:
            messages.warning(request, "Not a favourite")
            return redirect("person-detail", pk=pk)

        deleted, _ = PersonSubscription.objects.filter(
            user=request.user, person=Person.objects.get(pk=pk)
        ).delete()

        if deleted:
            messages.success(request, "Favourite removed")
        else:
            messages.error(request, "Error removing favourite")

        return redirect("person-detail", pk=pk)


@login_required
def unfavourite_organisation(request, pk):
    if request.method == "GET":

        try:
            organisation = Organisation.objects.get(pk=pk)
            sub = OrganisationSubscription.objects.get(
                user=request.user, organisation=organisation
            )
        except OrganisationSubscription.DoesNotExist:
            messages.warning(request, "Not a favourite")
            return redirect("organisation-detail", pk=pk)

        deleted, _ = OrganisationSubscription.objects.filter(
            user=request.user, organisation=Organisation.objects.get(pk=pk)
        ).delete()

        if deleted:
            messages.success(request, "Favourite removed")
        else:
            messages.error(request, "Error removing favourite")

        return redirect("organisation-detail", pk=pk)
