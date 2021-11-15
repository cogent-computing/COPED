from haystack import indexes
from .models.project import Project


class ProjectIndex(indexes.SearchIndex, indexes.Indexable):
    text = indexes.CharField(document=True, use_template=True)
    title = indexes.CharField(model_attr="title")
    description = indexes.CharField(model_attr="description")

    def get_model(self):
        return Project

    def index_queryset(self, using=None):
        """Used when the entire index for model is updated.

        For example could use a model flag 'public' to include/exclude projects. See:
        https://django-haystack.readthedocs.io/en/master/tutorial.html#handling-data"""

        return super().index_queryset(using=using)
