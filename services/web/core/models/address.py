from django.db import models
from uuid import uuid4
from . import GeoData


class Address(models.Model):
    """Addresses managed by CoPED.

    These can be associated to organisations for geolocation and spatial search."""

    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    line1 = models.CharField(max_length=128, blank=True)
    line2 = models.CharField(max_length=128, blank=True)
    line3 = models.CharField(max_length=128, blank=True)
    line4 = models.CharField(max_length=128, blank=True)
    line5 = models.CharField(max_length=128, blank=True)
    city = models.CharField(max_length=128, blank=True)
    county = models.CharField(max_length=128, blank=True)
    region = models.CharField(max_length=128, blank=True)
    postcode = models.CharField(max_length=16, blank=True)
    country = models.CharField(max_length=128, blank=True)
    geo = models.ForeignKey(
        GeoData,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        help_text="Geographic data.",
    )

    class Meta:
        db_table = "coped_address"
        verbose_name_plural = "Addresses"

    def __str__(self):
        fields = ["line1", "line2", "line3", "line4", "line5", "city", "county"]
        if self.region not in ["Unknown", "Outside UK", ""]:
            fields.append("region")
        fields.extend(["postcode", "country"])

        return ", ".join([getattr(self, f) for f in fields if getattr(self, f) != ""])


class GeoTag(models.Model):
    """Geo data for addresses, found using forward-geocode lookups."""

    pass
    # lat =
    # lon =
    # display_name =
    # source_id =
    # source_name =
