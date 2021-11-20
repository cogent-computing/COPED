#!/usr/bin/env python

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
    """Use an external NLP service to tag CoPED projects with subject headings.

    Filtering and prioritising energy projects requires clear tagging.
    We use the National Library of Finland's Annif/Finto models via their API.

    See the following links for details:

        - http://annif.org/
        - https://www.kiwi.fi/display/Finto/Finto+AI+open+API+service
        - https://ai.finto.fi/v1/ui/
    """

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
