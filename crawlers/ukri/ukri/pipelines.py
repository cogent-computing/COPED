"""
Processing pipelines for data arriving from the UKRI API.
https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Don't forget to add the pipelines to ITEM_PIPELINES in `settings.py`.
See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html

SaveToCouchPipeline:
    - Saves crawled items to the CouchDB service.
    - Creates a new DB if required.

TODO:
    - add pipeline to check for duplicates before saving
"""


import couchdb
from couchdb.http import PreconditionFailed
from uuid import uuid4

# Handle different item types with Scrapy's standard item interface.
from itemadapter import ItemAdapter


class SaveToCouchPipeline:
    """A pipeline to save crawled data to the CouchDB service."""

    db_name = "ukri-data"

    def __init__(self, couch_uri):
        self.couch_uri = couch_uri

    @classmethod
    def from_crawler(cls, crawler):
        """Fetch any settings we need to access the DB."""
        return cls(couch_uri=crawler.settings.get("COUCH_URI"))

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

    def process_item(self, item, spider):
        """Create a unique identifier and save the document to the DB."""
        doc_id = str(uuid4()).upper()
        self.db[doc_id] = ItemAdapter(item).asdict()
        return item
