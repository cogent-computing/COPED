#!/usr/bin/env python

"""Transfer IDs of pairs of resources, and their relation types, from CouchDB to PostgreSQL.

This script builds or extends the "coped_relation" table in PSQL.
"""

import click
from couchdb.http import ResourceNotFound
from shared.utils import coped_logging as log
from shared.databases import couch_client
from shared.tables import coped_allowed_items
from shared.tables import coped_allowed_relations
from shared.tables import coped_upsert_relation
from shared.tables import coped_resources
from shared.tables import coped_resource_exists


@click.command()
def main():
    """Parse CouchDB documents for relations and upsert them to PSQL."""

    log.info("Adding relations to PostgreSQL from CouchDB.")

    # Get the allowed resource and relation types from the DB.
    # This ensures we can pre-filter to avoid unknown entities/relations.
    allowed_items = coped_allowed_items()
    allowed_relations = coped_allowed_relations()

    count = 0
    couch = couch_client()

    # Iterate through UUIDs in the PostgreSQL coped_resource table.
    # Look them up in CouchDB and extract their relations.
    for doc1_id in coped_resources():
        try:
            doc1 = couch[doc1_id]
        except ResourceNotFound:
            log.warning(f"Item {doc1_id} in PSQL not found in CouchDB. Skipping.")
            continue

        item_type = doc1["coped_meta"].get("item_type", None)

        # Filter unknown resource types.
        if item_type not in allowed_items:
            log.info(f"Item type {item_type} not allowed for doc {doc1_id}. Skipping.")
            continue

        item_links = doc1["coped_meta"].get("item_links", {})

        for doc2_id in item_links:
            # Ensure related entity is available in PSQL.
            if not coped_resource_exists(doc2_id):
                log.warning(f"Document {doc2_id} not in resource table. Skipping.")
                continue

            # Now extract the relation and insert it into PSQL.
            for relation in item_links[doc2_id]:
                rel = relation.get("rel", "")

                # Filter unknown relation types.
                if rel not in allowed_relations:
                    log.warning(
                        f"Relation {rel} from {doc1_id} to {doc2_id} not allowed. Skipping."
                    )
                    continue

                # Everything checked out, so add the relation to the table in PSQL.
                coped_upsert_relation(rel, doc1_id, doc2_id)
                log.debug(
                    f"Upserted relation ({rel}, {doc1_id}, {doc2_id}) to PostgreSQL"
                )
                count += 1

    log.info(f"Processed {count} document relations.")


if __name__ == "__main__":
    main()
