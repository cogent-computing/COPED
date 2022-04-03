#!/usr/bin/env python

"""Apply subject descriptors to projects stored in the CoPED database.

Filtering and prioritising energy projects requires clear tagging.
We use the National Library of Finland's Annif/Finto models via their public API.

See the following links for details:

    - http://annif.org/
    - https://www.kiwi.fi/display/Finto/Finto+AI+open+API+service
    - https://ai.finto.fi/v1/ui/
"""

import logging
import time
import json
import os
import sys
import django
import requests
from celery import shared_task
from django.db import transaction

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import Project
from core.models import Subject
from core.models import ProjectSubject
from core.models import ExternalLink
from core.models import AppSetting

@shared_task(name="Automatic project subject tagger")
def tag_projects_with_subjects(exclude_already_tagged=True, limit=-1):
    """Send project descriptions to the subject suggestion model at Finto.

    Update project records by adding the suggested subjects and scores.
    Add each subject to the DB if it does not already exist, and add
    an external link to an ontology DB for each subject term stored."""

    api_url = "https://ai.finto.fi/v1/projects/yso-en/suggest"
    try:
        USER_AGENT = AppSetting.objects.get(slug="COPED_USER_AGENT").value
    except AppSetting.DoesNotExist:
        USER_AGENT = "CoPEDbot/0.1 (Catalogue of Projects on Energy Data) Crawler"
    headers = {"User-Agent": USER_AGENT}
    try:
        SUBJECT_SCORE_THRESHOLD = float(AppSetting.objects.get(slug="SUBJECT_SCORE_THRESHOLD").value)
    except (AppSetting.DoesNotExist, ValueError):
        SUBJECT_SCORE_THRESHOLD = 0.1

    projects = Project.objects.filter(is_locked=False)
    if exclude_already_tagged:
        projects = projects.filter(subjects__isnull=True)

    with requests.session() as connection:
        connection.headers.update(headers)

        for project in projects[:limit]:

            logging.info("Tagging project %s", project.id)

            results = []
            try:
                payload = {
                    "project_id": "yso-en",  # Finto English language subject classifier
                    "text": project.description + project.extra_text,
                    "limit": 15,
                }
                r = connection.post(api_url, data=payload, headers=headers, timeout=20)
                results = json.loads(r.content)["results"]
            except requests.exceptions.RequestException as e:
                logging.error("Requst to tag project %s failed", project.id)
                continue

            with transaction.atomic():
                for r in results:
                    label, score, uri = r["label"], r["score"], r["uri"]
                    if score < SUBJECT_SCORE_THRESHOLD:
                        logging.debug(
                            "Subject %s with score %s for project %s was below threshold %s",
                            label, score, project.id, SUBJECT_SCORE_THRESHOLD)
                        continue
                    link, _ = ExternalLink.objects.get_or_create(
                        link=uri,
                        defaults={"description": "Finto term ontology"},
                    )
                    subject, _ = Subject.objects.get_or_create(
                        label=label,
                        defaults={"external_link": link},
                    )
                    ProjectSubject.objects.update_or_create(
                        project=project, subject=subject, defaults={"score": score}
                    )

            # ease off between API hits to avoid saturating the remote server
            time.sleep(1)


if __name__ == "__main__":
    tag_projects_with_subjects(exclude_already_tagged=True)
