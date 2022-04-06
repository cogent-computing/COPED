from django.db import models
from django.urls import reverse

class PublicAdminDashboardManager(models.Manager):
    def get_queryset(self):
        qs = super().get_queryset()
        qs = qs.filter(creator_id=1, public_uuid__isnull=False, enable_embedding=True)
        return qs

class Dashboard(models.Model):
    # An unmanaged model for accessing the `report_dashboard` table in the Metabase DB
    id = models.IntegerField(primary_key=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    name = models.CharField(max_length=254)
    description = models.TextField(null=True)
    creator_id = models.IntegerField()
    parameters = models.TextField(null=True)
    public_uuid = models.CharField(max_length=36, null=True)
    made_public_by_id = models.IntegerField(null=True)
    enable_embedding = models.BooleanField(default=False)
    embedding_params = models.TextField(null=True)
    archived = models.BooleanField(default=False)
    collection_id = models.IntegerField(null=True)

    objects = PublicAdminDashboardManager()
    objects_all = models.Manager()

    class Meta:
        managed = False  # Don't create or delete this table
        db_table = "report_dashboard"  # must match the existing table

    def get_absolute_url(self):
        return reverse("dashboards:embed", kwargs={"public_uuid": self.public_uuid})
    

class Setting(models.Model):
    # An unmanaged model to access the `setting` table in Metabase DB
    key = models.CharField(primary_key=True, max_length=254)
    value = models.TextField(blank=True)

    class Meta:
        managed = False  # Don't create or delete this table
        db_table = "setting"
