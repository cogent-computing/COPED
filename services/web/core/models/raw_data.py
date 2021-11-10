from django.db import models
from django.core.serializers.json import DjangoJSONEncoder


class RawData(models.Model):
    """Raw data scraped by CoPED plugins/services.

    Records in this table can be referenced by CoPED resources, such as people and
    organisations, that are derived from the crawled data."""

    bot = models.CharField(
        max_length=32,
        help_text="Name of the bot or crawler that scraped the data.",
    )
    url = models.URLField(
        unique=True, verbose_name="URL", help_text="Source URL of the data."
    )
    json = models.JSONField(
        encoder=DjangoJSONEncoder,
        blank=True,
        null=True,
        verbose_name="JSON",
        help_text="Raw JSON from the source",
    )

    class Meta:
        db_table = "coped_raw_data"
        verbose_name_plural = "Raw Data"

    def __str__(self):
        return f"{self.bot} : {self.url}"
