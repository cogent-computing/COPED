from rest_framework import serializers
from core.models.external_link import ExternalLink


###############
## URL Links ##
###############


class ExternalLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExternalLink
        fields = ["link", "description"]
