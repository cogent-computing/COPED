import re
import scrapy
from scrapy import Request

"""
Project crawler for API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf
"""


def projects_query_url(query_term, page=1, results_per_page=100):
    """Main entry point to search the UKRI API projects data."""
    return f"https://gtr.ukri.org/gtr/api/projects?q={query_term}&p={page}&s={results_per_page}"


def next_projects_url(url):
    """
    Increment the page number in an existing project query URL.
    This is needed because the UKRI API does not provide previous/next page links :(
    """
    return re.sub("p=(\d+)", lambda exp: f"p={int(exp.groups()[0]) + 1}", url)


def project_query_terms():
    # TODO: avoid hard coding here - provide DB lookup so admin can edit the terms
    return ["microgrid"]


# Set up a dictionary to allow following link relations for people.
persons_link_relations = {
    "PI_PER": "Principal Investigator",
    "COI_PER": "Co-Investigator",
    "PM_PER": "Project Manager",
    "FELLOW_PER": "Fellow",
    "EMPLOYEE": "Employee",
}


class ProjectsSpider(scrapy.Spider):
    name = "projects"

    def start_requests(self):
        queries, start_page, results_per_page = project_query_terms(), 1, 10
        urls = [
            projects_query_url(
                query, page=start_page, results_per_page=results_per_page
            )
            for query in queries
        ]
        for url in urls:
            yield Request(
                url=url,
                callback=self.parse_projects,
                headers={"Accept": "application/json"},
            )

    def parse_projects(self, response):
        data = response.json()

        page = data["page"]
        total_pages = data["totalPages"]
        self.log(f"Parsing page {page} of {total_pages} project pages.")

        # TODO: save raw project data to the DB here, or use a pipeline.
        self.log("Save project data to DB - dump it now...")

        # Extract some structured information from the project.
        projects = data["project"]
        for project in projects:
            self.log("Saving project to DB")
            yield {
                "type": "project",
                "source": "ukri",
                "id": project["id"],
                "title": project["title"],
            }
            persons = [
                link
                for link in project["links"]["link"]
                if link["rel"] in persons_link_relations.keys()
            ]

            persons_urls = [person["href"] for person in persons]

            yield from response.follow_all(
                persons_urls,
                callback=self.parse_person,
                headers={"Accept": "application/json"},
            )

        if page < total_pages:
            next_page = next_projects_url(response.url)
            yield response.follow(
                next_page,
                callback=self.parse_projects,
                headers={"Accept": "application/json"},
            )

    def parse_person(self, response):
        person = response.json()

        # TODO: save raw person data to the DB here, or use a pipeline.
        self.log("Save person data to DB - dump it now...")

        yield {
            "type": "person",
            "source": "ukri",
            "id": person["id"],
            "firstName": person["firstName"],
            "otherNames": person["otherNames"],
            "surname": person["surname"],
        }
