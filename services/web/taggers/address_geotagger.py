#!/usr/bin/env python

"""Associate latitude/longitude to organisation addresses stored in the CoPED database.

Locating and mapping energy project participant organisations requires accurate geo data.
We use the OpenStreetMap (OSM) Foundation Nominatim service to geocode freeform addresses,
and the API at postcodes.io to geocode postodes when present using OS Open Data .

See the following links for details:

    - https://operations.osmfoundation.org/
    - https://operations.osmfoundation.org/policies/
    - https://nominatim.org/release-docs/develop/
    - https://nominatim.geocoding.ai/search.html
    - https://nominatim.org/release-docs/develop/api/Search/
    - https://postcodes.io/about
    - https://postcodes.io/docs
"""

import time
import json
import os
import sys
import django
from django.db import transaction
from celery import shared_task

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import Address
from core.models import GeoData
from core.models import AppSetting
import requests


try:
    USER_AGENT = AppSetting.objects.get(slug="COPED_USER_AGENT").value
except AppSetting.DoesNotExist:
    USER_AGENT = "CoPEDbot/0.1 (Catalogue of Projects on Energy Data) Crawler"
common_headers = {"User-Agent": USER_AGENT}
nominatim_url = "https://nominatim.openstreetmap.org/search"
current_postcode_checker_url = "https://api.postcodes.io/postcodes"
terminated_postcode_checker_url = "https://api.postcodes.io/terminated_postcodes"


def lat_lon_from_postcode(postcode):
    """Use postcodes.io to get a lat and lon from the given postcode."""

    def query_postcodes_api(url):
        endpoint = f"{url}/{postcode}"
        try:
            r = requests.get(endpoint, headers=common_headers, timeout=10)
        except requests.RequestException as e:
            print(f"Request to {endpoint} failed with exception:\n{e}\n")
            raise e
        if r.status_code == requests.codes.ok:
            result = json.loads(r.content).get("result", {})
            return result.get("latitude"), result.get("longitude")
        else:
            return None

    latlon = query_postcodes_api(current_postcode_checker_url)
    if latlon:
        return latlon

    latlon = query_postcodes_api(terminated_postcode_checker_url)
    if latlon:
        return latlon

    return None


def lat_lon_from_address_string(address_string):
    """Use Nominatim to look for a given freeform text address."""

    params = {
        "format": "jsonv2",
        "accept-language": "en-GB",
        # TODO: get the admin email below from the DB
        # See https://nominatim.org/release-docs/develop/api/Search/#other
        "email": "ab5169@coventry.ac.uk",
        "q": address_string,
    }
    try:
        r = requests.get(
            nominatim_url, headers=common_headers, params=params, timeout=10
        )
    except requests.RequestException as e:
        print(f"Request to {nominatim_url} failed with exception:\n{e}\n")
        print(f"Parameters used: {params}")
        raise e

    if r.status_code != requests.codes.ok:
        return None

    geo_data = json.loads(r.content)
    if not geo_data:
        return None

    top_result = geo_data[0]
    latlon = top_result.get("lat"), top_result.get("lon")
    return latlon


@shared_task(name="Automatic address geocoder")
def tag_addresses_with_geo_data(exclude_already_tagged=True, limit=None):
    """Send addresses to the geo-search API at Nominatim.

    Add the geotag to the DB if it does not already exist and point the input
    address to it.

    If an address lookup does not find results, then use the catchall
    values (0,0) for (lat,lon) coordinates. This allows skipping previously
    geocoded addresses, even if they failed."""

    if exclude_already_tagged:
        addresses_to_process = Address.objects.filter(geo__isnull=True)
    else:
        addresses_to_process = Address.objects.all()

    total_addresses = addresses_to_process.count()
    if limit is None:
        limit = total_addresses  # Number of projects to tag.

    count = 0

    for address in addresses_to_process[:limit]:
        time.sleep(1)  # Go easy on the geocoding servers.
        count += 1
        print(
            f"Geotagging address {count} of {limit} from {total_addresses} (id={address.id})."
        )

        latlon = None
        if address.postcode is not None and address.postcode.strip() != "":
            latlon = lat_lon_from_postcode(address.postcode)

        if latlon is None:
            latlon = lat_lon_from_address_string(f"{address}")

        if latlon is None:
            latlon = 0.0, 0.0

        lat, lon = latlon
        print("Location:", lat, lon, sep="\t")

        with transaction.atomic():
            geo_data_record, _ = GeoData.objects.get_or_create(lat=lat, lon=lon)
            address.geo = geo_data_record
            address.save(update_fields=["geo"])


if __name__ == "__main__":
    tag_addresses_with_geo_data(exclude_already_tagged=True, limit=200)
