from django_elasticsearch_dsl import Document
from django_elasticsearch_dsl.registries import registry
from core.models import Project


@registry.register_document
class ProjectDocument(Document):
    """Elasticsearch mapping for project documents."""

    class Index:
        name = "project"
        settings = {"number_of_shards": 1, "number_of_replicas": 0}

    class Django(object):

        model = Project  # The core model associated with this Document
        fields = [
            "title",
            "description",
        ]
