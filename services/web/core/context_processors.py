from .models import AppSetting

def analytics_processor(request):
    # Add the correct analytics ID into the base (via 'head.html') template whenever it is rendered
    try:
        google_analytics_id = AppSetting.objects.get(slug="google_analytics_id").value
    except AppSetting.DoesNotExist:
        google_analytics_id = ""
    return {'analytics_id': google_analytics_id}
