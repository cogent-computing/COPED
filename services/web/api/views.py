from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project
from core.models.fund import Fund
from api.serializers import (
    OrganisationSerializer,
    PersonSerializer,
    FundSerializer,
    ProjectSerializer,
)
from rest_framework import generics
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse


@api_view(["GET"])
def api_root(request, format=None):
    return Response(
        {
            "projects": reverse("project-list", request=request, format=format),
            "organisations": reverse(
                "organisation-list", request=request, format=format
            ),
            "persons": reverse("person-list", request=request, format=format),
            "funds": reverse("fund-list", request=request, format=format),
        }
    )


class OrganisationList(generics.ListCreateAPIView):
    queryset = Organisation.objects.all()
    serializer_class = OrganisationSerializer


class OrganisationDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Organisation.objects.all()
    serializer_class = OrganisationSerializer


class PersonList(generics.ListCreateAPIView):
    queryset = Person.objects.all()
    serializer_class = PersonSerializer


class PersonDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Person.objects.all()
    serializer_class = PersonSerializer


class FundList(generics.ListCreateAPIView):
    queryset = Fund.objects.all()
    serializer_class = FundSerializer


class FundDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Fund.objects.all()
    serializer_class = FundSerializer


class ProjectList(generics.ListCreateAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer


class ProjectDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer
