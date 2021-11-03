from django.db import models
from django.utils.translation import gettext_lazy as _
from uuid import uuid4


class Organisation(models.Model):
    """Organisations managed by CoPED"""

    coped_id = models.UUIDField(
        default=str(uuid4()).upper(),
        editable=False,
        verbose_name="CoPED ID",
    )
    name = models.CharField(max_length=128)
    address = models.CharField(max_length=128, blank=True)
    about = models.TextField(blank=True)

    class Meta:
        db_table = "coped_organisation"

    def __str__(self):
        return self.name


class Person(models.Model):
    """Persons managed by CoPED"""

    coped_id = models.UUIDField(
        default=str(uuid4()).upper(), editable=False, verbose_name="CoPED ID"
    )
    first_name = models.CharField(max_length=128)
    last_name = models.CharField(max_length=128)
    email = models.EmailField(null=True, blank=True)
    organisation = models.ForeignKey(
        Organisation, null=True, blank=True, on_delete=models.SET_NULL
    )
    about = models.TextField(blank=True)

    class Meta:
        db_table = "coped_person"

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class Project(models.Model):
    """Projects managed by CoPED"""

    coped_id = models.UUIDField(
        default=str(uuid4()).upper(), editable=False, verbose_name="CoPED ID"
    )
    title = models.CharField(max_length=256)
    status = models.CharField(max_length=128, blank=True)
    funder = models.ForeignKey(
        Organisation,
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name="funder",
    )
    amount = models.DecimalField(null=True, blank=True, decimal_places=2, max_digits=12)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    description = models.TextField(blank=True)
    persons = models.ManyToManyField(
        Person, through="ProjectPerson", through_fields=("project", "person")
    )
    organisations = models.ManyToManyField(
        Organisation,
        through="ProjectOrganisation",
        through_fields=("project", "organisation"),
    )

    class Meta:
        db_table = "coped_project"

    def __str__(self):
        return self.title


class ProjectOrganisation(models.Model):
    """Through model for organisations related to projects."""

    class Role(models.TextChoices):
        LEAD = "LEAD", _("Lead Organisation")
        PARTNER = "PARTNER", _("Partner Organisation")
        PARTICIPANT = "PARTICIPANT", _("Participant Organisation")

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    organisation = models.ForeignKey(Organisation, on_delete=models.CASCADE)
    role = models.CharField(max_length=16, choices=Role.choices, default=Role.LEAD)

    class Meta:
        db_table = "coped_project_organisation"

    def __str__(self):
        return self.role


class ProjectPerson(models.Model):
    """Through model for persons related to projects."""

    class RelationType(models.TextChoices):
        LEAD = "LEAD", _("Project Lead")
        PARTNER = "PARTNER", _("Project Partner or Co-Investigator")
        PARTICIPANT = "PARTICIPANT", _("Other Project Participant")

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    role = models.CharField(
        max_length=16, choices=RelationType.choices, default=RelationType.LEAD
    )

    class Meta:
        db_table = "coped_project_person"
        verbose_name_plural = "People"

    def __str__(self):
        return self.role
