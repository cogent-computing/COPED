from django.conf import settings
from django_elasticsearch_dsl import Document, Index, fields
from elasticsearch_dsl import analyzer

from core.models import Project

# Name of the Elasticsearch index
# INDEX = Index(settings.ELASTICSEARCH_INDEX_NAMES[__name__])
INDEX = Index("project")

# See Elasticsearch Indices API reference for available settings
INDEX.settings(number_of_shards=1, number_of_replicas=1)

# Custom analyser
html_strip = analyzer(
    "html_strip",
    tokenizer="standard",
    filter=["lowercase", "stop", "snowball"],
    char_filter=["html_strip"],
)

# Document mapping
@INDEX.doc_type
class ProjectDocument(Document):
    """Project Elasticsearch document."""

    id = fields.IntegerField(attr="id")

    title = fields.TextField(
        analyzer=html_strip,
        fields={
            "raw": fields.TextField(analyzer="keyword"),
        },
    )

    description = fields.TextField(
        analyzer=html_strip,
        fields={
            "raw": fields.TextField(analyzer="keyword"),
        },
    )

    class Django(object):
        """Inner nested class Django."""

        model = Project  # The core model associated with this Document
