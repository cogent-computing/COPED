from haystack import indexes
from core.models.project import Project


class ProjectIndex(indexes.SearchIndex, indexes.Indexable):
    text = indexes.CharField(
        document=True,
        use_template=True,
        template_name="search/indexes/project_text.txt",
    )
    # Include fields here for filtering etc. that are not needed in the index.
    title = indexes.CharField(model_attr="title")
    status = indexes.CharField(model_attr="status", null=True)
    start = indexes.DateField(model_attr="search_start", null=True)
    end = indexes.DateField(model_attr="search_end", null=True)

    # Autocomplete fields
    title_auto = indexes.EdgeNgramField(model_attr="title")

    def get_model(self):
        return Project

    def index_queryset(self, using=None):
        """Used when the entire index for model is updated.

        For example could use a model flag 'public' to include/exclude projects. See:
        https://django-haystack.readthedocs.io/en/master/tutorial.html#handling-data"""

        return super().index_queryset(using=using)
