from rest_framework import serializers
from core.models.organisation import Organisation
from .link import ExternalLinkSerializer
from .link import LinkedPersonSerializer
from .link import LinkedProjectSerializer


class OrganisationSerializer(serializers.ModelSerializer):

    external_links = ExternalLinkSerializer(many=True)
    projects = LinkedProjectSerializer(source="project_set", many=True)
    persons = LinkedPersonSerializer(source="person_set", many=True)

    class Meta:
        model = Organisation
        fields = [
            "url",
            "coped_id",
            "name",
            "address",
            "about",
            "external_links",
            "projects",
            "persons",
        ]
