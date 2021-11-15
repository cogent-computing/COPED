from rest_framework import serializers
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project
from .external_link import ExternalLinkSerializer


###################
## Organisations ##
###################


class OrganisationProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ["url", "coped_id", "title"]


class OrganisationPersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["url", "coped_id", "full_name"]


class OrganisationSerializer(serializers.ModelSerializer):

    external_links = ExternalLinkSerializer(many=True)
    projects = OrganisationProjectSerializer(source="project_set", many=True)
    persons = OrganisationPersonSerializer(source="person_set", many=True)

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
