"""
Custom middleware to add and remove Metabase cookies to/from HTTP responses.

Django's session cookies take care of authenticating users to access the CoPED platform.
But Metabase cookies are also needed by the browser to be able to access the Metabase UI
seamlessly, without requiring an additional login. This middleware adds/removes the
needed Metabase cookie containing the value of a valid Metabase session token.

Note: custom login and logout signal handlers in `signals.py` take care of calling the
Metabase API to get valid session tokens when users authenticate using CoPED credentials.

Warning: same origin security policies require CoPED and the Metabase service to be
available on the same origin. This means a different host/port for Metabase to those
used by the web service running Django will cause problems. A reverse proxy such as
Nginx as used by CoPED avoids this by making Metabse available on a path under the
same hostname as used by the Django web service.
"""

from django.conf import settings
from ..models import MetabaseSession


def metabase_cookie_middleware(get_response):
    def middleware(request):

        # Pre-process the request here if needed
        pass

        # Send the request downstream
        response = get_response(request)

        # Post-process the response here if needed
        if request.user.is_authenticated and not request.COOKIES.get(
            "metabase.SESSION"
        ):
            token = request.user.metabasesession.token
            if settings.DEBUG:
                print("Metabase cookie middleware. Token", token)
            response.set_cookie("metabase.SESSION", token, httponly=True)

        elif (
            request.COOKIES.get("metabase.SESSION")
            and not request.user.is_authenticated
        ):
            response.delete_cookie("metabase.SESSION")

        # Pass the response back upstream
        return response

    return middleware
