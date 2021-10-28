#!/usr/bin/env python

"""Index CoPED-managed CouchDB documents into Elasticsearch."""

import click
from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import Document
from elasticsearch_dsl import Index
from shared.utils import coped_logging as log
from shared.databases import Couch


@click.command()
@click.option(
    "--refresh/--no_refresh",
    default=False,
    help="Remove all existing links before adding new ones.",
)
def main(refresh):
    """Index CoPED-managed CouchDB documents into Elasticsearch."""

    log.info("Indexing CoPed documents from CouchDB to Elasticsearch.")

    connections.create_connection(
        hosts=["elasticsearch"], http_auth=("elastic", "password")
    )

    coped_idx = Index("coped")

    if refresh:
        log.warning("Deleting the 'coped' index from ElasticSearch.")
        coped_idx.delete()

    if not coped_idx.exists():
        log.info("Creating new index 'coped' in ElasticSearch")
        coped_idx.settings(number_of_shards=1, number_of_replicas=0)
        coped_idx.create()

    @coped_idx.document
    class CopedDoc(Document):
        pass

    couch = Couch()
    db = couch.db
    count = 0
    for coped_doc in couch.coped_docs():
        doc = db[coped_doc.id]
        es_doc = CopedDoc(**doc)
        es_doc.meta.id = doc.id
        es_doc.save()
        count += 1
        log.debug(f"Indexed document {coped_doc.id} into Elastic")

    log.info(f"Indexing complete on {count} documents.")


if __name__ == "__main__":
    main()
