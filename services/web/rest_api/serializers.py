from rest_framework import serializers
from rest_api.models import Organisation, Person, Project


class OrganisationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organisation
        fields = ["id", "name", "address", "about"]


class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["id", "first_name", "last_name", "organisation", "about"]


class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = [
            "id",
            "title",
            "status",
            "funder",
            "amount",
            "start_date",
            "end_date",
            "description",
            "persons",
            "organisations",
        ]
