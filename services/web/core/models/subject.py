from django.db import models
from uuid import uuid4
from .external_link import ExternalLink


class Subject(models.Model):
    """Subjects for categorising text.

    Since crawled data often include off-topic items we need to pre-process them
    to extract a good guess regarding their primary subject(s).

    Assigned subjects can then be used as a pre-filter before creating records in
    the main CoPED project table."""

    coped_id = models.UUIDField(default=uuid4, editable=False, verbose_name="CoPED ID")
    label = models.CharField(
        max_length=128, help_text="Short description of the subject."
    )
    external_link = models.ForeignKey(
        ExternalLink,
        on_delete=models.SET_NULL,
        null=True,
        help_text="Link to an ontology.",
    )
    energy_related = models.BooleanField(
        default=True, help_text="Is the subject related to energy projects?"
    )

    class Meta:
        db_table = "coped_subject"
        ordering = ["label"]

    def __str__(self):
        return self.label
