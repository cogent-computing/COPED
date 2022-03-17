#!/usr/bin/env python

"""Apply subject descriptors to projects stored in the CoPED database.

Filtering and prioritising energy projects requires clear tagging.
We use the National Library of Finland's Annif/Finto models via their public API.

See the following links for details:

    - http://annif.org/
    - https://www.kiwi.fi/display/Finto/Finto+AI+open+API+service
    - https://ai.finto.fi/v1/ui/
"""

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


@shared_task(name="Automatic project subject tagger")
def tag_projects_with_subjects(exclude_already_tagged=True, limit=None):
    """Send project descriptions to the subject suggestion model at Finto.

    Update project records by adding the suggested subjects and scores.
    Add each subject to the DB if it does not already exist, and add
    an external link to an ontology DB for each subject term stored."""

    api_url = "https://ai.finto.fi/v1/projects/yso-en/suggest"
    # TODO: centralise the user agent setting for use in other external-service-facing tasks.
    headers = {
        "User-Agent": "coped/0.2 (Copedbot/0.2; Catalogue of Projects on Energy Data; https://coped.coventry.ac.uk)"
    }

    # TODO: prefilter projects based on existing subjects - similar to geo tagger script.
    total_projects = Project.objects.count()
    if limit is None:
        limit = total_projects  # number of projects to tag

    with requests.session() as connection:
        connection.headers.update(headers)

        count = 0
        for project in Project.objects.all()[:limit]:

            count += 1

            if exclude_already_tagged and project.subjects.exists():
                print(
                    f"Project {count} of {total_projects} (id={project.id}) already tagged. Skipping."
                )
                continue

            print(
                f"Project {count} of {total_projects} (id={project.id}) not tagged. Tagging: {project.title[:30]}..."
            )

            results = []
            try:
                payload = {
                    "project_id": "yso-en",  # Finto English language subject classifier
                    "text": project.description,
                    "limit": 20,
                }
                r = connection.post(api_url, data=payload, headers=headers, timeout=20)
                results = json.loads(r.content)["results"]
            except requests.exceptions.RequestException as e:
                print(
                    f"Request to tag project {project.id} failed with exception:\n{e}\n"
                )
                continue

            with transaction.atomic():
                for r in results:
                    label, score, uri = r["label"], r["score"], r["uri"]
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
            time.sleep(2)


if __name__ == "__main__":
    tag_projects_with_subjects(exclude_already_tagged=True)
