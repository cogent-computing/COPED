#!/usr/bin/env python

"""Extract internal relations implied by UKRI document links and save back as metadata."""

import click
from deepmerge import always_merger
from shared.utils import coped_logging as log
from shared.databases import couch_client
from shared.documents import find_ukri_doc
from shared.documents import save_document
from shared.documents import different_docs


def get_links_or_add(doc):
    """Get the existing links in the document."""

    item_links = doc["coped_meta"].get("item_links", {})
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

    db = couch_client()

    for doc_id in db:

        doc = db[doc_id]
        links = get_links_or_add(doc)

        if refresh:
            log.info(f"Removing existing links for document {doc_id}")
            links = {}

        item_source = doc["coped_meta"].get("item_source", "")

        if item_source != "ukri-projects-spider":
            log.debug(f"Doc {doc_id} source is not 'ukri-projects-spider'. Skipping.")
            continue

        log.info(f"Extracting links for UKRI document {doc_id}")
        raw_links = doc.get("raw_data").get("links", {}).get("link", [])
        extracted_links = {}

        for link in raw_links:
            href = link.get("href", "")
            rel = link.get("rel", "")
            if not href or not rel:
                # The linked resource can only be found via a URL or
                # using the UUID in the URL. Neither is possible without
                # the href having a value. Forget the link in this situation.
                # Similarly, if there is no "rel" attribute we don't know
                # the type of the relation, so forget it in this case too.
                log.warning("No href or no rel attribute in link. Ignoring.")
                continue

            # Search for the document using its UKRI id.
            ukri_id = href.split("/")[-1]
            matching_doc = find_ukri_doc(ukri_id)

            if matching_doc is None:
                # The linked resource is not in CoPED's CouchDB whenever
                # its connection to a project in CouchDB is too indirect.
                # Forget the link in this situation.
                log.debug(f"Link to href {href} not found in DB. Ignoring.")
                continue

            # Add the found document's id to the link keys for this doc.
            # The value is in a list to allow multiple links to the same doc.
            _id = matching_doc.id
            link_list = extracted_links.get(_id, list())
            extracted_links[_id] = link_list + [
                {"rel": rel, "src": "urki_link_extractor"}
            ]

        # Once all the links are processed, check if anything changed.
        # If it did, save the document again.
        merged_links = always_merger.merge(extracted_links, links)
        if different_docs(merged_links, links) or update_existing:
            doc["coped_meta"]["item_links"] = merged_links
            save_document(doc, "ukri_link_extractor updated")
            log.info(f"Links for document {doc_id} extracted and saved.")
        else:
            log.info(f"No new links found for document {doc_id}.")


if __name__ == "__main__":
    main()
