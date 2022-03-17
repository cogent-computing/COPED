import os
import sys
import logging
from pathlib import Path
from scrapy.utils.project import get_project_settings
from scrapy.crawler import CrawlerProcess
from celery import shared_task

# Subprocesses are required to avoid ReactorNotRestartable() when running Scrapy with Celery.
# See https://codeburst.io/running-scrapy-in-celery-tasks-d81e159921ea for details.
from multiprocessing import Process

from .ukri.spiders.projects import ProjectsSpider
from .ukri.post_process.resources import populate as populate_ukri_resources
from .ukri.post_process.relations import populate as populate_ukri_relations


scrapers_dir = Path(__file__).parent.absolute()
sys.path.append(str(scrapers_dir))


def run_crawler(*args, **kwargs):
    os.environ["SCRAPY_SETTINGS_MODULE"] = "ukri.settings"
    settings = get_project_settings()
    settings.update(kwargs)
    settings["loglevel"] = "WARNING"
    logging.debug(f"CRAWLER SETTINGS:\n{settings.copy_to_dict()}")
    process = CrawlerProcess(settings)
    process.crawl(ProjectsSpider)
    process.start()


@shared_task(name="UKRI Project Crawler")
def run_ukri_projects_crawler(*args, **kwargs):
    # Pagecount is used to restrict the number of requests to the given number.
    # Set it to a value > 0 during testing to avoid large crawls.
    p = Process(target=run_crawler, args=args, kwargs=kwargs)
    p.start()
    p.join()


populate_ukri_resources = shared_task(name="Populate UKRI resources")(
    populate_ukri_resources
)
populate_ukri_relations = shared_task(name="Populate UKRI relations")(
    populate_ukri_relations
)
