from rest_framework import generics
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project

from .serializers.organisation import OrganisationSerializer
from .serializers.person import PersonSerializer
from .serializers.project import ProjectSerializer


@api_view(["GET"])
def api_root(request, format=None):
    return Response(
        {
            "projects": reverse("api-project-list", request=request, format=format),
            "organisations": reverse(
                "api-organisation-list", request=request, format=format
            ),
            "persons": reverse("api-person-list", request=request, format=format),
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


class ProjectList(generics.ListCreateAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer


class ProjectDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer
