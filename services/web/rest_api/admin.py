from django.contrib import admin
from django.contrib.auth.models import Permission
from rest_api.models import (
    Person,
    Project,
    Organisation,
    ProjectOrganisation,
    ProjectPerson,
)

# Define inlines for many-to-many relations


class ProjectOrganisationInline(admin.TabularInline):
    model = ProjectOrganisation
    extra = 1


class ProjectPersonInline(admin.TabularInline):
    model = ProjectPerson
    extra = 1


class ProjectAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectOrganisationInline, ProjectPersonInline)


class OrganisationAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectOrganisationInline,)


class PersonAdmin(admin.ModelAdmin):
    readonly_fields = ("coped_id",)
    inlines = (ProjectPersonInline,)


admin.site.register(Person, PersonAdmin)
admin.site.register(Project, ProjectAdmin)
admin.site.register(Organisation, OrganisationAdmin)
admin.site.register(Permission)
