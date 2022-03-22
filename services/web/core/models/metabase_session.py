from datetime import timedelta
from django.db import models
from django.utils import timezone
from .user import User


def expiry_date_time():
    now = timezone.now()
    return now + timedelta(days=14)


class MetabaseSession(models.Model):
    """User session credentials for Metabase access."""

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    token = models.CharField(max_length=40)
    expires = models.DateTimeField(default=expiry_date_time)

    class Meta:
        db_table = "coped_metabase_session"

    def __str__(self):
        return f"{self.user} : {self.token} : {self.expires}"
