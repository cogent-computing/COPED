from django_elasticsearch_dsl_drf.constants import (
    LOOKUP_FILTER_TERMS,
    LOOKUP_FILTER_RANGE,
    LOOKUP_FILTER_PREFIX,
    LOOKUP_FILTER_WILDCARD,
    LOOKUP_QUERY_IN,
    LOOKUP_QUERY_GT,
    LOOKUP_QUERY_GTE,
    LOOKUP_QUERY_LT,
    LOOKUP_QUERY_LTE,
    LOOKUP_QUERY_EXCLUDE,
)
from django_elasticsearch_dsl_drf.filter_backends import (
    FilteringFilterBackend,
    IdsFilterBackend,
    OrderingFilterBackend,
    DefaultOrderingFilterBackend,
    SearchFilterBackend,
)
from django_elasticsearch_dsl_drf.viewsets import BaseDocumentViewSet
from django_elasticsearch_dsl_drf.pagination import PageNumberPagination

from .documents import ProjectDocument
from .serializers import ProjectDocumentSerializer


class ProjectDocumentView(BaseDocumentViewSet):
    """Provides a list of projects matching the given search constraints."""

    document = ProjectDocument
    serializer_class = ProjectDocumentSerializer
    pagination_class = PageNumberPagination
    # lookup_field = "id"
    filter_backends = [
        FilteringFilterBackend,
        IdsFilterBackend,
        OrderingFilterBackend,
        DefaultOrderingFilterBackend,
        SearchFilterBackend,
    ]
    # Define search fields
    search_fields = (
        "title",
        "description",
    )
    # Define filter fields
    filter_fields = {
        "id": {
            "field": "id",
            # Note, that we limit the lookups of id field
            # to `range`, `in`, `gt`, `gte`, `lt` and `lte` filters.
            "lookups": [
                LOOKUP_FILTER_RANGE,
                LOOKUP_QUERY_IN,
                LOOKUP_QUERY_GT,
                LOOKUP_QUERY_GTE,
                LOOKUP_QUERY_LT,
                LOOKUP_QUERY_LTE,
            ],
        },
        "title": "title.raw",
        "description": "description.raw",
        "pages": {
            "field": "pages",
            # Note, that we limit the lookups of `pages` field
            # to `range`, `gt`, `gte`, `lt` and `lte` filters.
            "lookups": [
                LOOKUP_FILTER_RANGE,
                LOOKUP_QUERY_GT,
                LOOKUP_QUERY_GTE,
                LOOKUP_QUERY_LT,
                LOOKUP_QUERY_LTE,
            ],
        },
    }
    # Define ordering fields
    ordering_fields = {
        "title": "title.raw",
        "description": "description.raw",
    }
    # # Specify default ordering
    # ordering = (
    #     "title",
    #     "description",
    # )
