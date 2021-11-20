import json
from decimal import Decimal
from django.contrib import admin
from django.contrib.auth.models import Permission
from django.db.models.aggregates import Sum
from django.utils.safestring import mark_safe
from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import HtmlFormatter
from .models.person import Person
from .models.organisation import Organisation
from .models.project import Project, ProjectOrganisation, ProjectPerson, ProjectFund
from .models.raw_data import RawData
from .models.external_link import ExternalLink
from .models.address import Address


# Define inlines for many-to-many relations


class ProjectOrganisationInline(admin.TabularInline):
    model = ProjectOrganisation
    extra = 0


class ProjectPersonInline(admin.TabularInline):
    model = ProjectPerson
    extra = 0


class ProjectFundInline(admin.TabularInline):
    model = ProjectFund
    extra = 0


class PersonExternalLinksInline(admin.TabularInline):
    model = Person.external_links.through
    extra = 0


class PersonOrganisationInline(admin.TabularInline):
    model = Person.organisations.through
    extra = 0


class ProjectExternalLinksInline(admin.TabularInline):
    model = Project.external_links.through
    extra = 0


class OrganisationExternalLinksInline(admin.TabularInline):
    model = Organisation.external_links.through
    extra = 0


class OrganisationAddressesInline(admin.TabularInline):
    model = Organisation.addresses.through
    extra = 0


# Define the model admins themselves


class ProjectTotalFundingFilter(admin.SimpleListFilter):
    title = "Total Funding"
    parameter_name = "total_funding"

    def lookups(self, request, model_admin):
        return [
            ("0-10000", "0-10K"),
            ("10000-25000", "10K-25K"),
            ("25000-50000", "25K-50K"),
            ("50000-100000", "50K-100K"),
            ("100000-250000", "100K-250K"),
            ("250000-500000", "250K-500K"),
            ("500000-1000000", "500K-1M"),
            ("1000000-2500000", "1M-2.5M"),
            ("2500000-5000000", "2.5M-5M"),
            ("5000000-10000000", "5M-10M"),
            ("10000000-Inf", ">10M"),
        ]

    def queryset(self, request, queryset):
        if self.value():
            low, high = self.value().split("-")
            low, high = Decimal(low), Decimal(high)
            return (
                queryset.annotate(all_funding=Sum("projectfund__amount"))
                .filter(all_funding__gte=low)
                .filter(all_funding__lte=high)
            )
        else:
            return queryset


class ProjectAdmin(admin.ModelAdmin):
    readonly_fields = (
        "coped_id",
        "raw_data",
        "external_links",
        "funds",
        "persons",
        "organisations",
    )
    list_display = ("coped_id", "title", "status", "start", "end")
    # inlines = (ProjectOrganisationInline, ProjectPersonInline, ProjectFundInline)
    list_filter = ("status", "start", ProjectTotalFundingFilter)
    fieldsets = (
        (
            None,
            {
                "fields": ("coped_id", "title", "description", "extra_text", "status"),
            },
        ),
        (
            "DATES AND LINKS",
            {
                "fields": (("start", "end"), "external_links"),
            },
        ),
        (
            "CONNECTIONS",
            {
                "fields": ("funds", "persons", "organisations"),
            },
        ),
    )


class OrganisationAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data")
    exclude = ("addresses", "external_links")
    inlines = (OrganisationAddressesInline, OrganisationExternalLinksInline)


class PersonAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")
    inlines = (PersonOrganisationInline,)


class FundAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")
    inlines = (ProjectFundInline,)


class ExternalLinkAdmin(admin.ModelAdmin):
    inlines = (
        PersonExternalLinksInline,
        ProjectExternalLinksInline,
        OrganisationExternalLinksInline,
    )


class AddressAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (OrganisationAddressesInline,)


class RawDataAdmin(admin.ModelAdmin):
    readonly_fields = ("bot", "url", "data_prettified")
    exclude = ("json",)

    def data_prettified(self, instance):
        """Function to display pretty version of our raw JSON data"""

        # Convert the data to sorted, indented JSON
        response = json.dumps(instance.json, sort_keys=True, indent=2)

        # Truncate the data. Alter as needed
        response = response[:10000]

        # Get the Pygments formatter
        formatter = HtmlFormatter(style="colorful")

        # Highlight the data
        response = highlight(response, JsonLexer(), formatter)

        # Get the stylesheet
        style = "<style>" + formatter.get_style_defs() + "</style><br>"

        # Safe the output
        return mark_safe(style + response)

    data_prettified.short_description = "JSON"


# Wire it all up


admin.site.register(Person, PersonAdmin)
admin.site.register(Project, ProjectAdmin)
admin.site.register(Organisation, OrganisationAdmin)
admin.site.register(Permission)
admin.site.register(RawData, RawDataAdmin)
admin.site.register(ExternalLink, ExternalLinkAdmin)
admin.site.register(Address, AddressAdmin)
