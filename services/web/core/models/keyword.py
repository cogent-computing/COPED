from django.db import models


class Keyword(models.Model):
    """Keywords managed by CoPED.

    In general a keyword or phrase can be extracted from multiple resources,
    and each resource can have multiple keywords or phrases."""

    text = models.CharField(max_length=128)

    class Meta:
        db_table = "coped_keyword"
        verbose_name_plural = "Keywords and Phrases"
        indexes = [models.Index(fields=["text"])]

    def __str__(self):
        return self.text
