#!/usr/bin/env python

"""Extract internal relations implied by UKRI document links and save back as metadata."""

import os
import logging
import click
from shared.databases import couch_client
from shared.documents import find_ukri_doc
from shared.documents import save_document
from shared.documents import different_docs
from shared.documents import get_ukri_links_or_add

LOGLEVEL = os.environ.get("LOGLEVEL", "INFO").upper()
logging.basicConfig(level=LOGLEVEL)


@click.command()
@click.option(
    "--update_existing/--no_update_existing",
    default=False,
    help="Overwrite existing UKRI links with extracted data.",
)
@click.option(
    "--refresh/--no_refresh",
    default=False,
    help="Remove all existing UKRI links before adding new ones.",
)
def main(update_existing, refresh):

    db = couch_client()

    for doc_id in db:

        doc = db[doc_id]

        item_source = doc["coped_meta"].get("item_source", "")
        if item_source != "ukri-projects-spider":
            logging.debug(f"{doc_id} is not from the UKRI project spider. Ignoring")
            continue

        ukri_links = get_ukri_links_or_add(doc)

        if refresh:
            logging.info(f"Removing existing UKRI links for document {doc_id}")
            ukri_links = {}

        logging.info(f"Extracting links for document {doc_id}")
        raw_links = doc.get("raw_data").get("links", {}).get("link", [])
        extracted_links = {}

        for link in raw_links:
            href = link.get("href", "")
            if not href:
                # The linked resource can only be found via a URL or
                # using the UUID in the URL. Neither is possible without
                # the href having a value. Forget the link in this situation.
                logging.debug("No href attribute in link. Ignoring.")
                continue
            ukri_id = href.split("/")[-1]
            # If there is no `rel` attribute we don't know the nature
            # of the relation. Keep it, but label it using a default catch-all.
            rel = link.get("rel", "GENERAL_RELATION")

            # Search for the document using its UKRI id.
            matching_doc = find_ukri_doc(ukri_id)

            if matching_doc is None:
                # The linked resource is not in CoPED's CouchDB whenever
                # its connection to a project in CouchDB is too indirect.
                # Forget the link in this situation.
                logging.debug(f"Link to href {href} not found in DB. Ignoring.")
                continue

            # Add the found document's CouchDB id to the list of link keys.
            # Its value will describe the nature of the link.
            _id = matching_doc.id
            extracted_links[_id] = {"rel": rel}

        # Once all the links are processed, check if anything changed.
        # If it did, save the document again.
        merged_links = ukri_links | extracted_links
        if different_docs(merged_links, ukri_links) or update_existing:
            doc["coped_meta"]["item_links"]["ukri"] = merged_links
            save_document(doc, "ukri_link_extractor updated")
            logging.info(f"Links for document {doc_id} extracted and saved.")
            logging.debug(f"Added links: {extracted_links}")
        else:
            logging.info(f"No new links found for document {doc_id}.")


if __name__ == "__main__":
    main()
