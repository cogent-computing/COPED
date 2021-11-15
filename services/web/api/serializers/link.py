from rest_framework import serializers
from core.models.external_link import ExternalLink
from core.models.project import Project
from core.models.person import Person
from core.models.organisation import Organisation


class ExternalLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExternalLink
        fields = ["link", "description"]


class LinkedProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ["url", "coped_id", "title"]


class LinkedPersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["url", "coped_id", "full_name"]


class LinkedOrganisationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organisation
        fields = ["url", "coped_id", "name"]
