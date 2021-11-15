"""Script to parse the RawData model and extract CoPED-managed resources from it.

The set of functions below parse raw JSON data from crawler dumps
and use the extracted values to update or create new records of
the appropriate resource type in the CoPED database."""


from django.db import transaction
from core.models.raw_data import RawData
from core.models.project import Project
from core.models.fund import Fund
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.external_link import ExternalLink


def populate(bot_name):
    """Parse all UKRI raw data records and populate CoPED resource tables from them."""

    # Only populate resources corresponding to the current bot/scraper name.
    ukri_raw = RawData.objects.filter(bot=bot_name)

    # Specify a mapping from UKRI resources types to functions that can
    # parse their data structures to extract data for the CoPED database.
    populate_functions = {
        "projects": populate_projects,
        "organisations": populate_organisations,
        "persons": populate_persons,
    }

    # Context manage the database transaction to ensure rollback if anything fails.
    with transaction.atomic():
        # Process each raw data record separately, by sending it to the appropriate function.
        for scraped_data in ukri_raw:
            url = scraped_data.url
            resource_type = url.split("/")[-2]
            if resource_type in populate_functions.keys():
                populate_functions[resource_type](scraped_data)


def ukri_web_link(ukri_id, resource_type):
    """Generate a URL for accessing resource information on the UKRI website."""

    return f"https://gtr.ukri.org/{resource_type}/{ukri_id}"


def coped_external_link(ukri_id, resource_type, description=None):
    """Generate an ExternalLink instance for adding to CoPED resources.

    Note that this function does not save the external link. It can be
    saved by adding it to a many-to-many field on a resource whose target
    model is ExternalLink, then saving that resource."""

    if description is None:
        description = f"UKRI {resource_type} entry"

    external_link, _ = ExternalLink.objects.get_or_create(
        link=ukri_web_link(ukri_id, resource_type)
    )
    external_link.description = description
    return external_link


def populate_projects(raw_data):
    project, _ = Project.objects.get_or_create(raw_data=raw_data)

    # Set the project information.
    json = raw_data.json
    project.title = json.get("title", "No Title")
    project.description = json.get("abstractText", "No Description")

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), resource_type="project")
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
    external_link = coped_external_link(json.get("id"), resource_type="organisation")
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
    external_link = coped_external_link(json.get("id"), resource_type="person")
    person.external_links.add(external_link)

    # Send to the database.
    person.save()
