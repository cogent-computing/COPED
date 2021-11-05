from django.shortcuts import render
from django.http import HttpResponse


def index(request):
    return render(request, "index.html")


def up(request):
    return HttpResponse("CoPED web application is up and running.")
