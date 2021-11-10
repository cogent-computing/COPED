from django.db import models
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .organisation import Organisation
from .raw_data import RawData


class Person(models.Model):
    """People managed by CoPED.

    Note that these are distinct from registered CoPED 'users'.
    Users are those people who use the platform, while Person records are
    individuals identified in the project meta data itself."""

    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    first_name = models.CharField(max_length=128)
    last_name = models.CharField(max_length=128)
    organisation = models.ForeignKey(
        Organisation, null=True, blank=True, on_delete=models.SET_NULL
    )
    about = models.TextField(
        blank=True,
        null=True,
        help_text="Role in the energy projects community.",
    )
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )

    class Meta:
        db_table = "coped_person"

    def __str__(self):
        return f"{self.first_name} {self.last_name}"
