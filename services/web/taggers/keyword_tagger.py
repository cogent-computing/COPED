#!/usr/bin/env python

"""Apply keywords to projects stored in the CoPED database.

Filtering and prioritising energy projects requires clear keyword extraction.
We use the Python Keyphrase Extraction module.

See the following links for details:

    - https://github.com/boudinfl/pke
"""

import logging
import os
import sys
import django
import textacy
from textacy.extract import keyterms as kt
from django.db import transaction
from celery import shared_task

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import Project
from core.models import Keyword
from core.models import ProjectKeyword


@shared_task(name="Automatic project keyword and key phrase tagger")
def tag_projects_with_keywords(exclude_already_tagged=True, limit=-1):
    """Send project text to a trained keyword extraction model.

    Update project records by adding the suggested keywords and scores.
    Add each keyword to the DB if it does not already exist."""

    projects = Project.objects.filter(is_locked=False)
    if exclude_already_tagged:
        projects = projects.filter(keywords__isnull=True)

    for project in projects[:limit]:

        logging.log("Keyword tagging project %s", project.id)

        results = []
        try:
            text = "\n\n".join([project.title, project.description, project.extra_text])
            doc = textacy.make_spacy_doc(text, lang="en_core_web_md")
            results = kt.textrank(
                doc,
                normalize="lemma",
                topn=min(int(len(text) ** 0.5) // 2, 15),
                window_size=10,
                edge_weighting="count",
                position_bias=True,
            )
        except Exception as e:
            logging.error("Request to tag project %s failed.", project.id)
            continue

        with transaction.atomic():
            for label, score in results:
                keyword, _ = Keyword.objects.get_or_create(
                    text=label,
                )
                ProjectKeyword.objects.update_or_create(
                    project=project, keyword=keyword, defaults={"score": score}
                )


if __name__ == "__main__":
    tag_projects_with_keywords(exclude_already_tagged=True)
