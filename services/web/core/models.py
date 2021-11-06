"""Models for CoPED's primary resource types and their relations.

TODO:
    - A separate table of URL links for orgs, people, funds and projects.
    - Proper geographic data types for orgs, funds, and projects.
    - Integrate additional fields for text that does not fall into the current schema.
"""

from django.db import models
from django.utils.translation import gettext_lazy as _
from uuid import uuid4


##########################################
## Primary CoPED-managed resource types ##
##########################################


class Organisation(models.Model):
    """Organisations managed by CoPED.

    Organisations may be funders, project leaders or partners, employers
    of project participants, and so on."""

    coped_id = models.UUIDField(
        default=str(uuid4()),
        editable=False,
        verbose_name="CoPED ID",
    )
    name = models.CharField(max_length=128)
    address = models.CharField(
        max_length=128,
        blank=True,
        help_text="The main registered address of the organisation.",
    )
    about = models.TextField(
        blank=True,
        help_text="Organisation overview with its role in the energy projects community.",
    )

    class Meta:
        db_table = "coped_organisation"

    def __str__(self):
        return self.name


class Person(models.Model):
    """People managed by CoPED.

    Note that these are distinct from registered CoPED 'users'.
    Users are those people who use the platform, while Person records are
    individuals identified in the project meta data itself."""

    coped_id = models.UUIDField(
        default=str(uuid4()), editable=False, verbose_name="CoPED ID"
    )
    first_name = models.CharField(max_length=128)
    last_name = models.CharField(max_length=128)
    organisation = models.ForeignKey(
        Organisation, null=True, blank=True, on_delete=models.SET_NULL
    )
    about = models.TextField(
        blank=True,
        help_text="Role in the energy projects community.",
    )

    class Meta:
        db_table = "coped_person"

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class Fund(models.Model):
    """Details of named funds available for energy projects.

    In general a fund is any distinct named source of funding which could
    be used or has been used to fund a project listed in CoPED.
    Each fund will have a distinct description, criteria, and contact points
    listed in its Fund record."""

    coped_id = models.UUIDField(
        default=str(uuid4()),
        editable=False,
        verbose_name="CoPED ID",
    )
    title = models.CharField(max_length=128)
    about = models.TextField(
        blank=True,
        help_text="Details of eligibility, availability, application process, contacts, etc.",
    )
    organisation = models.ForeignKey(
        Organisation,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        help_text="Which organisation administers this fund?",
    )

    class Meta:
        db_table = "coped_fund"

    def __str__(self):
        return self.title


class Project(models.Model):
    """Projects managed by CoPED.

    Projects are the central data type managed by CoPED. They generally
    have links to a range of Fund, Person, and Organisation records based on
    who funded the project, who worked on it, and so on."""

    coped_id = models.UUIDField(
        default=str(uuid4()), editable=False, verbose_name="CoPED ID"
    )
    title = models.CharField(max_length=256)
    description = models.TextField(blank=True)
    status = models.CharField(
        max_length=128,
        blank=True,
        help_text="Is the project active or in some other state?",
    )
    funds = models.ManyToManyField(
        Fund,
        through="ProjectFund",
        through_fields=("project", "fund"),
    )
    persons = models.ManyToManyField(
        Person,
        through="ProjectPerson",
        through_fields=("project", "person"),
    )
    organisations = models.ManyToManyField(
        Organisation,
        through="ProjectOrganisation",
        through_fields=("project", "organisation"),
    )

    class Meta:
        db_table = "coped_project"
        ordering = ["-id"]

    def __str__(self):
        return self.title


##########################################
## Primary CoPED-managed relation types ##
##########################################


class ProjectFund(models.Model):
    """Through model for funds related to projects.

    Each project can have zero or more funds. The ProjectFund records
    additional details of the project's funding such as its value, relevant
    dates, and so on.

    Note that the related Fund record has a foreign key to the relevant
    funding organisation, so projects are related to their funding organisations
    indirectly, via this intermediary ProjectFund model."""

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    fund = models.ForeignKey(Fund, on_delete=models.CASCADE)
    amount = models.DecimalField(
        null=True,
        blank=True,
        decimal_places=2,
        max_digits=12,
        help_text="Value of the funding award in GBP.",
    )
    start_date = models.DateField(
        null=True, blank=True, help_text="Scheduled funding start date."
    )
    end_date = models.DateField(
        null=True, blank=True, help_text="Scheduled funding end date."
    )

    class Meta:
        db_table = "coped_project_fund"

    def __str__(self):
        return f"{self.fund.title} funding for {self.project.title}"


class ProjectOrganisation(models.Model):
    """Through model for organisations related to projects.

    Projects are generally administered or worked on by an organisation.
    The ProjectOrganisation records the nature of the link between them.
    For projects with only one organisation link, its role defaults to
    'LEAD' organisation.

    Note that project funders are a special case and these should be linked to
    projects via the ProjectFund intermediary model."""

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