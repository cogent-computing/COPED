#!/usr/bin/env python

"""Transfer IDs of resources from CouchDB to PostgreSQL"""

import click
from shared.utils import coped_logging as log
from shared.databases import Couch
from shared.tables import coped_allowed_items
from shared.tables import coped_insert_resource


@click.command()
def main():

    log.info("Adding resources to PostgreSQL from CouchDB.")
    couch = Couch()
    db = couch.db

    # Get the allowed item types from the DB.
    # This allows filtering on known item types.
    allowed_items = coped_allowed_items()

    for coped_doc in couch.coped_docs():
        doc_id = coped_doc.id
        doc = db[doc_id]
        item_type = doc["coped_meta"].get("item_type", None)

        if item_type not in allowed_items:
            log.warning(f"Item type {item_type} of doc {doc_id} not allowed. Skipping.")
            continue

        coped_insert_resource(doc_id, item_type)


if __name__ == "__main__":
    main()
