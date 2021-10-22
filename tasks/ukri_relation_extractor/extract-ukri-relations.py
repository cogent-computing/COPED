#!/usr/bin/env python

"""Extract internal relations from UKRI documents and save back as metadata."""

import click
import couchdb


def links_in_doc(ukri_doc):
    """Parse the document `links` field to find the related UKRI UUIDs."""

    item_type = ukri_doc["item_type"]
    # Exclude links that do not involve a project
    if item_type != "project":
        return

    extracted_link_data = []
    links_in_document = ukri_doc["item_data"].get("links", dict()).get("link", [])
    for link in links_in_document:
        href = link.get("href", "")
        rel = link.get("rel", "")
        ukri_uuid = href.split("/")[-1]
        extracted_link_data.append({ukri_uuid: rel})

    return extracted_link_data


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
        meta = doc.get("coped_meta", {})
        meta["coped_links"] = links_in_doc(doc)
        doc["coped_meta"] = meta
        couch.save(doc)


if __name__ == "__main__":
    main()
