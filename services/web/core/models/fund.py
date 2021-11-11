from django.db import models
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .organisation import Organisation
from .raw_data import RawData
from .external_link import ExternalLink


class Fund(models.Model):
    """Details of named funds available for energy projects.

    In general a fund is any distinct named source of funding which could
    be used or has been used to fund a project listed in CoPED.
    Each fund will have a distinct description, criteria, and contact points
    listed in its Fund record."""

    coped_id = models.UUIDField(
        default=uuid4,
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
    external_links = models.ManyToManyField(ExternalLink)
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )

    class Meta:
        db_table = "coped_fund"

    def __str__(self):
        return self.title
