"""
Project crawler for meta-data API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Current version finds projects matching a hard-coded test query.
Yields all matched projects, plus associated resources.
"""


import re
import scrapy
from datetime import datetime, timezone
from scrapy import Request


class ProjectsSpider(scrapy.Spider):
    """A generic recursive spider for paginated resources on the UKRI API."""

    name = "ukri-projects-spider"

    # Set API entry point.
    projects_api = "https://gtr.ukri.org/gtr/api/projects"

    """
    Resources related to projects are accessible at API endpoints relative to a project.
    For example:
    - people at `https://gtr.ukri.org/gtr/api/projects/{project_id}/persons`
    - spinouts at `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/spinouts`
    - and so on.
    Each link item type has a url path to retrieve the related resource.
    Map the connection between resource types and their address paths here.
    """
    linked_resource_paths = {
        "person": "persons",
        "organisation": "organisations",
        "fund": "funds",
        "finding": "outcomes/keyfindings",
        "impact": "outcomes/impactsummaries",
        "publication": "outcomes/publications",
        "collaboration": "outcomes/collaborations",
        "intellectual_property": "outcomes/intellectualproperties",
        "further_funding": "outcomes/furtherfundings",
        "policy": "outcomes/policyinfluences",
        "product": "outcomes/products",
        "research_material": "outcomes/researchmaterials",
        "spinout": "outcomes/spinouts",
        "dissemination": "outcomes/disseminations",
    }

    # Set default URL query parameter values.
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
        """Define a simple parser for the given `item_type`.

        The parse yields the raw data of each item in the paginated API response.
        These are then processed by the pipelines in `pipelines.py`.

        When `item_type` is "project" the parse recurses to related resources.
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
                for resource_type, resource_path in self.linked_resource_paths:
                    link = f"{self.projects_api}/{item['id']}/{resource_path}?p={self.start_page}&s={self.results_per_page}"
                    yield response.follow(link, cb_kwargs={"item_type": resource_type})

        # Continue if possible.
        if data["totalSize"] > 0 and data["page"] < data["totalPages"]:
            next_page = self.next_page_url(response.url)
            yield response.follow(next_page, cb_kwargs={"item_type": item_type})

    @staticmethod
    def next_page_url(url):
        """Increment the page number in an existing paginated API URL.

        This is needed because the UKRI API does not provide previous/next page links :(
        """
        return re.sub("p=(\d+)", lambda exp: f"p={int(exp.groups()[0]) + 1}", url)
