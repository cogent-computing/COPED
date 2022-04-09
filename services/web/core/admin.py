import json
from decimal import Decimal
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import Permission
from django.db.models.aggregates import Sum
from django.urls import reverse
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
from .models import AppSetting


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


@admin.action(description="Mark selected subject(s) as energy-related")
def mark_subject_energy_related(modeladmin, request, queryset):
    queryset.update(energy_related=True)


@admin.action(description="Mark selected subject(s) as NOT energy-related")
def mark_subject_not_energy_related(modeladmin, request, queryset):
    queryset.update(energy_related=False)


class SubjectAdmin(admin.ModelAdmin):
    list_display = ["label", "energy_related"]
    ordering = [
        "label",
    ]
    search_fields = ["label"]
    readonly_fields = ("external_link",)
    actions = [
        mark_subject_energy_related,
        mark_subject_not_energy_related,
    ]


class AppSettingAdmin(admin.ModelAdmin):
    list_display = ["name", "slug", "value", "description"]
    ordering = ["name"]


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

    def raw_data(self, obj):
        return mark_safe(
            "<a href='{}'>{}</a>".format(
                reverse("admin:auth_raw_data_change", args=(obj.raw_data.pk,)),
                obj.raw_data.pk,
            )
        )

    search_fields = ("title",)
    search_help_text = "Search for project by title"
    list_display = ("title", "status", "start", "end", "is_locked")
    list_filter = ("status", "start", "end", "is_locked")
    fieldsets = (
        (
            None,
            {
                "fields": (
                    "owner",
                    "is_locked",
                    "raw_data",
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


class OrganisationAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data")
    list_display = ("name", "is_locked")
    exclude = ("addresses", "external_links")
    inlines = (OrganisationAddressesInline, OrganisationExternalLinksInline)


class PersonAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")
    list_display = ("first_name", "last_name", "is_locked")
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
    readonly_fields = ("bot", "created", "modified", "url", "data_prettified")
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

    def get_readonly_fields(self, request, obj=None):
        readonly_fields = super().get_readonly_fields(request, obj)
        if obj:  # editing an existing object
            return readonly_fields + ("email",)
        return readonly_fields

    search_fields = (
        "username",
        "email",
        "first_name",
        "last_name",
    )
    list_filter = (
        "is_active",
        "is_staff",
        "is_contributor",
        "date_joined",
        "last_login",
    )
    ordering = ("username",)
    list_display = (
        "username",
        "email",
        "first_name",
        "last_name",
        "date_joined",
        "last_login",
        "is_active",
        "is_staff",
        "is_contributor",
    )
    fieldsets = (
        (
            None,
            {
                "fields": ("email", "first_name", "last_name"),
            },
        ),
        ("Permissions", {"fields": ("is_staff", "is_active", "is_contributor")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "username",
                    "email",
                    "first_name",
                    "last_name",
                    "password1",
                    "password2",
                    "is_active",
                    "is_staff",
                    "is_contributor",
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
admin.site.register(AppSetting, AppSettingAdmin)
