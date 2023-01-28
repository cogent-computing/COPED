from rest_framework import serializers
from core.models.organisation import Organisation
from .link import ExternalLinkSerializer
from .link import LinkedPersonSerializer
from .link import LinkedProjectSerializer


class OrganisationSerializer(serializers.HyperlinkedModelSerializer):

    external_links = ExternalLinkSerializer(many=True)
    projects = LinkedProjectSerializer(source="project_set", many=True)
    persons = LinkedPersonSerializer(source="person_set", many=True)
    url = serializers.HyperlinkedIdentityField(view_name='api-organisation-detail', format='json')

    class Meta:
        model = Organisation
        fields = [
            "url",
            "coped_id",
            "name",
            "about",
            "external_links",
            "projects",
            "persons",
        ]
