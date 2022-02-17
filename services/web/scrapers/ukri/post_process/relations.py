from datetime import datetime
from django.db import transaction
from core.models.project import (
    LinkedProject,
    Project,
    ProjectFund,
    ProjectOrganisation,
    ProjectPerson,
)
from core.models.organisation import Organisation
from core.models.person import Person, PersonOrganisation
from core.models.raw_data import RawData


def populate(bot_name="ukri-projects-spider"):
    """Parse all resources with a UKRI raw data source to get their relations.

    Extract links from the associated raw data, and use these to link to other CoPED resources.
    NB: this function assumes that resources have already been populated from the raw data."""

    projects = Project.objects.filter(raw_data__bot=bot_name)
    persons = Person.objects.filter(raw_data__bot=bot_name)
    # organisations = Organisation.objects.filter(raw_data__bot=bot_name)

    with transaction.atomic():
        for project in projects:
            populate_resource_relations(project)
        for person in persons:
            populate_resource_relations(person)


def populate_resource_relations(ukri_record):
    """Parse linked raw data for relations to other records in the DB."""

    raw_data = ukri_record.raw_data
    record_type = raw_data.url.split("/")[-2]

    if record_type not in ["organisations", "projects", "persons"]:
        return

    links = raw_data.json.get("links", {}).get("link", [])

    for link in links:

        href, rel = link.get("href"), link.get("rel")
        if href is None or rel is None:
            continue

        link_type = href.split("/")[-2]

        try:
            if record_type == "persons" and link_type == "organisations":
                organisation = Organisation.objects.get(raw_data__url=href)
                PersonOrganisation.objects.get_or_create(
                    person=ukri_record, organisation=organisation, role=rel
                )
            if record_type == "projects" and link_type == "organisations":
                organisation = Organisation.objects.get(raw_data__url=href)
                ProjectOrganisation.objects.get_or_create(
                    project=ukri_record, organisation=organisation, role=rel
                )
            elif record_type == "projects" and link_type == "persons":
                person = Person.objects.get(raw_data__url=href)
                ProjectPerson.objects.get_or_create(
                    project=ukri_record, person=person, role=rel
                )
            elif record_type == "projects" and link_type == "projects":
                linked_project = Project.objects.get(raw_data__url=href)
                LinkedProject.objects.get_or_create(
                    project=ukri_record, link=linked_project, relation=rel
                )
            elif record_type == "projects" and link_type == "funds":
                # More work to do.
                # First get the funding organisation from the fund's raw data.
                fund_record = RawData.objects.get(url=href)
                fund_json = fund_record.json
                fund_links = fund_json.get("links", {}).get("link", [])

                funder = None
                for fund_link in fund_links:
                    fund_href, fund_rel = fund_link.get("href"), fund_link.get("rel")
                    if fund_rel == "FUNDER":
                        funder = Organisation.objects.get(raw_data__url=fund_href)
                        break

                if funder is None:
                    continue

                # Now we can populate the fund information into the through table.
                amount = fund_json.get("valuePounds", {}).get("amount", 0)
                if fund_json.get("start"):
                    start = datetime.utcfromtimestamp(
                        fund_json.get("start") // 1000
                    ).date()
                if fund_json.get("end"):
                    end = datetime.utcfromtimestamp(fund_json.get("end") // 1000).date()

                ProjectFund.objects.get_or_create(
                    project=ukri_record,
                    organisation=funder,
                    amount=amount,
                    start_date=start,
                    end_date=end,
                    raw_data=fund_record,
                )

        except (
            Organisation.DoesNotExist,
            Person.DoesNotExist,
            Project.DoesNotExist,
            RawData.DoesNotExist,
        ):
            continue
