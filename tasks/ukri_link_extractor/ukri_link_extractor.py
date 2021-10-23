#!/usr/bin/env python

"""Extract internal relations implied by UKRI document links and save back as metadata."""

import os
import logging
import click
import couchdb
from deepdiff import DeepDiff
from datetime import datetime

LOGLEVEL = os.environ.get("LOGLEVEL", "INFO").upper()
logging.basicConfig(level=LOGLEVEL)


def different_data(doc_1, doc_2):
    """Given two documents, are they different?"""
    diff = DeepDiff(dict(doc_1), dict(doc_2), ignore_order=True)
    return bool(diff)


@click.command()
@click.option("--couchdb_host", envvar="COUCHDB_HOST")
@click.option("--couchdb_port", envvar="COUCHDB_PORT")
@click.option("--couchdb_user", envvar="COUCHDB_USER")
@click.option("--couchdb_password", envvar="COUCHDB_PASSWORD")
@click.option("--couchdb_db", envvar="COUCHDB_DB")
def main(
    couchdb_host,
    couchdb_port,
    couchdb_user,
    couchdb_password,
    couchdb_db,
):

    COUCHDB_URI = (
        f"http://{couchdb_user}:{couchdb_password}@{couchdb_host}:{couchdb_port}/"
    )
    couch_conn = couchdb.Server(COUCHDB_URI)
    couch = couch_conn[couchdb_db]

    for doc_id in couch:

        doc = couch[doc_id]

        meta = doc.get("coped_meta", None)
        if meta is None:
            logging.warning(
                f"No coped_meta data found in CouchDB document {doc_id}. Skipping."
            )
            continue

        item_source = meta.get("item_source", "")
        if item_source != "ukri-projects-spider":
            logging.debug(
                f"Document {doc_id} is not from the UKRI project spider. Ignoring"
            )
            continue

        logging.info(f"Extracting links for document {doc_id}")
        item_links = doc.get("coped_meta").get("item_links", {})
        raw_links = doc.get("raw_data").get("links", dict()).get("link", [])
        extracted_links = {}

        for link in raw_links:
            href = link.get("href", "")
            if not href:
                # The linked resource can only be found via a URL or
                # using the UUID in the URL. Neither is possible without
                # the href having a value. Forget the link in this situation.
                logging.debug("No href attribute in link. Ignoring.")
                continue
            uuid = href.split("/")[-1]
            # If there is no `rel` attribute we don't know the nature
            # of the relation. Keep it, but label it using a default catch-all.
            rel = link.get("rel", "GENERAL_RELATION")

            # Search for the document using its UKRI id.
            # TODO: create an index on `coped_meta.item_id` for speed.
            query = {
                "selector": {"coped_meta": {"item_id": uuid}},
                "fields": ["_id"],
            }
            result = list(couch.find(query))
            item_found = bool(len(result))

            if not item_found:
                # The linked resource is not in CouchDB whenever
                # its connection to a project in CouchDB is too indirect.
                # Forget the link in this situation.
                logging.debug(f"Link to href {href} not found in DB. Ignoring.")
                continue

            _id = result[0].id
            if _id in item_links:
                # The link has already been extracted.
                logging.debug(f"Link to document id {_id} already present. Ignoring.")
                continue

            # Add the found document's CouchDB id to the list of link keys.
            # Its value will describe the nature of the link.
            logging.info(f"Adding new link from {doc_id} to {_id}.")
            extracted_links[_id] = rel

        # Once all the links are processed, check if anything changed.
        # If it did, save the document again.
        merged_links = item_links | extracted_links
        if different_data(item_links, merged_links):
            doc.get("coped_meta")["item_links"] = merged_links
            now = datetime.now().utcnow().isoformat()
            doc.get("coped_meta")["item_updates"][now] = f"ukri_link_extractor updated"
            couch[doc_id] = doc
            logging.info(f"Links for document {doc_id} extracted and saved.")
        else:
            logging.info(f"No new links found for document {doc_id}.")


if __name__ == "__main__":
    main()
