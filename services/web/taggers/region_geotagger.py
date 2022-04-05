import logging
import os
import sys
import django
import fiona
import shapely.geometry
from pyproj import CRS, Transformer
from operator import itemgetter
from celery import shared_task

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import GeoData

@shared_task(name="Automatic DNO region tagger")
def tag_geo_points_with_dno_regions(exclude_already_tagged=True, limit=None):

    geo_points = GeoData.objects.all()
    if exclude_already_tagged:
        geo_points = geo_points.exclude(dno_id__isnull=False)
    limit = limit or geo_points.count()

    logging.info("Tagging points with DNO region ids")
    dirname = os.path.dirname(__file__)
    geojson_filename = os.path.join(dirname, "geojson/dno_license_areas_20200506.polar.geojson")
    with fiona.open(geojson_filename) as fiona_collection:

        for geo_point in geo_points[:limit]:
            logging.debug("point %s", geo_point)

            lat, lon = geo_point.lat, geo_point.lon
            query_point = shapely.geometry.Point(lon,lat)
            logging.debug("query point is %s", query_point)

            for shapefile_record in iter(fiona_collection):
                record_type, record_id, record_properties, record_geometry = itemgetter("type", "id", "properties", "geometry")(shapefile_record)

                shape = shapely.geometry.shape( record_geometry )

                if shape.contains(query_point):
                    dno_id = record_properties.get("ID")
                    dno_name = record_properties.get("Name")
                    dno_long_name = record_properties.get("LongName")

                    logging.info("DNO %s contains test point %s (%s, %s)", dno_id, geo_point.id, lat, lon)

                    geo_point.dno_id = dno_id
                    geo_point.dno_name = dno_name
                    geo_point.dno_long_name = dno_long_name
                    geo_point.save()
                    break

if __name__ == "__main__":
    tag_geo_points_with_dno_regions(exclude_already_tagged=False, limit=10)
