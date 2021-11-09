from django.db import models
from django.utils.translation import gettext_lazy as _
from uuid import uuid4


class Organisation(models.Model):
    """Organisations managed by CoPED.

    Organisations may be funders, project leaders or partners, employers
    of project participants, and so on."""

    coped_id = models.UUIDField(
        default=uuid4,
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
