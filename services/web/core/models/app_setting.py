from django.db import models


class AppSetting(models.Model):
    """Miscellaneous application settings used by CoPED."""

    name = models.CharField(max_length=128)
    value = models.CharField(max_length=256)

    class Meta:
        db_table = "coped_app_setting"
        verbose_name_plural = "Application Settings"

    def __str__(self):
        return self.name
