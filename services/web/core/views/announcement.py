from pinax.announcements.models import Announcement
from django.views.generic import ListView


class AnnouncementListView(ListView):
    template_name = "pinax/announcements/announcement_list.html"
    model = Announcement
    queryset = Announcement.objects.all().order_by("publish_end")
    paginate_by = 20
