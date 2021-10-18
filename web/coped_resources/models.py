from django.core import validators
from django.db import models
from django.db.models.fields import related
from django.core.validators import MaxValueValidator, MinValueValidator


class ResourceType(models.Model):
    """Resource types managed by CoPED.

    Examples:

    - "project"
    - "person"
    - "organisation"
    - "publication"

    Notes:

    - String values must correspond to possible values
    of the mandatory "item_type" field in CouchDB documents.
    """

    description = models.TextField(
        blank=False, help_text="What type of resource is this?"
    )
    is_outcome = models.BooleanField(
        default=False, help_text="Is this a type of project outcome?"
    )

    class Meta:
        db_table = "coped_resource_type"

    def __unicode__(self):
        return self.description


class CouchDBName(models.Model):
    """Data sources held in CouchDB.

    Examples:

    - "ukri-crawler-data"
    - "some-other-crawler-data"

    Notes:

    - Name values must correspond to names of databases in
    CouchDB, which hold the corresponding source's raw and meta data.
    - The authority field gives the relative authority of the data source,
    which can be used by merge strategies when deciding which fields to show.
    - An authority value of 1 is the most authoritative source, 1000 the least.

    """

    name = models.CharField(
        blank=False, max_length=128, help_text="Provide the name of a CouchDB database."
    )
    authority = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(1000)],
        default=1000,
        help_text="How authoritative is this source? 1 is most, 1000 least.",
    )

    class Meta:
        db_table = "coped_couchdb_name"

    def __unicode__(self):
        return self.name


class RelationType(models.Model):
    """Resource relation types managed by CoPED.

    Examples of (description, resource 1, resource 2, weighted):

    - principal investigator, person, project, False
    - funded, fund, project, False
    - output, project, publication, False
    - employed, organisation, person, False
    - is similar to, project, project, True
    """

    description = models.CharField(
        blank=False,
        max_length=128,
        help_text="What is the nature of the relation between the resource types, e.g. 'Project lead'?",
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
        unique_together = ["resource_type_1", "resource_type_2"]

    def __unicode__(self):
        description = self.description
        resource_1 = self.resource_type_1.description
        resource_2 = self.resource_type_2.description
        weighted = self.is_weighted
        return f"{description} ({resource_1}, {resource_2}, weighted={weighted})"


class Resource(models.Model):
    """Pointers to entities stored in the CoPED CouchDB databases.

    Each resource record shows how to retrieve the full data describing it:

    - couchdb_name : points to a CouchDB database
    - document_id : gives a document's unique `_id` in the CouchDB database
    """

    couchdb_name = models.ForeignKey(CouchDBName, on_delete=models.PROTECT, null=False)
    document_id = models.UUIDField(null=False, unique=True)
    resource_type = models.ForeignKey(
        ResourceType, on_delete=models.PROTECT, null=False, editable=False
    )

    class Meta:
        db_table = "coped_resource"
        indexes = [
            models.Index(fields=["document_id"], name="document_id_idx"),
            models.Index(fields=["couchdb_name"], name="couchdb_name_idx"),
            models.Index(fields=["resource_type"], name="resource_type_idx"),
        ]

    def __unicode__(self):
        return f"{self.resource_type} {self.document_id} : {self.document_description}"


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
        unique_together = ["resource_1", "resource_2", "relation_type"]
        indexes = [
            models.Index(
                fields=["resource_1", "resource_2"], name="forward_relation_idx"
            ),
            models.Index(
                fields=["resource_2", "resource_1"], name="backward_relation_idx"
            ),
            models.Index(fields=["relation_type"], name="relation_type_idx"),
        ]
