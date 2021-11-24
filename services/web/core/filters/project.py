import django_filters
from core.models import Project


class ProjectFilter(django_filters.FilterSet):

    status = django_filters.ChoiceFilter(
        choices=(("Active", "Active"), ("Closed", "Closed"))
    )

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
    YEAR_RANGE = range(2000, 2030)
    YEAR_CHOICES = list(zip(YEAR_RANGE, YEAR_RANGE))
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

    class Meta:
        model = Project
        fields = ["status", "subjects"]

    @property
    def qs(self):
        # override the queryset that initialises the filter
        # for example use the request object to filter based on a search lookup
        qs = super().qs
        return qs
