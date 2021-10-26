"""
Processing pipelines for data arriving from the UKRI API.
https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Don't forget to add the pipelines to ITEM_PIPELINES in `settings.py`.
See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
"""

import logging
from datetime import datetime

from scrapy.exceptions import DropItem

from shared.documents import different_docs
from shared.documents import find_ukri_doc
from shared.documents import save_document

log = logging.getLogger("ukriCrawlerLogger")


class ProcessDuplicatesPipeline:
    """A pipeline to process resources with an existing record in the DB."""

    def process_item(self, item, spider):

        doc = find_ukri_doc(item["id"])

        # If an item is found, then check for changes.
        # Drop if no changes. Update if changes detected, then drop.
        if doc is not None:
            log.info(f"found existing doc id = {doc.id}")

            if not different_docs(doc["raw_data"], item):
                # The deep diff didn't find any differences. We can stop.
                log.info("no changes - dropping")
            else:
                # Something has changed in the item since last update.
                log.info("found changes - updating")

                # Replace doc's raw data with the new item.
                doc["raw_data"] = item

                # Update the item in the DB
                save_document(doc, f"{spider.name} updated")
                log.info(f"document {doc.id} updated")

            raise DropItem(f"Duplicate UKRI item: {item['id']!r}")

        else:
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
        }
        doc["raw_data"] = item
        return doc


class SaveToCouchPipeline:
    """A pipeline to save crawled data to the CouchDB service."""

    def process_item(self, item, spider):
        """Save the document to the DB."""
        doc = save_document(item, f"{spider.name} created")
        log.info(f"Created new document with id {doc.id}")
        return item
