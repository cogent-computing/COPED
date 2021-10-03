"""
Project crawler for API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

This version just crawls projects for a hard-coded test query. Returning all matched
projects, their related persons, and their related organisations.
"""


import re
import scrapy
from scrapy import Request


# Set API entry point and default URL query parameter values.
projects_api = "https://gtr.ukri.org/gtr/api/projects"
start_page = 1
results_per_page = 10


def next_page_url(url):
    """
    Increment the page number in an existing paginated URL.
    This is needed because the UKRI API does not provide previous/next page links :(
    """
    return re.sub("p=(\d+)", lambda exp: f"p={int(exp.groups()[0]) + 1}", url)


class ProjectsSpider(scrapy.Spider):
    name = "ukri-projects"

    def start_requests(self):

        queries = ["microgrid"]  # TODO: get query list from the DB
        urls = [
            f"{projects_api}?q={query}&p={start_page}&s={results_per_page}"
            for query in queries
        ]
        for url in urls:
            yield Request(
                url=url,
                cb_kwargs={"item_type": "project", "item_keys": ["id", "title"]},
            )

    def parse(self, response, item_type, item_keys):
        """Define a `scrapy.Spider` parser for the given item type, extracting the given keys."""

        data = response.json()
        page = data["page"]
        total_pages = data["totalPages"]
        self.log(f"Parsing page {page} of {total_pages} {item_type} pages.")

        # TODO: save raw item data to the DB using `pipelines.py`

        items = data[item_type]
        item_data = {}
        for item in items:
            item_data = item_data | {"type": item_type, "source": "ukri"}
            item_data = item_data | {key: item[key] for key in item_keys}
            yield item_data

            if item_type == "project":
                yield response.follow(
                    f"{projects_api}/{item['id']}/persons?p={start_page}&s={results_per_page}",
                    cb_kwargs={
                        "item_type": "person",
                        "item_keys": ["id", "firstName", "surname"],
                    },
                )
                yield response.follow(
                    f"{projects_api}/{item['id']}/organisations?p={start_page}&s={results_per_page}",
                    cb_kwargs={
                        "item_type": "organisation",
                        "item_keys": ["id", "name"],
                    },
                )

        # Continue if possible.
        if page < total_pages:
            next_page = next_page_url(response.url)
            yield response.follow(
                next_page,
                cb_kwargs={"item_type": item_type, "item_keys": item_keys},
            )
