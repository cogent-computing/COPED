import logging
import os
import sys
import django
import fiona
import shapely.geometry
from operator import itemgetter
from celery import shared_task

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import GeoData


@shared_task(name="Automatic DNO region tagger")
def tag_geo_points_with_regions(limit=None):

    logging.info("Tagging points with region ids")

    geo_points = GeoData.objects.all()
    limit = limit or geo_points.count()

    # Set up mappings from model field names to GEOJSON properties.
    # Top-level keys are the file names of the corresponding data.
    geojson_mappings = {
        "Local_Authority_Districts_(December_2021)_UK_BUC.reduced.geojson": {
            "lad_id": "OBJECTID",
            "lad_code": "LAD21CD",
            "lad_name": "LAD21NM",
        },
        "dno_license_areas_20200506.polar.reduced.geojson": {
            "dno_id": "ID",
            "dno_name": "Name",
            "dno_long_name": "LongName",
        },
        "Countries_(December_2021)_UK_BUC.reduced.geojson": {
            "ctry_id": "OBJECTID",
            "ctry_code": "CTRY21CD",
            "ctry_name": "CTRY21NM",
        },
        "Counties_and_Unitary_Authorities_(December_2021)_UK_BUC.reduced.geojson": {
            "ctyua_id": "OBJECTID",
            "ctyua_code": "CTYUA21CD",
            "ctyua_name": "CTYUA21NM",
        },
    }

    dirname = os.path.dirname(__file__)

    for geojson_filename, geojson_field_mapping in geojson_mappings.items():

        geojson_file_path = os.path.join(dirname, "geojson", geojson_filename)

        with fiona.open(geojson_file_path) as fiona_collection:

            for geo_point in geo_points[:limit]:
                logging.debug("point %s, filename %s", geo_point, geojson_filename)

                lat, lon = geo_point.lat, geo_point.lon
                query_point = shapely.geometry.Point(lon, lat)

                for shapefile_record in iter(fiona_collection):

                    record_properties, record_geometry = itemgetter(
                        "properties", "geometry"
                    )(shapefile_record)

                    shape = shapely.geometry.shape(record_geometry)

                    if shape.contains(query_point):

                        for (
                            field_name,
                            json_property_name,
                        ) in geojson_field_mapping.items():
                            setattr(
                                geo_point,
                                field_name,
                                record_properties.get(json_property_name),
                            )

                        geo_point.save(update_fields=list(geojson_field_mapping.keys()))
                        break


if __name__ == "__main__":
    tag_geo_points_with_regions(limit=10)
