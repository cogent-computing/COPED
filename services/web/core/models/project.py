from decimal import Decimal
from django.db import models
from django.db.models import F, Max, Min
from django.db.models.functions import Greatest, Least
from django.db.models.aggregates import Sum
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .organisation import Organisation
from .person import Person
from .raw_data import RawData
from .external_link import ExternalLink
from .subject import Subject


class ProjectQuerySet(models.QuerySet):
    """Add some useful annotations to project querysets."""

    def with_annotations(self):
        self = self.annotate(all_funds_start_date=Min("projectfund__start_date"))
        self = self.annotate(all_funds_end_date=Max("projectfund__end_date"))
        self = self.annotate(total_funding=Sum("projectfund__amount"))
        self = self.annotate(filter_start_date=Least("all_funds_start_date", "start"))
        self = self.annotate(filter_end_date=Greatest("all_funds_end_date", "end"))
        return self


class ProjectManager(models.Manager):
    """Enhance the usual queryset by using our custom annotations."""

    def get_queryset(self):
        return ProjectQuerySet(
            model=self.model, using=self._db, hints=self._hints
        ).with_annotations()


class Project(models.Model):
    """Projects managed by CoPED.

    Projects are the central data type managed by CoPED. They generally
    have links to a range of Fund, Person, and Organisation records based on
    who funded the project, who worked on it, and so on."""

    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    title = models.CharField(max_length=256)
    description = models.TextField(blank=True)
    extra_text = models.TextField(blank=True)
    status = models.CharField(
        max_length=128,
        blank=True,
        help_text="Is the project active or in some other state?",
    )
    start = models.DateField(null=True, blank=True)
    end = models.DateField(null=True, blank=True)
    funds = models.ManyToManyField(
        Organisation,
        through="ProjectFund",
        through_fields=("project", "organisation"),
        related_name="project_fund",
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
    subjects = models.ManyToManyField(
        Subject,
        through="ProjectSubject",
        through_fields=("project", "subject"),
    )
    projects = models.ManyToManyField(
        to="self", through="LinkedProject", symmetrical=False
    )
    external_links = models.ManyToManyField(ExternalLink)
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )

    objects = (
        ProjectManager()
    )  # Use a custom manager to enhance querysets with annotations

    def get_absolute_url(self):
        return reverse("project-detail", kwargs={"pk": self.pk})

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
    dates, and so on."""

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    organisation = models.ForeignKey(Organisation, on_delete=models.CASCADE)
    amount = models.DecimalField(
        null=True,
        blank=True,
        decimal_places=2,
        max_digits=12,
        help_text="Value of the funding award.",
    )
    currency = models.CharField(max_length=3, default="GBP")
    start_date = models.DateField(
        null=True, blank=True, help_text="Scheduled funding start date."
    )
    end_date = models.DateField(
        null=True, blank=True, help_text="Scheduled funding end date."
    )
    # Also provide a link to where the project funding information came from.
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )

    class Meta:
        db_table = "coped_project_fund"

    def __str__(self):
        return f"{self.organisation.name} funding for {self.project.title}"


class ProjectSubject(models.Model):
    """Through model for subjects/categories/topics related to projects.

    Each related subject has a score/weight indicating the confidence of the label.
    Scores come from the National Library of Finland's Finto project.

    See the following links for details:

        - http://annif.org/
        - https://www.kiwi.fi/display/Finto/Finto+AI+open+API+service
        - https://ai.finto.fi/v1/ui/
    """

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    score = models.DecimalField(
        null=True,
        blank=True,
        decimal_places=12,
        max_digits=13,
        help_text="Strength of match for the subject with this project.",
    )

    class Meta:
        db_table = "coped_project_subject"
        constraints = [
            models.UniqueConstraint(
                fields=["project", "subject"],
                name="subject-assigned",
            )
        ]

    def __str__(self):
        return f"({self.score}) {self.subject}"


class ProjectOrganisation(models.Model):
    """Through model for organisations related to projects.

    Projects are generally administered or worked on by an organisation.
    The ProjectOrganisation records the nature of the link between them.
    For projects with only one organisation link, its role defaults to
    'LEAD' organisation."""

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    organisation = models.ForeignKey(Organisation, on_delete=models.CASCADE)
    role = models.CharField(max_length=16, default="Lead Organisation")

    class Meta:
        db_table = "coped_project_organisation"

    def __str__(self):
        return self.role


class LinkedProject(models.Model):
    """Through model for projects that are linked to other projects.

    This can be used for things like studentships which have their own Project
    record but are also part of a larger project."""

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    link = models.ForeignKey(
        Project, on_delete=models.CASCADE, related_name="linked_project"
    )
    relation = models.CharField(max_length=32, default="Linked Project")

    class Meta:
        db_table = "coped_linked_project"

    def __str__(self):
        return self.relation


class ProjectPerson(models.Model):
    """Through model for persons related to projects."""

    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    role = models.CharField(max_length=16, default="Lead Person")

    class Meta:
        db_table = "coped_project_person"

    def __str__(self):
        return self.role
