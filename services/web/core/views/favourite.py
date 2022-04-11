from django.views import generic
from django.contrib.auth.mixins import LoginRequiredMixin
from easyaudit.models import LoginEvent

from ..models import Project, Person, Organisation


class FavouriteListView(LoginRequiredMixin, generic.TemplateView):

    template_name = "users/favourite_list.html"

    def get_context_data(self, **kwargs):

        context = super().get_context_data(**kwargs)

        user = self.request.user
        logins = (
            LoginEvent.objects.filter(user=user, login_type=0)
            .order_by("-datetime")
            .all()
        )
        if len(logins) > 1:
            previous_login = logins[1].datetime
            context["previous_login"] = previous_login

        proj_fav_ids = user.projectsubscription_set.values_list("project_id", flat=True)
        context["project_favs"] = Project.objects.filter(id__in=proj_fav_ids).all()

        pers_fav_ids = user.personsubscription_set.values_list("person_id", flat=True)
        context["person_favs"] = Person.objects.filter(id__in=pers_fav_ids).all()

        org_fav_ids = user.organisationsubscription_set.values_list(
            "organisation_id", flat=True
        )
        context["organisation_favs"] = Organisation.objects.filter(
            id__in=org_fav_ids
        ).all()

        return context
