from .models import AppSetting


def analytics_processor(request):
    # Add the correct analytics ID into the base (via 'head.html') template whenever it is rendered
    try:
        GOOGLE_ANALYTICS_ID = AppSetting.objects.get(slug="GOOGLE_ANALYTICS_ID").value
    except AppSetting.DoesNotExist:
        GOOGLE_ANALYTICS_ID = ""
    return {"analytics_id": GOOGLE_ANALYTICS_ID}
