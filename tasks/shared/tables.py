"""Shared code for working with CoPED-managed tables inside PostgreSQL."""

from shared.utils import coped_logging as log
from shared.databases import psql_query


def coped_allowed_items():
    """Get a list of item types known to CoPED."""
    select_item_type = "SELECT item_type FROM coped_resource_type;"
    allowed_items = [row[0] for row in psql_query(select_item_type)]
    log.debug(f"Allowed items: {allowed_items}")
    return allowed_items


def coped_allowed_relations():
    """Get a list of relation types known to CoPED."""
    select_rel_link = "SELECT rel_link FROM coped_relation_type;"
    allowed_relations = [row[0] for row in psql_query(select_rel_link)]
    log.debug(f"Allowed relations: {allowed_relations}")
    return allowed_relations


def coped_resource_exists(uuid):
    """Determine whether a given UUID exists in the resource table."""
    find_resource = "SELECT * FROM coped_resource WHERE document_id = %s;"
    result = list(psql_query(find_resource, values=(uuid,)))
    return bool(result)


def coped_resources():
    """Get a generator over CoPED resource ids."""
    select_resources = "SELECT document_id FROM coped_resource;"
    yield from (row[0].upper() for row in psql_query(select_resources))


def coped_insert_resource(doc_id, item_type):
    log.info(f"adding resource ({doc_id}, {item_type}) to PostgreSQL")
    insert = """
        INSERT INTO coped_resource (document_id, resource_type_id) VALUES (%s, %s)
        ON CONFLICT DO NOTHING
        RETURNING document_id;
        """
    result = psql_query(insert, values=(doc_id, item_type))


def coped_upsert_relation(
    relation_type_id, resource_1_id, resource_2_id, relation_weight=None
):
    """Add a new relation between CoPED resources to the relation table."""

    insert_relation = """
        INSERT INTO coped_relation
            (relation_type_id, resource_1_id, resource_2_id, relation_weight)
        VALUES
            (%s, %s, %s, %s)
        ON CONFLICT ON CONSTRAINT unique_resources_per_relation DO UPDATE
        SET
            (relation_type_id, resource_1_id, resource_2_id, relation_weight)
            =
            ROW (EXCLUDED.relation_type_id::VARCHAR, EXCLUDED.resource_1_id::UUID,
                 EXCLUDED.resource_2_id::UUID, EXCLUDED.relation_weight::DOUBLE PRECISION)
        WHERE
            (coped_relation.*)
        IS DISTINCT FROM
            (EXCLUDED.*)
        RETURNING
            coped_relation.id;
        """
    psql_query(
        insert_relation,
        values=(relation_type_id, resource_1_id, resource_2_id, relation_weight),
    )
