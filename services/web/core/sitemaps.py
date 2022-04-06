from django.contrib.sitemaps import Sitemap
from .models import Project, AppSetting

try:
    site_http_protocol = AppSetting.objects.get(slug="site_http_protocol").value
except AppSetting.DoesNotExist:
    site_http_protocol = "https"
site_http_protocol = (
    site_http_protocol if site_http_protocol in ["http", "https"] else "https"
)


class ProjectSitemap(Sitemap):
    changefreq = "monthly"
    priority = 0.8
    protocol = site_http_protocol

    def items(self):
        return Project.objects.all()

    def lastmod(self, obj):
        return obj.modified

    def location(self, obj):
        return obj.get_absolute_url()
