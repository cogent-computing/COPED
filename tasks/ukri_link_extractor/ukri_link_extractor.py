#!/usr/bin/env python

"""Extract internal relations implied by UKRI document links and save back as metadata."""

import click
from deepmerge import always_merger
from shared.utils import coped_logging as log
from shared.databases import Couch
from shared.documents import find_ukri_docs
from shared.documents import save_document
from shared.documents import different_lists


def get_links_or_add(doc):
    """Get the existing links in the document."""

    item_links = doc["coped_meta"].get("item_links", [])
    if not bool(item_links):
        doc["coped_meta"]["item_links"] = item_links

    return doc["coped_meta"]["item_links"]


@click.command()
@click.option(
    "--update_existing/--no_update_existing",
    default=False,
    help="Overwrite existing links with extracted data.",
)
@click.option(
    "--refresh/--no_refresh",
    default=False,
    help="Remove all existing links before adding new ones.",
)
def main(update_existing, refresh):
    """Extract internal relations in UKRI documents and save to document meta-data."""

    couch = Couch()
    db = couch.db

    for coped_doc in couch.coped_docs():
        doc_id = coped_doc.id
        doc = db[doc_id]
        existing_links = get_links_or_add(doc)

        if refresh:
            log.info(f"Removing existing links for document {doc_id}")
            existing_links = []

        # TODO: write a view to get ukri-projects-spider source docs.
        item_source = doc["coped_meta"].get("item_source", "")
        if item_source != "ukri-projects-spider":
            log.debug(f"Doc {doc_id} source is not 'ukri-projects-spider'. Skipping.")
            continue

        log.info(f"Extracting links for UKRI document {doc_id}")
        raw_links = doc.get("raw_data").get("links", {}).get("link", [])

        ids_rels = {}
        for link in raw_links:
            href = link.get("href", "")
            rel = link.get("rel", "")
            if not href or not rel:
                log.warning("No href or no rel attribute in link. Ignoring.")
                continue

            # Pull out the UKRI id of the linked resource
            # and add the relation type to the list.
            ukri_id = href.split("/")[-1]
            ids_rels[ukri_id] = rel

        # Now look for all of the linked UKRI ids in the DB.
        ukri_ids = list(ids_rels.keys())
        matching_docs = find_ukri_docs(ukri_ids)

        if matching_docs is None:
            log.debug(f"No link targets for doc {doc_id} found in DB. Ignoring.")
            continue

        # Add the found documents ids to the link keys for this doc.
        # Pull in the list of rel values and sources from the ids_rels dict, as values.
        extracted_links = []
        for match in matching_docs:
            _id = match.id
            ukri_id = match["coped_meta"]["item_id"]
            rel = ids_rels[ukri_id]

            extracted_links.append(
                {"_id": _id, "rel": rel, "src": "ukri_link_extractor"}
            )

        log.debug(extracted_links)
        log.debug(existing_links)
        # Once all the links are processed, check if anything changed.
        # If it did, save the document again.
        merged_links = always_merger.merge(extracted_links, existing_links)
        if different_lists(merged_links, existing_links) or update_existing:
            doc["coped_meta"]["item_links"] = merged_links
            save_document(doc, "ukri_link_extractor updated")
            log.info(f"Links for document {doc_id} extracted and saved.")
        else:
            log.info(f"No new links found for document {doc_id}.")


if __name__ == "__main__":
    main()
