#!/usr/bin/env python

"""Index CoPED-managed CouchDB documents into Elasticsearch."""

import click
from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import Document
from elasticsearch_dsl import Index
from shared.utils import coped_logging as log
from shared.databases import Couch


@click.command()
def main():
    """Index CoPED-managed CouchDB documents into Elasticsearch."""

    log.info("Indexing CoPed documents from CouchDB to Elasticsearch.")

    connections.create_connection(
        hosts=["elasticsearch"], http_auth=("elastic", "password")
    )

    coped = Index("coped")
    coped.settings(number_of_shards=1, number_of_replicas=0)
    coped.create(ignore=400)

    @coped.document
    class CopedDoc(Document):
        pass

    couch = Couch()
    db = couch.db
    coped_docs = couch.coped_docs()

    count = 0
    for coped_doc in coped_docs:
        doc = db[coped_doc.id]
        es_doc = CopedDoc(**doc)
        es_doc.meta.id = doc.id
        es_doc.save()
        count += 1
        log.debug(f"Indexed document {coped_doc.id} into Elastic")

    log.info(f"Indexing complete on {count} documents.")


if __name__ == "__main__":
    main()
