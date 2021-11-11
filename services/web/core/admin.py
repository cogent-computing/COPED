import json
from django.contrib import admin
from django.contrib.auth.models import Permission
from django.utils.safestring import mark_safe
from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import HtmlFormatter
from .models.fund import Fund
from .models.person import Person
from .models.organisation import Organisation
from .models.project import Project, ProjectOrganisation, ProjectPerson, ProjectFund
from .models.raw_data import RawData
from .models.external_link import ExternalLink


# Define inlines for many-to-many relations


class ProjectOrganisationInline(admin.TabularInline):
    model = ProjectOrganisation
    extra = 1


class ProjectPersonInline(admin.TabularInline):
    model = ProjectPerson
    extra = 1


class ProjectFundInline(admin.TabularInline):
    model = ProjectFund
    extra = 1


class PersonExternalLinksInline(admin.TabularInline):
    model = Person.external_links.through
    extra = 0


class ProjectExternalLinksInline(admin.TabularInline):
    model = Project.external_links.through
    extra = 0


class FundExternalLinksInline(admin.TabularInline):
    model = Fund.external_links.through
    extra = 0


class OrganisationExternalLinksInline(admin.TabularInline):
    model = Organisation.external_links.through
    extra = 0


# Define the model admins themselves


class ProjectAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")
    inlines = (ProjectOrganisationInline, ProjectPersonInline, ProjectFundInline)


class OrganisationAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")


class PersonAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")


class FundAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id", "raw_data", "external_links")
    inlines = (ProjectFundInline,)


class ExternalLinkAdmin(admin.ModelAdmin):
    inlines = (
        PersonExternalLinksInline,
        ProjectExternalLinksInline,
        FundExternalLinksInline,
        OrganisationExternalLinksInline,
    )


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
admin.site.register(Fund, FundAdmin)
admin.site.register(Permission)
admin.site.register(RawData, RawDataAdmin)
admin.site.register(ExternalLink, ExternalLinkAdmin)
