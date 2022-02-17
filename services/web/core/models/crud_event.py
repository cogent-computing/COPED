import json
from django.db import models
from django.urls import reverse
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .raw_data import RawData
from .external_link import ExternalLink
from .address import Address
from easyaudit.models import CRUDEvent


class CopedCRUDEvent(models.Model):
    """Add a json field to store object representations"""

    class Meta:
        db_table = "coped_crudevent"

    easyaudit = models.OneToOneField(CRUDEvent, on_delete=models.CASCADE)
    object_json = models.JSONField()

    def save(self, *args, **kwargs):
        print("SOMETHING IS BEING SAVED")
        return super().save(*args, **kwargs)


@receiver(post_save, sender=CRUDEvent)
def post_save_handler(sender, instance, *args, **kwargs):
    print(f"Received post_save signal for {instance}")
    print(instance.pk)
    print(instance.object_json_repr)
    event_copy = CopedCRUDEvent()
    event_copy.easyaudit_id = instance.pk
    json_data = json.loads(instance.object_json_repr)
    event_copy.object_json = json_data[0]
    event_copy.save()
