import json
from decimal import Decimal
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
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
from .models import Subject
from .models import User
from .models import EnergySearchTerm


# Define inlines for many-to-many relations


class ProjectOrganisationInline(admin.TabularInline):
    model = ProjectOrganisation
    extra = 0


class ProjectPersonInline(admin.TabularInline):
    model = ProjectPerson
    extra = 0


class ProjectSubjectInline(admin.TabularInline):
    model = Project.subjects.through
    readonly_fields = ("subject", "score")
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
    readonly_fields = (
        "organisation",
        "externallink",
    )  # note this uses the automatic django m2m fieldnames
    model = Organisation.external_links.through
    extra = 0


class OrganisationAddressesInline(admin.TabularInline):
    readonly_fields = ("organisation", "address")
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


class SubjectAdmin(admin.ModelAdmin):
    readonly_fields = ("external_link",)


@admin.action(description="Mark selected search terms as active")
def make_search_term_active(modeladmin, request, queryset):
    queryset.update(active=True)


@admin.action(description="Mark selected search terms as inactive")
def make_search_term_inactive(modeladmin, request, queryset):
    queryset.update(active=False)


class EnergySearchTermAdmin(admin.ModelAdmin):
    list_display = [
        "term",
        "active",
    ]
    ordering = [
        "term",
    ]
    search_fields = [
        "term",
    ]
    actions = [
        make_search_term_active,
        make_search_term_inactive,
    ]


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
                "fields": (
                    "coped_id",
                    "title",
                    "description",
                    "extra_text",
                    "status",
                )
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
    inlines = (ProjectSubjectInline,)


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
    readonly_fields = ("coped_id", "geo")
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


class UserAdminConfig(UserAdmin):
    model = User
    search_fields = (
        "email",
        "first_name",
    )
    list_filter = ("email", "first_name", "is_active", "is_staff")
    ordering = ("-date_joined",)
    list_display = ("email", "first_name", "is_active", "is_staff")
    fieldsets = (
        (None, {"fields": ("email", "first_name")}),
        ("Permissions", {"fields": ("is_staff", "is_active")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "first_name",
                    "last_name",
                    "password1",
                    "u_id",
                    "password2",
                    "is_active",
                    "is_staff",
                ),
            },
        ),
    )


admin.site.register(User, UserAdminConfig)

# Wire it all up


admin.site.register(Person, PersonAdmin)
admin.site.register(Project, ProjectAdmin)
admin.site.register(Organisation, OrganisationAdmin)
admin.site.register(EnergySearchTerm, EnergySearchTermAdmin)
admin.site.register(Permission)
# admin.site.register(User)
admin.site.register(RawData, RawDataAdmin)
admin.site.register(ExternalLink, ExternalLinkAdmin)
admin.site.register(Address, AddressAdmin)
admin.site.register(Subject, SubjectAdmin)
