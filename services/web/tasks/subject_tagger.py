#!/usr/bin/env python

"""Apply subject descriptors to projects stored in the CoPED database.

Filtering and prioritising energy projects requires clear tagging.
We use the National Library of Finland's Annif/Finto models via their public API.

See the following links for details:

    - http://annif.org/
    - https://www.kiwi.fi/display/Finto/Finto+AI+open+API+service
    - https://ai.finto.fi/v1/ui/
"""

import json
import os
import sys
import django
from django.db import transaction

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import Project
from core.models import Subject
from core.models import ProjectSubject
from core.models import ExternalLink
import requests


def tag_projects_with_subjects(exclude_already_tagged=True):
    """Send project descriptions to the subject suggestion model at Finto.

    Updates project records by adding the suggested subjects and scores.
    Adds each subject to the DB if it does not already exist, and also
    adds an external link to an ontology DB for each subject term."""

    api_url = "https://ai.finto.fi/v1/projects/yso-en/suggest"

    for project in Project.objects.all()[:50]:

        if exclude_already_tagged and project.subjects.exists():
            continue

        print(project.title)
        payload = {
            "project_id": "yso-en",  # Finto English language subject classifier
            "text": project.description,
            "limit": 20,
        }
        r = requests.post(api_url, data=payload)
        results = json.loads(r.content)["results"]

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


if __name__ == "__main__":
    tag_projects_with_subjects(exclude_already_tagged=True)
