"""
Processing pipelines for data arriving from the UKRI API.
https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Don't forget to add the pipelines to ITEM_PIPELINES in `settings.py`.
See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
"""

import json
import logging
import couchdb
from deepdiff import DeepDiff
from datetime import datetime, timezone
from couchdb.http import PreconditionFailed
from uuid import uuid4
from scrapy.exceptions import DropItem


def different_data(doc_1, doc_2):
    """Given two documents, are they different?"""
    diff = DeepDiff(dict(doc_1), dict(doc_2), ignore_order=True)
    logging.info(f"document diff = {diff}")
    return bool(diff)


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
    """A pipeline to process resources with an existing record in the DB."""

    def process_item(self, item, spider):

        # Search for the document using its UKRI id.
        # TODO: create an index on `coped_meta.item_id` for speed.
        query = {
            "selector": {"coped_meta": {"item_id": item["id"]}},
            "fields": ["_id"],
        }
        result = list(self.db.find(query))
        item_found = bool(len(result))

        # If an item is found, then check for changes.
        # Drop if no changes.
        # Update if changes detected.
        if item_found:
            # Get the matched CouchDB _id and access the full document.
            _id = result[0]["_id"]
            doc = self.db[_id]
            logging.info(f"found existing doc _id = {_id}")

            if not different_data(doc["raw_data"], item):
                # The deep diff didn't find any differences. We can stop.
                logging.info("no changes - dropping")
            else:
                # Something has changed in the item since last update.
                logging.info("found changes - updating")

                # Replace doc's raw data with the new item.
                doc["raw_data"] = item

                # Update the dict of item updates.
                old_updates = doc["coped_meta"]["item_updates"]
                now = datetime.now().utcnow().isoformat()
                new_update = {now: f"{spider.name} updated"}
                doc["coped_meta"]["item_updates"] = old_updates | new_update

                # Save the document back to CouchDB and stop further pipelines.
                self.db[_id] = doc
                logging.info("document updated")
            raise DropItem(f"Duplicate UKRI item: {item['id']!r}")

        # Item does not already exist in DB, so continue processing.
        return item


class CreateDocumentPipeline:
    """A pipeline to create the document to be stored."""

    def process_item(self, item, spider):

        now = datetime.now().utcnow().isoformat()
        doc = {}
        doc["coped_meta"] = {
            "item_source": spider.name,
            "item_id": item.get("id"),
            "item_url": item.get("href"),
            "item_type": item.get("href").split("/")[-2],
            "item_authority": 200,
            "item_updates": {now: f"{spider.name} created"},
        }
        doc["raw_data"] = item
        return doc


class SaveToCouchPipeline(BaseCouchPipeline):
    """A pipeline to save crawled data to the CouchDB service."""

    def process_item(self, item, spider):
        """Create a unique identifier and save the document to the DB."""
        doc_id = str(uuid4()).upper()
        self.db[doc_id] = item
        return item
