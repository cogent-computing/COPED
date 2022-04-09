from django.db import models


class MetabaseUser(models.Model):
    # An unmanaged model to access the `core_user` table in Metabase DB
    id = models.IntegerField(primary_key=True)
    email = models.EmailField()

    class Meta:
        managed = False  # Don't create or delete this table
        db_table = "core_user"
