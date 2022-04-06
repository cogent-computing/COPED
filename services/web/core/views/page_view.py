import logging
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from core.models import AppSetting
from dashboards.utils import dashboard_embed_url


def index(request):
    try:
        HOMEPAGE_DASHBOARD_ID = int(
            AppSetting.objects.get(slug="HOMEPAGE_DASHBOARD_ID").value
        )
    except AppSetting.DoesNotExist:
        logging.error("Could not find homepage dashboard ID")
        HOMEPAGE_DASHBOARD_ID = -1
    dashboard_url = dashboard_embed_url(
        HOMEPAGE_DASHBOARD_ID, titled=False, theme="night"
    )
    return render(request, "index.html", context={"dashboard_url": dashboard_url})


def visuals(request):
    return render(request, "visuals.html")


def visuals_dashboard(request):
    return render(request, "visuals_dashboard.html")


def visuals_dashboard_experiment(request):
    import jwt
    import time

    METABASE_SITE_URL = "http://localhost/metabase"
    METABASE_SECRET_KEY = (
        "156812543071f0108b459434ebb9997b56865770f45fb9c19ff348772e72c0e4"
    )

    payload = {
        "resource": {"dashboard": 1},
        "params": {},
        "exp": round(time.time()) + (60 * 10),  # 10 minute expiration
    }

    token = jwt.encode(payload, METABASE_SECRET_KEY, algorithm="HS256")

    iframeUrl = (
        METABASE_SITE_URL + "/embed/dashboard/" + token + "#bordered=false&titled=true"
    )

    return render(
        request, "visuals_dashboard_experiment.html", context={"iframeUrl": iframeUrl}
    )


@login_required
def visuals_dashboard2(request):
    return render(request, "visuals_dashboard2.html")


@login_required
def analysis_view(request):
    return render(request, "analysis_iframe_page.html")
