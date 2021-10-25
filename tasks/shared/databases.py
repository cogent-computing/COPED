"""Shared code for accessing databases."""

import os
import couchdb
from couchdb.http import PreconditionFailed

# Database settings for CouchDB
COUCHDB_USER = os.environ.get("COUCHDB_USER", "coped")
COUCHDB_PASSWORD = os.environ.get("COUCHDB_PASSWORD", "password")
COUCHDB_HOST = os.environ.get("COUCHDB_HOST", "localhost")
COUCHDB_PORT = os.environ.get("COUCHDB_PORT", 5984)
COUCHDB_URI = f"http://{COUCHDB_USER}:{COUCHDB_PASSWORD}@{COUCHDB_HOST}:{COUCHDB_PORT}/"
COUCHDB_DB = os.environ.get("COUCHDB_DB", "ukri-dev-data")


def couch_client():
    """Create or connect to a CouchDB database using global environment settings."""
    server = couchdb.Server(COUCHDB_URI)
    try:
        # Create the DB if we need to.
        db = server.create(COUCHDB_DB)
    except PreconditionFailed:
        # If the DB exists then use it.
        db = server[COUCHDB_DB]

    return db
