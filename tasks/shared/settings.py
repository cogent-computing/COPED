import os

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
POSTGRES_DSN = f"host={POSTGRES_HOST} port={POSTGRES_PORT} user={POSTGRES_USER} password={POSTGRES_PASSWORD} dbname={POSTGRES_DB}"
