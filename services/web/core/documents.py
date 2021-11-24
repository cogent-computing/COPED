from django_elasticsearch_dsl import Document
from django_elasticsearch_dsl import fields
from django_elasticsearch_dsl.registries import registry
from .models import Project
from .models import Subject


@registry.register_document
class ProjectDocument(Document):

    # Access subject terms using a nested query as follows.
    # ProjectDocument.search().query("nested", path="subjects", query={"term": {"subjects.label": "algae"}})
    subjects = fields.NestedField(properties={"label": fields.KeywordField()})

    class Index:
        # Name of the Elasticsearch index
        name = "coped_project"
        # See Elasticsearch Indices API reference for available settings
        settings = {"number_of_shards": 1, "number_of_replicas": 0}

    class Django:
        model = Project  # The model associated with this Document

        # The fields of the model you want to be indexed in Elasticsearch
        fields = ["title", "description", "extra_text"]

        # Ignore auto updating of Elasticsearch when a model is saved
        # or deleted:
        # ignore_signals = True

        # Don't perform an index refresh after every update (overrides global setting):
        # auto_refresh = False

        # Paginate the django queryset used to populate the index with the specified size
        # (by default it uses the database driver's default setting)
        # queryset_pagination = 5000

        related_models = [Subject]

        def prepare_subjects(self, instance):
            # See https://github.com/django-es/django-elasticsearch-dsl/issues/307
            projectsubjects = instance.projectsubject_set.all()
            return [projectsubject.subject.label for projectsubject in projectsubjects]

    def get_instances_from_related(self, related_instance):
        if isinstance(related_instance, Subject):
            projectsubjects = related_instance.projectsubject_set.all()
            return [projectsubject.project for projectsubject in projectsubjects]
