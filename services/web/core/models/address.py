from django.db import models
from uuid import uuid4


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

    class Meta:
        db_table = "coped_address"
        verbose_name_plural = "Addresses"

    def __str__(self):
        return ", ".join(
            [self.line1, self.city, self.region, self.postcode, self.country]
        )
