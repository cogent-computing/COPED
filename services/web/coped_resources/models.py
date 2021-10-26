from django.core import validators
from django.db import models
from django.db.models.fields import related
from django.core.validators import MaxValueValidator, MinValueValidator


class ResourceType(models.Model):
    """Resource types managed by CoPED.

    Notes:

    - String values of the "item_type" field must correspond to possible values
    of the mandatory "coped_meta.item_type" field in CouchDB documents.
    """

    description = models.CharField(
        max_length=128, blank=False, help_text="What type of resource is this?"
    )
    item_type = models.CharField(
        primary_key=True,
        max_length=128,
        blank=False,
        help_text="What is the 'item_type' in the CouchDB document meta data?",
        unique=True,
    )

    class Meta:
        db_table = "coped_resource_type"

    def __unicode__(self):
        return self.description


class RelationType(models.Model):
    """Resource relation types managed by CoPED."""

    description = models.CharField(
        blank=False,
        max_length=128,
        help_text="What is the nature of the relation between the resource types, e.g. 'Project lead'?",
    )
    rel_link = models.CharField(
        primary_key=True,
        blank=True,
        max_length=32,
        help_text="What is the label for the relation, e.g. 'PI_PER' for principal investigator (UKRI)?",
    )
    resource_type_1 = models.ForeignKey(
        ResourceType,
        on_delete=models.CASCADE,
        related_name="source",
        verbose_name="Source resource type",
        help_text="What is the type of the source resource, e.g. 'person'?",
    )
    resource_type_2 = models.ForeignKey(
        ResourceType,
        on_delete=models.CASCADE,
        related_name="target",
        verbose_name="Target resource type",
        help_text="What is the type of the target resource, e.g. 'project'?",
    )
    is_weighted = models.BooleanField(
        default=False, help_text="Is this relation type quantifiable?"
    )

    class Meta:
        db_table = "coped_relation_type"
        unique_together = ["resource_type_1", "resource_type_2", "rel_link"]

    def __unicode__(self):
        description = self.description
        resource_1 = self.resource_type_1.description
        resource_2 = self.resource_type_2.description
        weighted = self.is_weighted
        return f"{description} ({resource_1} -> {resource_2}, weighted={weighted})"


class Resource(models.Model):
    """Pointers to entities stored in the CoPED CouchDB databases.

    Each resource record shows how to retrieve the full data describing it:

    - couchdb_name : points to a CouchDB database
    - document_id : gives a document's unique `_id` in the CouchDB database
    """

    document_id = models.UUIDField(null=False, primary_key=True)
    resource_type = models.ForeignKey(
        ResourceType, on_delete=models.PROTECT, null=False
    )

    class Meta:
        db_table = "coped_resource"
        indexes = [
            models.Index(fields=["resource_type"], name="resource_type_idx"),
        ]

    def __unicode__(self):
        return f"{self.resource_type} : {self.document_id}"


class Relation(models.Model):

    resource_1 = models.ForeignKey(
        Resource,
        on_delete=models.CASCADE,
        null=False,
        related_name="source",
        help_text="Source of a two-way relation between CoPED resources",
    )
    resource_2 = models.ForeignKey(
        Resource,
        on_delete=models.CASCADE,
        null=False,
        related_name="target",
        help_text="Target of a two-way relation between CoPED resources",
    )
    relation_type = models.ForeignKey(
        RelationType,
        on_delete=models.PROTECT,
        null=False,
        help_text="How is the source related to the target?",
    )
    relation_weight = models.FloatField(
        null=True,
        help_text="When the relation is quantifiable, what is the strength of the connection?",
    )

    class Meta:
        db_table = "coped_relation"
        constraints = [
            models.UniqueConstraint(
                fields=["resource_1", "resource_2", "relation_type"],
                name="unique_resources_per_relation",
            )
        ]
        indexes = [
            models.Index(
                fields=["resource_1", "resource_2"],
                name="forward_relation_idx",
            ),
            models.Index(
                fields=["resource_2", "resource_1"],
                name="backward_relation_idx",
            ),
            models.Index(
                fields=["relation_type"],
                name="relation_type_idx",
            ),
        ]
