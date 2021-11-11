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


class PersonExternalLinkInline(admin.TabularInline):
    model = Person.external_links.through
    extra = 1


class OrganisationExternalLinkInline(admin.TabularInline):
    model = Organisation.external_links.through
    extra = 1


# Define the model admins themselves


class ProjectAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectOrganisationInline, ProjectPersonInline, ProjectFundInline)


class OrganisationAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    exclude = ("external_links",)
    inlines = (ProjectOrganisationInline, OrganisationExternalLinkInline)


class PersonAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    exclude = ("external_links", "raw_data")
    inlines = (ProjectPersonInline, PersonExternalLinkInline)


class FundAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectFundInline,)


class RawDataAdmin(admin.ModelAdmin):
    readonly_fields = ("data_prettified",)

    def data_prettified(self, instance):
        """Function to display pretty version of our raw JSON data"""

        # Convert the data to sorted, indented JSON
        response = json.dumps(instance.json, sort_keys=True, indent=2)

        # Truncate the data. Alter as needed
        response = response[:5000]

        # Get the Pygments formatter
        formatter = HtmlFormatter(style="colorful")

        # Highlight the data
        response = highlight(response, JsonLexer(), formatter)

        # Get the stylesheet
        style = "<style>" + formatter.get_style_defs() + "</style><br>"

        # Safe the output
        return mark_safe(style + response)

    data_prettified.short_description = "JSON Prettified"


# Wire it all up


admin.site.register(Person, PersonAdmin)
admin.site.register(Project, ProjectAdmin)
admin.site.register(Organisation, OrganisationAdmin)
admin.site.register(Fund, FundAdmin)
admin.site.register(Permission)
admin.site.register(RawData, RawDataAdmin)
