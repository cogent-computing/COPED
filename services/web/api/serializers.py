from rest_framework import serializers
from core.models import Organisation, Person, Project, Fund


class OrganisationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organisation
        fields = ["id", "coped_id", "name", "address", "about"]


class FundSerializer(serializers.ModelSerializer):
    class Meta:
        model = Fund
        fields = ["id", "coped_id", "title", "about", "organisation"]


class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["id", "coped_id", "first_name", "last_name", "organisation", "about"]


class ProjectSerializer(serializers.ModelSerializer):
    funds = FundSerializer(many=True)
    persons = PersonSerializer(many=True)
    organisations = OrganisationSerializer(many=True)

    class Meta:
        model = Project
        fields = [
            "id",
            "coped_id",
            "title",
            "description",
            "status",
            "funds",
            "persons",
            "organisations",
        ]
