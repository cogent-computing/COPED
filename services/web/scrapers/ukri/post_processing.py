from django.db import transaction
from core.models.raw_data import RawData
from core.models.project import Project
from core.models.fund import Fund
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.external_link import ExternalLink


def populate_resources(spider_name):
    """Parse all UKRI raw data records and populate CoPED resource tables from them."""

    ukri_raw = RawData.objects.filter(bot=spider_name)

    populate = {
        "projects": populate_projects,
        "funds": populate_funds,
        "organisations": populate_organisations,
        "persons": populate_persons,
    }

    with transaction.atomic():
        for scraped_data in ukri_raw:
            # Send to the correct function to process.
            url = scraped_data.url
            resource_type = url.split("/")[-2]
            populate[resource_type](scraped_data)


def ukri_web_link(ukri_id, resource_type):
    return f"https://gtr.ukri.org/{resource_type}/{ukri_id}"


def coped_external_link(ukri_id, resource_type, description=None):

    if description is None:
        description = f"UKRI {resource_type} entry"

    external_link, _ = ExternalLink.objects.get_or_create(
        link=ukri_web_link(ukri_id, resource_type)
    )
    external_link.description = description
    external_link.save()
    return external_link


def populate_funds(raw_data):
    fund, _ = Fund.objects.get_or_create(raw_data=raw_data)

    # Set the fund information.
    json = raw_data.json
    fund.title = json.get("start", "No Title")
    fund.about = json.get("created", "No Description")

    # Send to the database.
    fund.save()


def populate_projects(raw_data):
    project, _ = Project.objects.get_or_create(raw_data=raw_data)

    # Set the project information.
    json = raw_data.json
    project.title = json.get("title", "No Title")
    project.description = json.get("abstractText", "No Description")

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), "project")
    project.external_links.add(external_link)

    # Send to the database.
    project.save()


def populate_organisations(raw_data):
    organisation, _ = Organisation.objects.get_or_create(raw_data=raw_data)

    # Set the organisation information.
    json = raw_data.json
    organisation.name = json.get("name", "No Name")
    organisation.about = json.get("id", "No Information")

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), "organisation")
    organisation.external_links.add(external_link)

    # Send to the database.
    organisation.save()


def populate_persons(raw_data):
    person, _ = Person.objects.get_or_create(raw_data=raw_data)

    # Assign the person information.
    json = raw_data.json
    person.first_name = json.get("firstName", "(No First Name)")
    person.other_name = json.get("otherNames", "")
    person.last_name = json.get("surname", "(No Surname)")
    person.email = json.get("email", "")
    person.orcid_id = json.get("orcidId", "")

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), "person")
    person.external_links.add(external_link)

    # Send to the database.
    person.save()
