from rest_framework import serializers
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project
from .external_link import ExternalLinkSerializer


############
## People ##
############


class PersonProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ["url", "coped_id", "title"]


class PersonOrganisationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organisation
        fields = ["url", "coped_id", "name"]


class PersonSerializer(serializers.ModelSerializer):
    external_links = ExternalLinkSerializer(many=True)
    projects = PersonProjectSerializer(source="project_set", many=True)
    organisations = PersonOrganisationSerializer(many=True)

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
