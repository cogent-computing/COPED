import json
from django.db import models
from django.db.models import Q
from django.urls import reverse
from django.db.models.signals import post_save
from django.db.models.functions import Cast
from django.dispatch import receiver
from django.utils.translation import gettext_lazy as _
from uuid import uuid4
from .raw_data import RawData
from .external_link import ExternalLink
from .address import Address
from easyaudit.models import CRUDEvent
from django.contrib.contenttypes.models import ContentType


class CopedCRUDEvent(models.Model):
    """Add a json field to store object representations"""

    class Meta:
        db_table = "coped_crudevent"

    easyaudit = models.OneToOneField(CRUDEvent, on_delete=models.CASCADE)
    object_json = models.JSONField()


def project_history(project_id):
    """Given a project id return a queryset of audit log entries covering its history.

    Returns a queryset containing CRUDEvent() objects logging changes to the project."""

    # 1. Match all logs for the project itself.
    ct = ContentType.objects.get(app_label="core", model="project")
    match_ct = Q(content_type_id=ct.id)
    match_project = Q(object_id=str(project_id))
    has_changed = ~Q(changed_fields="null")
    # -> Exclude the *string* 'null' but include genuine <is null> values.
    project_history = CRUDEvent.objects.filter(match_ct & match_project & has_changed)

    # 2. Also find lofs of changes to many-to-many related objects:
    # 2.1 Query JSON representations to find related objects.
    match_related = Q(object_json__fields__project=project_id)
    related_json = CopedCRUDEvent.objects.filter(match_related)
    # 2.2 Lookup the required log entries for these objects
    related_history = CRUDEvent.objects.filter(
        id__in=related_json.values_list("easyaudit_id", flat=True)
    )

    # 3. Combine the logs belonging to the project and its related items.
    full_history = project_history.union(related_history).all().order_by("-datetime")

    return full_history


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
