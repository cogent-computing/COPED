from django.db import models


class ExternalLink(models.Model):
    """External links managed by CoPED.

    In general a link can be used on multiple resources, and each resource
    can have multiple external links."""

    link = models.URLField(help_text="Link URL including 'http://' or 'https://'.")
    description = models.CharField(max_length=128)

    class Meta:
        db_table = "coped_external_link"
        verbose_name_plural = "External Links"

    def __str__(self):
        return f"{self.description} - {self.link}"
