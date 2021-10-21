#!/usr/bin/env python

"""Transfer IDs of resources from CouchDB to PostgreSQL"""

import click
import psycopg2
import couchdb
from psycopg2 import sql


@click.command()
@click.option("--couchdb_host", envvar="COUCHDB_HOST")
@click.option("--couchdb_port", envvar="COUCHDB_PORT")
@click.option("--couchdb_user", envvar="COUCHDB_USER")
@click.option("--couchdb_password", envvar="COUCHDB_PASSWORD")
@click.option("--couchdb_db", envvar="COUCHDB_DB")
@click.option("--postgres_host", envvar="POSTGRES_HOST")
@click.option("--postgres_port", envvar="POSTGRES_PORT")
@click.option("--postgres_user", envvar="POSTGRES_USER")
@click.option("--postgres_password", envvar="POSTGRES_PASSWORD")
@click.option("--postgres_db", envvar="POSTGRES_DB")
def main(
    couchdb_host,
    couchdb_port,
    couchdb_user,
    couchdb_password,
    couchdb_db,
    postgres_host,
    postgres_port,
    postgres_user,
    postgres_password,
    postgres_db,
):

    COUCHDB_URI = (
        f"http://{couchdb_user}:{couchdb_password}@{couchdb_host}:{couchdb_port}/"
    )
    couch_conn = couchdb.Server(COUCHDB_URI)
    couch = couch_conn[couchdb_db]

    with psycopg2.connect(
        dbname=postgres_db,
        user=postgres_user,
        password=postgres_password,
        host=postgres_host,
        port=postgres_port,
    ) as conn:
        with conn.cursor() as psql:
            for doc_id in couch:
                doc = couch[doc_id]
                item_type = doc["item_type"]
                print(doc_id, item_type)

                # add each item to the resource table with the correct resource type
                query_string = """
                    INSERT INTO coped_resource (document_id, resource_type_id)
                    SELECT {doc_id}, crt.id
                    FROM coped_couchdb_name AS ccn JOIN coped_resource_type AS crt
                    ON ccn.id = crt.couchdb_id
                    WHERE item_type = %s and ccn.name = %s
                    ON CONFLICT DO NOTHING;
                    """
                query = sql.SQL(query_string).format(doc_id=sql.Literal(doc_id))
                psql.execute(query, (item_type, couchdb_db))


if __name__ == "__main__":
    main()
