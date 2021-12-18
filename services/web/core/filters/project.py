import django_filters
from django import forms
from elasticsearch_dsl import Q
from core.models import Project
from core.documents import ProjectDocument
from elasticsearch_dsl.query import MoreLikeThis


class ProjectFilter(django_filters.FilterSet):

    YEAR_RANGE = range(2000, 2030)
    YEAR_CHOICES = list(zip(YEAR_RANGE, YEAR_RANGE))

    status = django_filters.ChoiceFilter(
        choices=(("Active", "Active"), ("Closed", "Closed")),
        widget=forms.Select(attrs={"class": "form-control"}),
    )
    start_year = django_filters.MultipleChoiceFilter(
        choices=YEAR_CHOICES,
        field_name="filter_start_date",
        lookup_expr="year",
        label="Start Year(s)",
        widget=forms.SelectMultiple(attrs={"class": "form-control"}),
    )
    end_year = django_filters.MultipleChoiceFilter(
        choices=YEAR_CHOICES,
        field_name="filter_end_date",
        lookup_expr="year",
        label="End Year(s)",
        widget=forms.SelectMultiple(attrs={"class": "form-control"}),
    )
    funding_minimum = django_filters.NumberFilter(
        field_name="total_funding",
        lookup_expr="gte",
        label="Minimum Project Funding (£)",
        widget=forms.TextInput(attrs={"class": "form-control"}),
    )
    funding_maximum = django_filters.NumberFilter(
        field_name="total_funding",
        lookup_expr="lte",
        label="Maximum Project Funding (£)",
        widget=forms.TextInput(attrs={"class": "form-control"}),
    )
    search = django_filters.CharFilter(
        label="Search Term(s)",
        method="search_query_filter",
        widget=forms.TextInput(
            # set up advanced autocomplete for bootstrap autocomplete
            # see https://bootstrap-autocomplete.readthedocs.io/en/latest/
            attrs={
                "class": "form-control advancedAutoCompleteProject",
                "autocomplete": "off",
            }
        ),
    )
    o = django_filters.OrderingFilter(
        label="Sort By",
        fields=("title", "total_funding", "filter_start_date", "filter_end_date"),
        field_labels={
            "title": "Project Title",
            "total_funding": "Total Funding",
            "filter_start_date": "Start Date",
            "filter_end_date": "End Date",
        },
    )
    mlt = django_filters.CharFilter(
        widget=forms.HiddenInput(), method="more_like_this_filter"
    )

    def more_like_this_filter(self, queryset, name, value):
        print("MORE LIKE THIS filter")
        print(name)
        print(value)
        more_like_this = int(value)
        s = ProjectDocument.search()
        s = s.query(
            MoreLikeThis(
                like={"_id": more_like_this},
                fields=["title", "description", "extra_text"],
            )
        )
        # TODO: think about thresholding on the result scores
        s = s.extra(size=100)
        qs = s.to_queryset()
        return queryset.filter(id__in=qs)

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

        # "Simple query string" query on multiple fields - complex search with relatively simple user-friendly syntax.
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html#simple-query-string-syntax
        q = Q(
            "simple_query_string",
            query=value,
            fields=["title", "description", "extra_text"],
        )
        # Also query for fuzzy matches on the subject titles to get thematic matches.
        q2 = Q(
            "nested",
            path="subjects",
            query={"fuzzy": {"subjects.label": value}},
        )
        # Do an OR search combining the two queries above.
        s = s.query(q | q2)

        # FIXME: for searches with over 10K results the following won't work well, unless configured with pagination.
        # Also the number of results is order-of-filter-application dependent, since a reduced initial queryset reduces search results too.
        # Override the default number of returned items (10) to the max (10000)
        s = s.extra(size=10000)

        results = s.execute()
        scores = [hit.meta.score for hit in results]
        print(scores)

        # TODO: optimise the score threshold and/or bring it from a config setting or form
        result_ids = [hit.meta.id for hit in s.execute() if hit.meta.score > 5]
        return queryset.filter(id__in=result_ids)

    class Meta:
        model = Project
        fields = [
            "search",
            "status",
            "start_year",
            "end_year",
            "funding_minimum",
            "funding_maximum",
        ]
