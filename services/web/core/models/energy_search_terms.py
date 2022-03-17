from django.db import models


class EnergySearchTerm(models.Model):
    """Energy search terms managed by CoPED.

    These words are used when crawling resources to identify energy-related projects."""

    term = models.CharField(max_length=128)
    active = models.BooleanField(default=True)

    class Meta:
        db_table = "coped_energy_search_term"
        verbose_name_plural = "Energy Search Terms"

    def __str__(self):
        return self.term
