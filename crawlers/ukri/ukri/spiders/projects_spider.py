"""
Project crawler for meta-data API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Current version finds projects matching a hard-coded test query.
Yields all matched projects, plus associated persons, organisations, and funds.
"""


import re
import scrapy
from datetime import datetime, timezone
from scrapy import Request


class ProjectsSpider(scrapy.Spider):
    """A generic recursive spider for paginated resources on the UKRI API."""

    name = "ukri-projects-spider"

    # Set API entry point and default URL query parameter values.
    projects_api = "https://gtr.ukri.org/gtr/api/projects"
    start_page = 1
    results_per_page = 100  # maximum supported by API = 100

    def start_requests(self):

        queries = [
            "microgrid"
        ]  # TODO: get query list from the PostgreSQL DB or from Apache Airflow
        urls = [
            f"{self.projects_api}?q={query}&p={self.start_page}&s={self.results_per_page}"
            for query in queries
        ]
        for url in urls:
            yield Request(url=url, cb_kwargs={"item_type": "project"})

    def parse(self, response, item_type):
        """Define a dumb parser for the given `item_type`.

        The parse yields the raw data of each item in the paginated API response.
        These are then processed by the pipelines in `pipelines.py`.

        When `item_type` is "project" the parse recurses to related people, orgs, and funds.
        """

        data = response.json()
        items = data[item_type]

        for item in items:
            # Pass everything out for pipeline processing.
            now_utc = str(datetime.now(timezone.utc))
            yield {
                "source": self.name,
                "updated": now_utc,
                "item_type": item_type,
                "item_id": item["id"],
                "item_url": item["href"],
                "item_data": item,
            }

            # Recurse to related people, orgs, and funds when we're crawling projects.
            if item_type == "project":
                for link_item_type in ["person", "organisation", "fund"]:
                    link_url = f"{self.projects_api}/{item['id']}/{link_item_type}s?p={self.start_page}&s={self.results_per_page}"
                    yield response.follow(
                        link_url, cb_kwargs={"item_type": link_item_type}
                    )

        # Continue if possible.
        if data["page"] < data["totalPages"]:
            next_page = self.next_page_url(response.url)
            yield response.follow(next_page, cb_kwargs={"item_type": item_type})

    @staticmethod
    def next_page_url(url):
        """Increment the page number in an existing paginated API URL.

        This is needed because the UKRI API does not provide previous/next page links :(
        """
        return re.sub("p=(\d+)", lambda exp: f"p={int(exp.groups()[0]) + 1}", url)
