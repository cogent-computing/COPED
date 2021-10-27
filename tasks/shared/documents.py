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


def different_lists(list1, list2):
    """Given two lists, are they different?"""
    diff = DeepDiff(list(list1), list(list2), ignore_order=True)
    log.debug(f"LIST DIFF = {diff}")
    return bool(diff)


def find_ukri_docs(ukri_ids):
    """Search CouchDB for the given list of UKRI ids."""

    return_one = False
    if type(ukri_ids) == str:
        # A single id should be included in a list.
        ukri_ids = [ukri_ids]
        # But we can still return the found doc on its own.
        return_one = True

    db = Couch().db
    query = {"selector": {"coped_meta.item_id": {"$in": ukri_ids}}}
    results = list(db.find(query))

    if len(results):
        if return_one:
            return results[0]
        else:
            return results


def save_document(doc, update_message="document saved"):
    """Save document in CouchDB and record a message in the `coped_meta.updates` field."""

    # Add a document id if it needs one (document creation)
    try:
        _id = doc.id
    except AttributeError:
        _id = str(uuid4()).upper()

    # Get the updates field
    updates = doc["coped_meta"].get("item_updates", [])

    # Add message to the updates field
    now = datetime.now().utcnow().isoformat()
    update = {"time": now, "message": update_message}
    updates.append(update)
    doc["coped_meta"]["item_updates"] = updates

    # Save changes to the database
    db = Couch().db
    db[_id] = doc
    return db[_id]  # return the saved CouchDB document
