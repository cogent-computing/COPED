from django.conf import settings
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .raw_data import RawData
from .external_link import ExternalLink
from .address import Address


class Organisation(models.Model):
    """Organisations managed by CoPED.

    Organisations may be funders, project leaders or partners, employers
    of project participants, and so on."""

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True
    )
    is_locked = models.BooleanField(
        default=False,
        help_text="Lock this project to prevent automatic updates from overwriting your changes. (You can still make changes.)",
    )
    coped_id = models.UUIDField(
        default=uuid4,
        editable=False,
        verbose_name="CoPED ID",
    )
    name = models.CharField(max_length=128)
    addresses = models.ManyToManyField(Address, blank=True)
    about = models.TextField(
        blank=True,
        help_text="Organisation overview with its role in the energy projects community.",
    )
    external_links = models.ManyToManyField(ExternalLink, blank=True)
    raw_data = models.ForeignKey(
        RawData, null=True, blank=True, on_delete=models.SET_NULL
    )

    def get_absolute_url(self):
        return reverse("organisation-detail", kwargs={"pk": self.pk})

    class Meta:
        db_table = "coped_organisation"

    def __str__(self):
        return self.name


class OrganisationSubscription(models.Model):
    """Through model connecting to users who subscribe to updates."""

    organisation = models.ForeignKey(Organisation, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    added = models.DateTimeField(auto_now_add=True, blank=True)

    class Meta:
        db_table = "coped_organisation_subscription"
        unique_together = (
            "organisation",
            "user",
        )
