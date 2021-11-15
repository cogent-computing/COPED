from rest_framework import serializers
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project
from .link import ExternalLinkSerializer, LinkedOrganisationSerializer
from .link import LinkedProjectSerializer
from .link import LinkedOrganisationSerializer


class PersonSerializer(serializers.ModelSerializer):
    external_links = ExternalLinkSerializer(many=True)
    organisations = LinkedOrganisationSerializer(many=True)
    projects = LinkedProjectSerializer(source="project_set", many=True)

    class Meta:
        model = Person
        fields = [
            "url",
            "coped_id",
            "email",
            "first_name",
            "other_name",
            "last_name",
            "orcid_id",
            "external_links",
            "organisations",
            "projects",
        ]
