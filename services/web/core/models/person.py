from django.conf import settings
from django.db import models
from django.db.models import F, Value
from django.db.models.functions import Concat
from django.urls import reverse
from uuid import uuid4
from .raw_data import RawData
from .external_link import ExternalLink
from .organisation import Organisation


class PersonQuerySet(models.QuerySet):
    """Add some useful annotations to person querysets."""

    def with_annotations(self):
        self = self.annotate(
            full_name_annotation=Concat(F("first_name"), Value(" "), F("last_name"))
        )
        return self


class PersonManager(models.Manager):
    """Enhance the usual queryset by using our custom annotations."""

    def get_queryset(self):
        return PersonQuerySet(
            model=self.model, using=self._db, hints=self._hints
        ).with_annotations()


class Person(models.Model):
    """People managed by CoPED.

    Note that these are distinct from registered CoPED 'users'.
    Users are those people who use the platform, while Person records are
    individuals identified in the project meta data itself."""

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True
    )
    is_locked = models.BooleanField(
        default=False,
        help_text="Lock this project to prevent automatic updates from overwriting your changes. (You can still make changes.)",
    )
    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    email = models.EmailField(blank=True, null=True)
    first_name = models.CharField(max_length=128)
    other_name = models.CharField(max_length=128, blank=True, null=True)
    last_name = models.CharField(max_length=128)
    orcid_id = models.CharField(
        max_length=20, blank=True, null=True, verbose_name="ORCID iD"
    )
    linkedin_url = models.URLField(verbose_name="LinkedIn URL", blank=True)
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )
    external_links = models.ManyToManyField(ExternalLink, blank=True)
    organisations = models.ManyToManyField(
        Organisation,
        through="PersonOrganisation",
        through_fields=("person", "organisation"),
    )
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)

    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}"

    objects = (
        PersonManager()
    )  # Use a custom manager to enhance querysets with annotations

    def get_absolute_url(self):
        return reverse("person-detail", kwargs={"pk": self.pk})

    class Meta:
        db_table = "coped_person"

    def __str__(self):
        return self.full_name


class PersonOrganisation(models.Model):
    """Through model for organisations related to people.

    People are generally linked to one or more organisations.
    The PersonOrganisation records the nature of the link between them.
    """

    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    organisation = models.ForeignKey(Organisation, on_delete=models.CASCADE)
    role = models.CharField(max_length=16, default="Employee")

    class Meta:
        db_table = "coped_person_organisation"

    def __str__(self):
        return f"{self.organisation} ({self.role})"


class PersonSubscription(models.Model):
    """Through model connecting to users who subscribe to updates."""

    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    added = models.DateTimeField(auto_now_add=True, blank=True)

    class Meta:
        db_table = "coped_person_subscription"
        unique_together = (
            "person",
            "user",
        )
