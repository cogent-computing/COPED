from django.contrib.auth.mixins import LoginRequiredMixin
from ..models import Project, Person, Organisation


from pinax.messages.views import MessageCreateView
from pinax.messages.views import InboxView as PinaxInboxView
from django.contrib.auth.mixins import LoginRequiredMixin


class InboxView(PinaxInboxView):
    pass


class ProjectContactOwnerView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        project_id = self.kwargs.get("pk")
        project = Project.objects.get(pk=project_id)
        user_id = project.owner.id

        title = project.title
        coped_id = project.coped_id
        id_ = project.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = project.get_absolute_url()
        url = proto + host + path

        subject = f"Message regarding project: '{title}'"
        content = (
            f"Project title: {title}\n"
            f"Project CoPED ID: {coped_id}\n"
            f"Project ID: {id_}\n"
            f"Project URL: {url}\n\n"
            "Your message:\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class PersonContactOwnerView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        person_id = self.kwargs.get("pk")
        person = Person.objects.get(pk=person_id)
        user_id = person.owner.id

        full_name = person.full_name
        coped_id = person.coped_id
        id_ = person.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = person.get_absolute_url()
        url = proto + host + path

        subject = f"Message regarding person: '{full_name}'"
        content = (
            f"Person: {full_name}\n"
            f"Person CoPED ID: {coped_id}\n"
            f"Person ID: {id_}\n"
            f"Person URL: {url}\n\n"
            "Your message:\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class OrganisationContactOwnerView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        organisation_id = self.kwargs.get("pk")
        organisation = Organisation.objects.get(pk=organisation_id)
        user_id = organisation.owner.id

        name = organisation.name
        coped_id = organisation.coped_id
        id_ = organisation.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = organisation.get_absolute_url()
        url = proto + host + path

        subject = f"Message regarding organisation: '{name}'"
        content = (
            f"Organisation: {name}\n"
            f"Organisation CoPED ID: {coped_id}\n"
            f"Organisation ID: {id_}\n"
            f"Organisation URL: {url}\n\n"
            "Your message:\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class ProposeAnnouncementView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        to_user_id = 1  # admin
        subject = "Announcement proposal"
        content = (
            "Title:\n\n"
            "Working web link to further information:\n\n"
            "Short description:\n\n"
            "Start Date:\n\n"
            "End Date:\n\n"
            "What is your connection to this announcement?\n\n"
            "Your name and contact details (optional):\n\n"
        )
        return {"to_user": to_user_id, "subject": subject, "content": content}


class RequestContributorPermissionsView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        subject = "Contributor permission request"
        content = (
            "Why are you making this request?\n>>>\n\n"
            "Your name and contact details:\n>>>\n\n"
        )
        return {"to_user": 1, "subject": subject, "content": content}


class ProjectRequestDataChangeView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        project_id = self.kwargs.get("pk")
        project = Project.objects.get(pk=project_id)
        subject = f"Project data change request"
        if project.owner:
            user_id = project.owner.id
        else:
            user_id = 1  # admin

        title = project.title
        coped_id = project.coped_id
        id_ = project.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = project.get_absolute_url()
        url = proto + host + path

        content = (
            f"Project title: {title}\n"
            f"Project CoPED ID: {coped_id}\n"
            f"Project ID: {id_}\n"
            f"Project URL: {url}\n\n"
            "What needs to be changed?\n>>>\n\n"
            "What is your involvement with the project?\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class PersonRequestDataChangeView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        person_id = self.kwargs.get("pk")
        person = Person.objects.get(pk=person_id)
        subject = f"Person data change request"
        if person.owner:
            user_id = person.owner.id
        else:
            user_id = 1  # admin

        full_name = person.full_name
        coped_id = person.coped_id
        id_ = person.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = person.get_absolute_url()
        url = proto + host + path

        content = (
            f"Person: {full_name}\n"
            f"Person CoPED ID: {coped_id}\n"
            f"Person ID: {id_}\n"
            f"Person URL: {url}\n\n"
            "What needs to be changed?\n>>>\n\n"
            "What is your involvement with the person?\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class OrganisationRequestDataChangeView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        organisation_id = self.kwargs.get("pk")
        organisation = Organisation.objects.get(pk=organisation_id)
        subject = f"Organisation data change request"
        if organisation.owner:
            user_id = organisation.owner.id
        else:
            user_id = 1  # admin

        name = organisation.name
        coped_id = organisation.coped_id
        id_ = organisation.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = organisation.get_absolute_url()
        url = proto + host + path

        content = (
            f"Organisation: {name}\n"
            f"Organisation CoPED ID: {coped_id}\n"
            f"Organisation ID: {id_}\n"
            f"Organisation URL: {url}\n\n"
            "What needs to be changed?\n>>>\n\n"
            "What is your involvement with the organisation?\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class ProjectClaimOwnershipView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        user_id = 1
        project_id = self.kwargs.get("pk")
        project = Project.objects.get(pk=project_id)
        subject = f"Project ownership request"

        title = project.title
        coped_id = project.coped_id
        id_ = project.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = project.get_absolute_url()
        url = proto + host + path

        content = (
            f"Project title: {title}\n"
            f"Project CoPED ID: {coped_id}\n"
            f"Project ID: {id_}\n"
            f"Project URL: {url}\n\n"
            "What is your involvement with the project?\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class PersonClaimOwnershipView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        user_id = 1
        person_id = self.kwargs.get("pk")
        person = Person.objects.get(pk=person_id)
        subject = f"Person record ownership request"

        full_name = person.full_name
        coped_id = person.coped_id
        id_ = person.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = person.get_absolute_url()
        url = proto + host + path

        content = (
            f"Person: {full_name}\n"
            f"Person CoPED ID: {coped_id}\n"
            f"Person ID: {id_}\n"
            f"Person URL: {url}\n\n"
            "What is your involvement with the person?\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}


class OrganisationClaimOwnershipView(LoginRequiredMixin, MessageCreateView):
    def get_initial(self):
        user_id = 1
        organisation_id = self.kwargs.get("pk")
        organisation = Organisation.objects.get(pk=organisation_id)
        subject = f"Organisation record ownership request"

        name = organisation.name
        coped_id = organisation.coped_id
        id_ = organisation.id
        proto = "https://" if self.request.is_secure() else "http://"
        host = self.request.get_host()
        path = organisation.get_absolute_url()
        url = proto + host + path

        content = (
            f"Organisation: {name}\n"
            f"Organisation CoPED ID: {coped_id}\n"
            f"Organisation ID: {id_}\n"
            f"Organisation URL: {url}\n\n"
            "What is your involvement with the organisation?\n>>>\n\n"
            "Your name and contact details (optional):\n>>>\n\n"
        )
        return {"to_user": user_id, "subject": subject, "content": content}
