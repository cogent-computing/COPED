"""Shared code for accessing databases."""

import os
import couchdb
import psycopg2
from psycopg2 import sql


# Database settings for CouchDB
COUCHDB_HOST = os.environ.get("COUCHDB_HOST", "localhost")
COUCHDB_PORT = os.environ.get("COUCHDB_PORT", 5984)
COUCHDB_USER = os.environ.get("COUCHDB_USER", "coped")
COUCHDB_PASSWORD = os.environ.get("COUCHDB_PASSWORD", "password")
COUCHDB_DB = os.environ.get("COUCHDB_DB", "ukri-dev-data")
COUCHDB_URI = f"http://{COUCHDB_USER}:{COUCHDB_PASSWORD}@{COUCHDB_HOST}:{COUCHDB_PORT}/"

# Database settings for PostgreSQL
POSTGRES_HOST = os.environ.get("POSTGRES_HOST", "localhost")
POSTGRES_PORT = os.environ.get("POSTGRES_PORT", 5432)
POSTGRES_USER = os.environ.get("POSTGRES_USER", "coped")
POSTGRES_PASSWORD = os.environ.get("POSTGRES_PASSWORD", "password")
POSTGRES_DB = os.environ.get("POSTGRES_DB", "coped_development")


class Couch:
    def __init__(self):
        """Find or create the CoPED CouchDB database on the server."""

        server = couchdb.Server(COUCHDB_URI)
        if COUCHDB_DB in server:
            db = server[COUCHDB_DB]
        else:
            db = server.create(COUCHDB_DB)
            # Create a view to filter out all but the CoPED managed documents.
            db["_design/coped"] = {
                "views": {
                    "all_docs": {
                        "map": "function (doc) { if ('coped_meta' in doc) { emit(doc._id, 1); } }"
                    },
                },
                "language": "javascript",
            }
            # Also create an index on the 'coped_meta.item_id' field for fast queries.
            idx = db.index()
            ddoc, name = None, "coped-meta-item-id-idx"
            idx[ddoc, name] = ["coped_meta.item_id"]

        self.db = db

    @property
    def coped_docs(self):
        """Provide direct access to just the CoPED-managed documents.

        The returned view is iterable."""

        return self.db.view("coped/all_docs")


def psql_query(query_string, identifiers_dict=None, values=None):
    """Execute an SQL query string after substituting literals and values.

    The keys of identifiers should be the {variables} appearing in query_string
    that need to be replaced with the corresponding values.

    The values parameter should be a tuple of values to substitute into the
    query string after literal substitution.

    For example, given the following inputs:

        query_string = 'INSERT INTO {table} (id, %s);'
        identifiers_dict = {'table': 'my_table_name'}
        values = 'hello'

    The following query will be executed:

        INSERT INTO my_table_name (id, "hello");

    Note that these substitutions are essential for DB security. Do not use
    Python's f-strings.
    """

    if identifiers_dict is not None:
        identifiers = {k: sql.Identifier(identifiers_dict[k]) for k in identifiers_dict}
    else:
        identifiers = {}

    query = sql.SQL(query_string).format(**identifiers)

    with psycopg2.connect(
        dbname=POSTGRES_DB,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
    ) as conn:
        with conn.cursor() as psql:
            psql.execute(query, values)
            return psql.fetchall()
