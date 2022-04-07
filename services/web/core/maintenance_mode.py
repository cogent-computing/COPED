# A script to supply template context to the site's '503.html' template.
from .models import AppSetting


def get_context(*args, **kwargs):
    try:
        MAINTENANCE_MODE_MESSAGE = AppSetting.objects.get(
            slug="MAINTENANCE_MODE_MESSAGE"
        ).value
    except AppSetting.DoesNotExist:
        MAINTENANCE_MODE_MESSAGE = (
            "CoPED is down for maintenance.<br>Please check back soon."
        )
    return {"message": MAINTENANCE_MODE_MESSAGE}
