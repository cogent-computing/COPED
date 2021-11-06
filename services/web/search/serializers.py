import json

from rest_framework import serializers
from django_elasticsearch_dsl_drf.serializers import DocumentSerializer

from search.documents import ProjectDocument


class ProjectDocumentSerializer(DocumentSerializer):
    """Serializer for the Project document."""

    class Meta:
        # Specify the correspondent document class
        document = ProjectDocument

        # List the serializer fields. Note, that the order of the fields
        # is preserved in the ViewSet.
        fields = (
            "title",
            "description",
        )
