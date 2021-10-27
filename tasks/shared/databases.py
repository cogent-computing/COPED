"""Shared code for accessing databases."""

import couchdb
import psycopg2
import shared.settings as settings
from psycopg2 import sql


class Couch:
    def __init__(self):
        """Find or create the CoPED CouchDB database on the server."""

        server = couchdb.Server(settings.COUCHDB_URI)
        if settings.COUCHDB_DB in server:
            db = server[settings.COUCHDB_DB]
        else:
            db = server.create(settings.COUCHDB_DB)
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

    def coped_docs(self, *args, view_name="coped/all_docs", **kwargs):
        """Provide direct access to just the CoPED-managed documents.

        The returned view is iterable."""

        return self.db.view(view_name, *args, **kwargs)


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

    with psycopg2.connect(settings.POSTGRES_DSN) as conn:
        with conn.cursor() as psql:
            psql.execute(query, values)
            return psql.fetchall()
