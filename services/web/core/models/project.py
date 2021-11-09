from django.db import models
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .organisation import Organisation
from .person import Person
from .fund import Fund


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
