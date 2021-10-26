"""Shared code for working with CoPED-managed documents inside CouchDB."""

from uuid import uuid4
from functools import cache
from datetime import datetime
from deepdiff import DeepDiff
from shared.databases import Couch
from shared.utils import coped_logging as log


def different_docs(doc_1, doc_2):
    """Given two documents, are they different?"""
    diff = DeepDiff(dict(doc_1), dict(doc_2), ignore_order=True)
    log.debug(f"DOCUMENT DIFF = {diff}")
    return bool(diff)


def find_ukri_doc(ukri_id):
    """Search CouchDB for the given UKRI id."""

    db = Couch().db
    query = {
        "selector": {"coped_meta.item_id": ukri_id},
        "fields": ["_id"],
    }
    result = list(db.find(query))

    if bool(len(result)):
        found_id = result[0]["_id"]
        return db[found_id]


def save_document(doc, update_message="document saved"):
    """Save document in CouchDB and record a message in the `coped_meta.updates` field."""

    # Add a document id if it needs one (document creation)
    try:
        _id = doc.id
    except AttributeError:
        _id = str(uuid4()).upper()

    # Get or create the updates field
    updates = doc["coped_meta"].get("item_updates", {})
    if not bool(updates):
        doc["coped_meta"]["item_updates"] = updates

    # Add message to the updates field
    now = datetime.now().utcnow().isoformat()
    update = {now: update_message}
    doc["coped_meta"]["item_updates"] = updates | update  # merge the new update

    # Save to the database
    db = Couch().db
    db[_id] = doc
    return db[_id]  # return the saved CouchDB document
