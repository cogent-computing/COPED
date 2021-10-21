"""
Processing pipelines for data arriving from the UKRI API.
https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Don't forget to add the pipelines to ITEM_PIPELINES in `settings.py`.
See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html

BaseCouchPipeline:
    - Base class for pipelines that need to interact with CouchDB

ProcessDuplicatesPipeline:
    - Checks the DB for existing docs with the same UKRI id.
    - If found the item is dropped and not processed further.

SaveToCouchPipeline:
    - Saves crawled items to the CouchDB service.
    - Creates a new DB if required.
"""


import couchdb
from couchdb.http import PreconditionFailed
from uuid import uuid4
from scrapy.exceptions import DropItem

# Handle different item types with Scrapy's standard item interface.
from itemadapter import ItemAdapter


class BaseCouchPipeline:
    """Base class for pipelines that need to access CouchDB"""

    def __init__(self, couch_uri, db_name):
        self.couch_uri = couch_uri
        self.db_name = db_name

    @classmethod
    def from_crawler(cls, crawler):
        """Fetch any settings we need to access the DB."""
        return cls(
            couch_uri=crawler.settings.get("COUCHDB_URI"),
            db_name=crawler.settings.get("COUCHDB_DB"),
        )

    def open_spider(self, spider):
        """Set up the DB connection when the spider starts."""
        self.client = couchdb.Server(self.couch_uri)
        try:
            # Create the DB if we need to.
            self.db = self.client.create(self.db_name)
        except PreconditionFailed:
            # If the DB exists then use it.
            self.db = self.client[self.db_name]

    def close_spider(self, spider):
        pass


class ProcessDuplicatesPipeline(BaseCouchPipeline):
    """A pipeline to process resources with an existing record in the DB"""

    def process_item(self, item, spider):

        adapter = ItemAdapter(item)

        # Search for the document using its UKRI id
        query = {
            "selector": {"item_id": adapter["item_id"]},
            "fields": ["item_id", "item_type"],
        }
        result = list(self.db.find(query))

        # Ignore existing items
        # TODO: check for changes and merge rather than ignore
        if len(result):
            raise DropItem(
                f"Duplicate item found: {adapter['item_type']!r} {adapter['item_id']!r}"
            )
        else:
            return item


class SaveToCouchPipeline(BaseCouchPipeline):
    """A pipeline to save crawled data to the CouchDB service."""

    def process_item(self, item, spider):
        """Create a unique identifier and save the document to the DB."""
        doc_id = str(uuid4()).upper()
        self.db[doc_id] = ItemAdapter(item).asdict()
        return item
