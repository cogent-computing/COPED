import secrets
import datetime
import pytz

from django.core.paginator import Paginator
from django.views import generic
from django.urls import reverse
from django.http import JsonResponse
from django.shortcuts import render
from django.shortcuts import redirect
from django.template.loader import render_to_string
from django.contrib import auth
from django.contrib import messages
from django.contrib.auth.mixins import UserPassesTestMixin

# from django.http import HttpRequest

from .models.project import Project
from .filters import ProjectFilter
from .forms import RegisterForm
from .models import User
from .models import PasswChange
from .models import Subject

from elasticsearch_dsl.query import MoreLikeThis
from .documents import ProjectDocument


def index(request):
    return render(request, "index.html")


class UserDetailView(UserPassesTestMixin, generic.DetailView):
    model = User
    context_object_name = "user_record"

    def test_func(self):
        return self.request.user.id == self.get_object().id


class ProjectListView(generic.ListView):
    model = Project
    paginate_by = 10


class ProjectDetailView(generic.DetailView):
    model = Project


def subject_suggest(request):
    """Provide a list of possible subjects to search for. Useful for auto-complete."""

    results = []
    term = request.GET.get("term", "")
    if len(term) > 2:
        subjects = Subject.objects.filter(label__contains=term).values_list("label")
        results = [s[0] for s in subjects]

    return JsonResponse({"results": results})


def project_list(request):
    """Main filterable search page for project searches."""

    # TODO: catch non numeric parameters
    more_like_this = request.GET.get("mlt", None)
    if more_like_this:
        more_like_this = int(more_like_this)
        s = ProjectDocument.search()
        s = s.query(
            MoreLikeThis(like={"_id": more_like_this}, fields=["title", "description"])
        )
        # TODO: think about thresholding on the result scores
        s = s.extra(size=400)
        qs = s.to_queryset()
    else:
        qs = Project.objects.all()

    # TODO: prepopulate form with any query term from previous page

    f = ProjectFilter(request.GET, queryset=qs)
    paginate_by = 20
    paginator = Paginator(f.qs, paginate_by)
    page_number = request.GET.get("page", 1)
    page_obj = paginator.get_page(page_number)
    page_list_start_number = (int(page_number) - 1) * paginate_by + 1

    context = {
        "page_obj": page_obj,
        "is_paginated": True,
        "list_start": page_list_start_number,
        "filter": f,
    }
    if more_like_this:
        context.update({"more_like_this": Project.objects.get(pk=more_like_this)})

    print("QUERYSTRING in VIEW")
    print(request.GET)
    if request.GET.get("mlt", None):
        print("WANT MORE LIKE THIS")
    else:
        print("REGULAR SEARCH QUERY")

    return render(
        request,
        "core/project_list.html",
        context,
    )


# Logins and registration


def login(request):
    if request.user.is_authenticated:
        return render(request, "index.html")

    if request.method == "POST":
        username = request.POST.get("email")
        password = request.POST.get("password")
        user = auth.authenticate(email=username, password=password)
        if user is not None:
            # correct username and password login the user
            auth.login(request, user)
            messages.success(request, "Successfully logged in")
            if request.META.get("HTTP_REFERER") is not None:
                return redirect(request.META.get("HTTP_REFERER"))
            return redirect("index")

        else:
            messages.error(request, "Wrong username or password")
            if request.META.get("HTTP_REFERER") is not None:
                return redirect(request.META.get("HTTP_REFERER"))
            return redirect("index")

    return redirect("index")


def register(request):
    if request.method == "POST":
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            user.set_password(user.password)
            # Save information to CouchDB
            # u_id = c_con.create_user(user)
            # user.u_id = u_id
            # # permission to own page
            # user.res_perm_list = [user.u_id]
            user.save()
            auth.login(request, user)
            messages.success(
                request,
                "Successfully created user and logged in. Please complete your profile.",
            )
            # Create equivalent in couchdb with not Visible to others
            return redirect("index")
        else:
            messages.error(request, "Invalid Registration or Duplicate User email")
            return redirect("index")

    return redirect("index")


def logout(request):
    auth.logout(request)
    messages.info(request, "Logged out successfully")
    return redirect("index")


def password_reset(request):
    if request.method == "POST":
        if "email" in request.POST:
            email = request.POST.get("email")
            if User.objects.filter(email=email).exists():
                cu = User.objects.filter(email=email)
                if len(cu) != 0:
                    cu = cu[0]
                    secret = secrets.token_urlsafe(32)
                    pw_change = PasswChange(
                        email=cu.email, sender=cu.coped_id, secret=secret
                    )
                    pw_change.save()
                    name = cu.first_name if cu.first_name is not None else ""
                    name += " " + cu.last_name if cu.last_name is not None else ""
                    subject = "CoPED - Password Reset"
                    content = render_to_string(
                        "registration/password_reset_email.txt",
                        {
                            "email": cu.email,
                            "secret": secret,
                            "uri": request.build_absolute_uri(
                                location=reverse("password_update")
                            ),
                        },
                    )
                    print("SENDING EMAIL")
                    print(email, name, subject, content)
                    # c_con.send_email(email, name, subject, content)
            else:
                pass
            messages.info(
                request,
                "If your email address is registered then a password reset email will be sent.",
            )
            return redirect("index")
    else:
        return render(request, "registration/password_reset.html")


def password_update(request):
    if request.method == "GET":
        if "secret" in request.GET:
            secret = request.GET.get("secret")
            return render(
                request, "registration/password_update.html", {"secret": secret}
            )
        else:
            if request.user.is_authenticated:
                return render(request, "registration/password_update.html")
    if request.method == "POST":
        if "password" in request.POST:
            if "secret" in request.POST:
                secret = request.POST.get("secret")
                password = request.POST.get("password")
                pw_c = PasswChange.objects.filter(secret=secret, used=False)
                if len(pw_c) != 0:
                    pw_c = pw_c[0]
                    pw_c.used = True
                    pw_c.save()
                    if pw_c.date_requested > datetime.datetime.now(
                        tz=pytz.timezone("Europe/London")
                    ) - datetime.timedelta(days=5):
                        user = User.objects.filter(email=pw_c.email)
                        if len(user) != 0:
                            user = user[0]
                            user.set_password(password)
                            user.save()
                            auth.login(request, user)
                            messages.info(
                                request, "Password Updated for user using reset email"
                            )
                            return redirect("index")
                messages.info(
                    request, "Password Token has already been used, is old or invalid"
                )
                return redirect("index")
            else:
                if request.user.is_authenticated:
                    password = request.POST.get("password")
                    request.user.set_password(password)
                    request.user.save()
                    auth.login(request, request.user)
                    messages.info(request, "Password Updated for logged in User")
                    return redirect("index")
    messages.error(request, "Wrong use of Password update url")
    return redirect("index")
