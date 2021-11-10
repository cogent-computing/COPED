"""
Processing pipelines for data arriving from the UKRI API.
https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Don't forget to add the pipelines to ITEM_PIPELINES in `settings.py`.
See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
"""

import logging
from scrapy.exceptions import DropItem
from core.models.raw_data import RawData
from deepdiff import DeepDiff


class SaveToDjangoPipeline:
    """A pipeline to insert or update raw data records in the CoPED database."""

    def process_item(self, item, spider):
        """Upsert the item."""

        url = item.get("href")
        try:
            # Look for the item in the DB.
            record = RawData.objects.get(url=url)
        except RawData.DoesNotExist:
            record = None

        if record is None:
            # Create a new record for this item.
            logging.debug(f"Creating new record for {url}.")
            RawData.objects.create(bot=spider.name, url=url, json=item)
        else:
            # Check record for differences and update if there are any.
            diff = DeepDiff(dict(item), dict(record.json), ignore_order=True)
            if diff:
                logging.debug(f"Updating existing record for {url}.")
                record.json = item
                record.save()
            else:
                raise DropItem(url)
