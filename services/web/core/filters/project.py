import django_filters
from elasticsearch_dsl import Q
from core.models import Project, Subject
from core.documents import ProjectDocument


class ProjectFilter(django_filters.FilterSet):

    YEAR_RANGE = range(2000, 2030)
    YEAR_CHOICES = list(zip(YEAR_RANGE, YEAR_RANGE))
    SUBJECT_CHOICES = [(s.id, s.label) for s in Subject.objects.all()]

    status = django_filters.ChoiceFilter(
        choices=(("Active", "Active"), ("Closed", "Closed"))
    )
    start_year = django_filters.MultipleChoiceFilter(
        choices=YEAR_CHOICES,
        field_name="filter_start_date",
        lookup_expr="year",
        label="Start Year(s)",
    )
    end_year = django_filters.MultipleChoiceFilter(
        choices=YEAR_CHOICES,
        field_name="filter_end_date",
        lookup_expr="year",
        label="End Year(s)",
    )
    funding_range = django_filters.RangeFilter(
        field_name="total_funding",
        label="Total Project Funding (£)",
    )
    search = django_filters.CharFilter(label="Search", method="search_query_filter")

    def search_query_filter(self, queryset, name, value):
        print(name)
        print(value)

        # Set up a search
        s = ProjectDocument.search()

        # Prefilter search to the current queryset
        qs_ids = (i for i in queryset.values_list("id", flat=True))
        s = s.query(ids=qs_ids)

        # Simple fixed filter query on a given field (used for dev/testing)
        # s = s.filter("match", title=value)

        # "Simple query string" query on multiple fields - complex search with relatively simple user-friendly syntax
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html#simple-query-string-syntax
        q = Q(
            "simple_query_string",
            query=value,
            fields=["title", "description", "extra_text"],
        )
        s = s.query(q)

        # Search across multiple fields
        # q = Q("multi_match", query=value, fields=["title", "description", "extra_text"])
        # s = s.query(q)

        # FIXME: for searches with over 10K results the following won't work unless configured with pagination
        # Also the number of results is order-of-filter-application dependent, since a reduced initial queryset reduces search results too.
        # Override the default number of returned items (10) to the max (10000)
        s = s.extra(size=10000)

        # TODO: allow toggling the keep_order setting:
        # True=>order-by-relevance (slow), False=>sort-by-FilterSet-settings (fast)

        scores = [hit.meta.score for hit in s.execute()]
        print(scores)

        # TODO: optimise the score threshold and/or bring it from a config setting or form
        result_ids = [hit.meta.id for hit in s.execute() if hit.meta.score > 5]
        return queryset.filter(id__in=result_ids)

    class Meta:
        model = Project
        fields = [
            "status",
            "start_year",
            "end_year",
            "funding_range",
            "search",
        ]

    @property
    def qs(self):
        # override the queryset that initialises the filter if required.
        # For example use the request object to filter based on a search lookup
        qs = super().qs
        return qs

    # TODO: consider a range filter for date lookups as below
    # def filter_start_year_range(self, queryset, name, value):
    #     # Value from a RangeFilter is a Python slice
    #     lookup_min = "__".join([name, "year", "gte"])
    #     lookup_max = "__".join([name, "year", "lte"])
    #     # TODO: check for min or max lookup being None
    #     return queryset.filter(**{lookup_min: value.start, lookup_max: value.stop})
    # start_year = django_filters.RangeFilter(
    #     label="Start Year",
    #     field_name="filter_start_date",
    #     method="filter_start_year_range",
    # )
