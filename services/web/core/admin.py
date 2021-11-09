from django.contrib import admin
from django.contrib.auth.models import Permission
from core.models.fund import Fund
from core.models.person import Person
from core.models.organisation import Organisation
from core.models.project import Project, ProjectOrganisation, ProjectPerson, ProjectFund

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


class ProjectAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectOrganisationInline, ProjectPersonInline, ProjectFundInline)


class OrganisationAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectOrganisationInline,)


class PersonAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectPersonInline,)


class FundAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectFundInline,)


admin.site.register(Person, PersonAdmin)
admin.site.register(Project, ProjectAdmin)
admin.site.register(Organisation, OrganisationAdmin)
admin.site.register(Fund, FundAdmin)
admin.site.register(Permission)
