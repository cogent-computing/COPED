from django.contrib.sitemaps import Sitemap
from .models import Project, AppSetting

try:
    SITE_HTTP_PROTOCOL = AppSetting.objects.get(slug="SITE_HTTP_PROTOCOL").value
except AppSetting.DoesNotExist:
    SITE_HTTP_PROTOCOL = "https"
SITE_HTTP_PROTOCOL = (
    SITE_HTTP_PROTOCOL if SITE_HTTP_PROTOCOL in ["http", "https"] else "https"
)


class ProjectSitemap(Sitemap):
    changefreq = "monthly"
    priority = 0.8
    protocol = SITE_HTTP_PROTOCOL

    def items(self):
        return Project.objects.all()

    def lastmod(self, obj):
        return obj.modified

    def location(self, obj):
        return obj.get_absolute_url()
