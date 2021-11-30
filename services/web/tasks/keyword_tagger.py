#!/usr/bin/env python

"""Apply keywords to projects stored in the CoPED database.

Filtering and prioritising energy projects requires clear keyword extraction.
We use the Python Keyphrase Extraction module.

See the following links for details:

    - https://github.com/boudinfl/pke
"""

import time
import json
import os
import sys
import django
import textacy
from textacy.extract import keyterms as kt
from django.db import transaction

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
sys.path.append(os.path.abspath(".."))
django.setup()

from core.models import Project
from core.models import Keyword
from core.models import ProjectKeyword


def tag_projects_with_keywords(exclude_already_tagged=True, limit=None):
    """Send project text to a trained keyword extraction model.

    Update project records by adding the suggested keywords and scores.
    Add each keyword to the DB if it does not already exist."""

    # TODO: prefilter projects based on existing subjects - similar to geo tagger script.
    total_projects = Project.objects.count()
    if limit is None:
        limit = total_projects  # number of projects to tag

    count = 0
    for project in Project.objects.all()[:limit]:

        count += 1

        if exclude_already_tagged and project.keywords.exists():
            print(
                f"Project {count} of {total_projects} (id={project.id}) already tagged. Skipping."
            )
            continue

        print(
            f"Tagging project {count} of {total_projects} (id={project.id}): {project.title[:30]}..."
        )

        results = []
        try:
            text = "\n\n".join([project.title, project.description, project.extra_text])
            doc = textacy.make_spacy_doc(text, lang="en_core_web_md")
            results = kt.textrank(
                doc,
                normalize="lemma",
                topn=min(int(len(text) ** 0.5) // 3, 20),
                window_size=3,
                edge_weighting="binary",
                position_bias=False,
            )
        except Exception as e:
            print(f"Request to tag project {project.id} failed with exception:\n{e}\n")
            continue

        with transaction.atomic():
            for label, score in results:
                # print(label, score)
                keyword, _ = Keyword.objects.get_or_create(
                    text=label,
                )
                ProjectKeyword.objects.update_or_create(
                    project=project, keyword=keyword, defaults={"score": score}
                )


if __name__ == "__main__":
    tag_projects_with_keywords(exclude_already_tagged=True)
