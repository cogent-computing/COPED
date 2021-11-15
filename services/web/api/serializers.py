from rest_framework import serializers
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.project import Project
from core.models.external_link import ExternalLink


class DynamicFieldsModelSerializer(serializers.ModelSerializer):
    """
    A ModelSerializer that takes an additional `fields` argument that
    controls which fields should be displayed.

    https://www.django-rest-framework.org/api-guide/serializers/#dynamically-modifying-fields
    """

    def __init__(self, *args, **kwargs):
        # Don't pass the 'fields' arg up to the superclass
        fields = kwargs.pop("fields", None)

        # Instantiate the superclass normally
        super(DynamicFieldsModelSerializer, self).__init__(*args, **kwargs)

        if fields is not None:
            # Drop any fields that are not specified in the `fields` argument.
            allowed = set(fields)
            existing = set(self.fields)
            for field_name in existing - allowed:
                self.fields.pop(field_name)


class ExternalLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExternalLink
        fields = ["link", "description"]


class OrganisationSerializer(DynamicFieldsModelSerializer):
    external_links = ExternalLinkSerializer(many=True)

    class Meta:
        model = Organisation
        fields = [
            "url",
            "coped_id",
            "name",
            "address",
            "about",
            "external_links",
        ]


class PersonSerializer(DynamicFieldsModelSerializer):
    external_links = ExternalLinkSerializer(many=True)

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
        ]


class ProjectSerializer(serializers.ModelSerializer):
    external_links = ExternalLinkSerializer(many=True)

    organisations = OrganisationSerializer(
        many=True, read_only=True, fields=("url", "coped_id", "name")
    )
    persons = PersonSerializer(
        many=True, read_only=True, fields=("url", "coped_id", "first_name", "last_name")
    )

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
