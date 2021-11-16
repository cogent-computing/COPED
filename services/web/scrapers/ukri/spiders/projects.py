"""
Project crawler for meta-data API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

Yields all matched projects, plus associated resources.
"""


import re
from scrapy import Request
from scrapy import Spider


class ProjectsSpider(Spider):
    """A generic recursive spider for paginated resources on the UKRI API."""

    # Name to use when launching spider crawl from command line.
    name = "ukri-projects-spider"

    # Set API entry point.
    projects_api = "https://gtr.ukri.org/gtr/api/projects"

    def start_requests(self):

        # TODO: get list of query terms from the CoPED DB
        queries = ["microgrid"]

        # Ensure query phrases containing spaces are double quoted.
        queries = [f'"{q}"' if " " in q else q for q in queries]

        # Set up search URLs to start from.
        urls = [f"{self.projects_api}?q={query}&p=1&s=100" for query in queries]

        # Send each query request to the API server.
        for url in urls:
            yield Request(url=url)

    def parse(self, response):
        """A simple parser for the resource(s) in the response.

        Follows search results to get the matching items.
        Also follows links from projects and funds to related items.
        """

        data = response.json()

        if "?q=" in response.request.url:
            # This is a project search response (contains '?q=' in the URL).
            # So it contains a list of projects.

            # If there were no returned projects, then we're done.
            if data.get("totalSize", 0) == 0:
                return None

            # Parse all hrefs to the project records and follow them.
            projects = data.get("project", [])
            hrefs = []
            for project in projects:
                href = project.get("href", "")
                if href:
                    hrefs.append(href)
            yield from response.follow_all(hrefs)

            # Follow with the next page of results if possible.
            if data.get("page", 0) < data.get("totalPages", 0):
                next_page = self.next_page_url(response.url)
                yield response.follow(next_page)

        else:
            # Otherwise, this must be an individual resource item response.
            # Yield the item's JSON data for further pipeline processing.
            yield data

            # Also find relevant links and follow them.
            item_type = response.request.url.split("/")[-2]
            if item_type in ["projects", "funds", "persons"]:
                links = data.get("links", {}).get("link", [])
                hrefs = []
                for link in links:
                    href = link.get("href", "")
                    if href:
                        link_type = href.split("/")[-2]
                        # Depending on the item type, we only follow certain link types.
                        # This is to constrain the data collected so it is closely linked
                        # to the energy projects in the DB.
                        if (
                            (
                                # Note: we don't follow project link types from projects.
                                # Projects are included only if a search finds them directly.
                                item_type == "projects"
                                and link_type in ["persons", "funds", "organisations"]
                            )
                            or (item_type == "persons" and link_type == "organisations")
                            or (item_type == "funds" and link_type == "organisations")
                        ):
                            hrefs.append(href)
                yield from response.follow_all(hrefs)

    @staticmethod
    def next_page_url(url):
        """Increment the page number in an existing paginated API URL.

        This is needed because the UKRI API v2 JSON does not provide previous/next page links :(
        """
        return re.sub("p=(\d+)", lambda exp: f"p={int(exp.groups()[0]) + 1}", url)
