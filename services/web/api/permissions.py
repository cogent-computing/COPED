from rest_framework.permissions import BasePermission, SAFE_METHODS

class ReadOnlyPermission(BasePermission):
    def has_permission(self, request, view):
        return request.method in SAFE_METHODS

