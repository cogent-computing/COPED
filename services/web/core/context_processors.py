from django.apps import apps
from .models import AppSetting


def analytics_processor(request):
    # Add the correct analytics ID into the base (via 'head.html') template whenever it is rendered
    try:
        GOOGLE_ANALYTICS_ID = AppSetting.objects.get(slug="GOOGLE_ANALYTICS_ID").value
    except AppSetting.DoesNotExist:
        GOOGLE_ANALYTICS_ID = ""
    return {"analytics_id": GOOGLE_ANALYTICS_ID}


def metabase_path_processor(request):
    # Add the correct Metabase path into the navigation menu (in 'base.html') to access the analytics
    try:
        METABASE_PATH = AppSetting.objects.get(slug="METABASE_PATH").value
    except AppSetting.DoesNotExist:
        METABASE_PATH = "/metabase"
    return {"metabase_path": METABASE_PATH}
