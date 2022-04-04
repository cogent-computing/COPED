import logging
import os
import sys
import django
import fiona
import shapely.geometry
from pyproj import CRS, Transformer
from operator import itemgetter

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import GeoData

# Data appear in different coordinate systems so we need to translate them.

# EPSG code for DNO shapefile data is 27700
# See: https://epsg.io/27700
crs_27700 = CRS.from_epsg(27700)

# EPSG code for address longitude and latitude is 4326
# See: https://epsg.io/4326
crs_4326 = CRS.from_epsg(4326)

# Define the translation
eastnorth_from_latlong = Transformer.from_crs(crs_4326, crs_27700).transform

exclude_already_tagged = True
geo_points = GeoData.objects.all()
if exclude_already_tagged:
    geo_points = geo_points.exclude(dno_id__isnull=False)

with fiona.open("/tmp/dno_license_areas_20200506/DNO_License_Areas_20200506.shp") as fiona_collection:
    print(fiona_collection)

    for geo_point in geo_points:

        lat, lon = geo_point.lat, geo_point.lon
        query_point = eastnorth_from_latlong(lat, lon)
        query_point = shapely.geometry.Point(query_point)

        for shapefile_record in iter(fiona_collection):
            record_type, record_id, record_properties, record_geometry = itemgetter("type", "id", "properties", "geometry")(shapefile_record)

            shape = shapely.geometry.shape( record_geometry )

            if shape.contains(query_point):
                dno_id = record_properties.get("ID")
                logging.info("DNO %s contains test point %s (%s, %s)", dno_id, geo_point.id, lat, lon)
                geo_point.dno_id = dno_id
                geo_point.save()
                break

