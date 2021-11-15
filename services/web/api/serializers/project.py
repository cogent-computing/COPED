from rest_framework import serializers
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project, ProjectFund
from .external_link import ExternalLinkSerializer


##############
## Projects ##
##############


class ProjectFundOrganisationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organisation
        fields = ["url", "coped_id", "name"]


class ProjectFundSerializer(serializers.ModelSerializer):
    organisation = ProjectFundOrganisationSerializer()

    class Meta:
        model = ProjectFund
        fields = ["organisation", "amount", "currency", "start_date", "end_date"]


class ProjectPersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["url", "coped_id", "full_name"]


class ProjectOrganisationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organisation
        fields = ["url", "coped_id", "name"]


class ProjectSerializer(serializers.ModelSerializer):

    external_links = ExternalLinkSerializer(many=True)
    organisations = ProjectOrganisationSerializer(many=True)
    persons = ProjectPersonSerializer(many=True)
    funds = ProjectFundSerializer(source="projectfund_set", many=True)

    class Meta:
        model = Project
        fields = [
            "url",
            "coped_id",
            "title",
            "description",
            "status",
            "funds",
            "persons",
            "organisations",
            "external_links",
        ]
