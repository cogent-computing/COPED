#!/usr/bin/env python

"""Transfer IDs of resources from CouchDB to PostgreSQL"""

import os
import logging
import click
from shared.databases import couch_client
from shared.databases import psql_query

LOGLEVEL = os.environ.get("LOGLEVEL", "INFO").upper()
logging.basicConfig(level=LOGLEVEL)


@click.command()
def main():

    logging.info("Adding resources to PostgreSQL from CouchDB.")
    couch = couch_client()

    # Get the allowed item types from the DB.
    # This ensures the foreign key constraint on the coped_resource table will be met.
    query_string = "SELECT {type} FROM coped_resource_type;"
    allowed_items = [
        row[0]
        for row in psql_query(query_string, identifiers_dict={"type": "item_type"})
    ]
    logging.info(f"Allowed items: {allowed_items}")

    for doc_id in couch:
        doc = couch[doc_id]
        item_type = doc["coped_meta"].get("item_type", None)

        if item_type not in allowed_items:
            continue

        logging.info(f"adding resource ({doc_id}, {item_type}) to PostgreSQL")
        query_string = """
            INSERT INTO coped_resource (document_id, resource_type_id) VALUES (%s, %s)
            ON CONFLICT DO NOTHING;
            """
        psql_query(query_string, values=(doc_id, item_type))


if __name__ == "__main__":
    main()
