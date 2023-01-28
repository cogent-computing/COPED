from rest_framework import serializers
from core.models.external_link import ExternalLink
from core.models.project import Project
from core.models.project import ProjectFund
from core.models.person import Person
from core.models.organisation import Organisation
from core.models.subject import Subject


class ExternalLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExternalLink
        fields = ["link", "description"]


class LinkedSubjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subject
        fields = ["label"]


class LinkedProjectSerializer(serializers.HyperlinkedModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name='api-project-detail', format='json')
    class Meta:
        model = Project
        fields = ["url", "coped_id", "title"]


class LinkedPersonSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name='api-person-detail', format='json')
    class Meta:
        model = Person
        fields = ["url", "coped_id", "full_name"]


class LinkedOrganisationSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name='api-organisation-detail', format='json')
    class Meta:
        model = Organisation
        fields = ["url", "coped_id", "name"]


class LinkedFundSerializer(serializers.ModelSerializer):
    organisation = LinkedOrganisationSerializer()

    class Meta:
        # Use the through model of the many-to-many `funds`
        # relation to access the funding data .
        model = ProjectFund
        fields = ["organisation", "amount", "start_date", "end_date"]
