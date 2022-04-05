from django.db import models


class GeoData(models.Model):
    """Geographic/spatial data associated to CoPED resources.

    A geodata record contains information needed for spatial queries and mapping."""

    # TODO: enable GIS extension and use Points for location management.
    lat = models.FloatField(verbose_name="latitude")
    lon = models.FloatField(verbose_name="longitude")
    dno_id = models.SmallIntegerField(null=True, help_text="Distribution Network Operator (DNO) ID from https://data.nationalgrideso.com/system/gis-boundaries-for-gb-dno-license-areas")
    dno_name = models.CharField(blank=True, max_length=8, help_text="Distribution Network Operator (DNO) short name")
    dno_long_name = models.CharField(blank=True, max_length=64, help_text="Distribution Network Operator (DNO) long name")

    class Meta:
        db_table = "coped_geo_data"
        constraints = [
            models.UniqueConstraint(
                fields=["lat", "lon"],
                name="unique-geo-point",
            )
        ]

    def __str__(self):
        return f"({self.lat}, {self.lon}) https://www.openstreetmap.org/search?query={self.lat},{self.lon}"
