from haystack import indexes
from .models.project import Project


class ProjectIndex(indexes.SearchIndex, indexes.Indexable):
    text = indexes.CharField(document=True, use_template=True)
    # Include fields here for filtering etc. that are not needed in the index.

    def get_model(self):
        return Project

    def index_queryset(self, using=None):
        """Used when the entire index for model is updated.

        For example could use a model flag 'public' to include/exclude projects. See:
        https://django-haystack.readthedocs.io/en/master/tutorial.html#handling-data"""

        return super().index_queryset(using=using)