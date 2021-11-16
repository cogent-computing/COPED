from django.db import models
from uuid import uuid4
from .raw_data import RawData
from .external_link import ExternalLink
from .organisation import Organisation


class Person(models.Model):
    """People managed by CoPED.

    Note that these are distinct from registered CoPED 'users'.
    Users are those people who use the platform, while Person records are
    individuals identified in the project meta data itself."""

    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    email = models.EmailField(blank=True, null=True)
    first_name = models.CharField(max_length=128)
    other_name = models.CharField(max_length=128, blank=True, null=True)
    last_name = models.CharField(max_length=128)
    orcid_id = models.CharField(max_length=20, blank=True, null=True)
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )
    external_links = models.ManyToManyField(ExternalLink)
    organisations = models.ManyToManyField(
        Organisation,
        through="PersonOrganisation",
        through_fields=("person", "organisation"),
    )

    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}"

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
        return self.role
