"""Shared code for working with CoPED-managed documents."""

import logging
from uuid import uuid4
from datetime import datetime
from deepdiff import DeepDiff
from shared.databases import couch_client


def different_docs(doc_1, doc_2):
    """Given two documents, are they different?"""
    diff = DeepDiff(dict(doc_1), dict(doc_2), ignore_order=True)
    logging.debug(f"DOCUMENT DIFF = {diff}")
    return bool(diff)


def find_ukri_doc(ukri_id):
    """Search CouchDB for the given UKRI id."""
    db = couch_client()

    # TODO: create an index on `coped_meta.item_id` for speed.
    query = {
        "selector": {"coped_meta": {"item_id": ukri_id}},
        "fields": ["_id"],
    }

    result = list(db.find(query))
    item_found = bool(len(result))

    if item_found:
        # Return the full document to the caller.
        _id = result[0]["_id"]
        return db[_id]
    else:
        return None


def update_document(doc, update_message):
    """Update an existing document and record a message in the `coped_meta.updates` field."""

    updates = doc["coped_meta"]["item_updates"]
    now = datetime.now().utcnow().isoformat()
    update = {now: update_message}
    doc["coped_meta"]["item_updates"] = updates | update  # merge the new update

    db = couch_client()
    db[doc.id] = doc
    return doc


def create_document(doc):
    """Create a new document in the CouchDB database."""

    db = couch_client()
    _id = str(uuid4()).upper()
    db[_id] = doc
    return _id


def get_ukri_links_or_add(doc):
    """Get the existing UKRI links in the document. If none exist, add the field."""

    item_links = doc["coped_meta"].get("item_links", {})
    if not bool(item_links):
        doc["coped_meta"]["item_links"] = {}

    ukri_links = doc["coped_meta"]["item_links"].get("ukri", {})
    if not bool(ukri_links):
        doc["coped_meta"]["item_links"]["ukri"] = {}

    return doc["coped_meta"]["item_links"]["ukri"]
