from django.db import models

class Dashboard(models.Model):
    # An unmanaged model for accessing the `report_dashboard` table in the Metabase DB
    id = models.IntegerField(primary_key=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    name = models.CharField(max_length=254)
    description = models.TextField(null=True)
    creator_id = models.IntegerField()
    public_uuid = models.UUIDField(null=True)
    made_public_by_id = models.IntegerField(null=True)
    enable_embedding = models.BooleanField(default=False)
    embedding_params = models.TextField(null=True)
    archived = models.BooleanField(default=False)
    collection_id = models.IntegerField(null=True)

    class Meta:
        managed = False  # Don't create or delete this table
        db_table = "report_dashboard"