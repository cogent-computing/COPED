"""
Utility code to convert geographic coordinates.
DNO data from the following link is in EPSG:27700 coordinates.
- https://data.nationalgrideso.com/system/gis-boundaries-for-gb-dno-license-areas/r/gb_dno_license_areas_20200506_with_geojson
Standard latitude and longitude is EPSG:4326 coordinates.
This script will convert a GEOJSON file in one coordinate representation to the other.

NOTE: change `crs.properties.name` manually to new value "urn:ogc:def:crs:EPSG::4326" in the output file.
"""

import json
import codecs
import pyproj
import numbers
from pyproj import CRS, Transformer

# Define projections
crs_27700 = CRS.from_epsg(27700)
crs_4326 = CRS.from_epsg(4326)
polar = pyproj.Proj('epsg:4326')
transverse_mercator = pyproj.Proj('epsg:27700')

# Define the translations
eastnorth_from_latlong = Transformer.from_crs(crs_4326, crs_27700).transform
latlong_from_eastnorth = Transformer.from_crs(crs_27700, crs_4326).transform

def project_coords(coords):
    if len(coords) < 1:
        return []

    if isinstance(coords[0], numbers.Number):
        from_x, from_y = coords
        to_y, to_x = latlong_from_eastnorth(from_x, from_y)  # note order change
        return [to_x, to_y]

    new_coords = []
    for coord in coords:
        new_coords.append(project_coords(coord))
    return new_coords


def project_feature(feature):
    if not 'geometry' in feature or not 'coordinates' in feature['geometry']:
        print('Failed project feature', feature)
        return None

    new_coordinates = project_coords(feature['geometry']['coordinates'])
    feature['geometry']['coordinates'] = new_coordinates
    return feature


def read_data(geom_file):
    with open(geom_file, encoding='utf-8') as data:
        data = json.load(data)
    return data


def save_data(data, geom_file):
    json_data = json.dumps(data, indent=2)
    f = codecs.open(geom_file, "w")
    f.write(json_data)
    f.close()


def project_geojson_file(in_file, out_file):
    data = read_data(in_file)

    projected_features = []
    count = 0
    for feature in data['features']:
        count += 1
        print("Processing feature", count)
        projected_features.append(project_feature(feature))
    data['features'] = projected_features

    save_data(data, out_file)


if __name__ == "__main__":
    # Project geojson file from transverse_mercator to polar
    project_geojson_file('dno_license_areas_20200506.geojson', 'dno_license_areas_20200506.polar.geojson')
