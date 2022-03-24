from django.contrib.auth.mixins import LoginRequiredMixin
from ..models import Project


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
            "Your messaage:\n>>>\n\n"
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
