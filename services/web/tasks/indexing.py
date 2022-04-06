# Run as a scheduled job (weekly?) to update Google/Bing index of the project records available in CoPED.

import logging
import os
import sys
import django
from urllib.error import HTTPError
from django.contrib.sitemaps import ping_google as ping_search_index
from django.contrib.sitemaps import SitemapNotFound
from celery import shared_task

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import AppSetting


@shared_task(name="Ping Google and Bing with updated sitemap")
def ping_google_and_bing():
    try:
        site_http_protocol = AppSetting.objects.get(slug="site_http_protocol").value
    except AppSetting.DoesNotExist:
        site_http_protocol = "https"
    uses_https = site_http_protocol == "https"

    try:
        ping_search_index(sitemap_uses_https=uses_https)
        ping_search_index(
            sitemap_uses_https=uses_https,
            ping_url="http://www.bing.com/ping",
        )
    except SitemapNotFound:
        logging.error("Could not find sitemap to ping Google/Bing with")
    except HTTPError:
        logging.error("HTTP error when pinging an index service")


if __name__ == "__main__":
    ping_google_and_bing()
