from rest_framework import serializers
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project, ProjectFund
from .link import ExternalLinkSerializer
from .link import LinkedPersonSerializer
from .link import LinkedOrganisationSerializer


class FundSerializer(serializers.ModelSerializer):
    organisation = LinkedOrganisationSerializer()

    class Meta:
        # Use the through model of the many-to-many `funds`
        # relation to access the funding data .
        model = ProjectFund
        fields = ["organisation", "amount", "currency", "start_date", "end_date"]


class ProjectSerializer(serializers.ModelSerializer):

    external_links = ExternalLinkSerializer(many=True)
    organisations = LinkedOrganisationSerializer(many=True)
    persons = LinkedPersonSerializer(many=True)

    # Specify a through model record set using the `source` argument.
    funds = FundSerializer(source="projectfund_set", many=True)

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
