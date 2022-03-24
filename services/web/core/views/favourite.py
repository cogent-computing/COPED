from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from easyaudit.models import LoginEvent

from ..models import Project


class FavouriteListView(LoginRequiredMixin, generic.ListView):

    template_name = "users/favourite_list.html"

    def get_queryset(self):
        user = self.request.user
        fav_ids = user.projectsubscription_set.values_list("project_id", flat=True)
        favs = Project.objects.filter(id__in=fav_ids).all()
        return favs

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        logins = (
            LoginEvent.objects.filter(user=user, login_type=0)
            .order_by("-datetime")
            .all()
        )

        if not len(logins) > 1:
            return context

        previous_login = logins[1].datetime
        context["previous_login"] = previous_login
        return context
