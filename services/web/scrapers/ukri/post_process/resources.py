"""Script to parse the RawData model and extract CoPED-managed resources from it.

The set of functions below parse raw JSON data from crawler dumps
and use the extracted values to update or create new records of
the appropriate resource type in the CoPED database.

TODO: compare RawData content with existing record to determine whether/what to update."""


from datetime import datetime
import logging
from django.db import transaction
from django.template.loader import render_to_string
from core.models.raw_data import RawData
from core.models.project import Project
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.external_link import ExternalLink
from core.models.address import Address


def populate(bot_name="ukri-projects-spider", limit=None):
    """Parse all UKRI raw data records and populate CoPED resource tables from them."""

    # Only populate resources corresponding to a specific bot/scraper name.
    raw_data_records = RawData.objects.filter(bot=bot_name, do_not_populate=False).all()
    if limit:
        raw_data_records = raw_data_records[:limit]

    # Context manage the database transaction to ensure rollback if anything fails.
    with transaction.atomic():
        # Process each raw data record separately, by sending it to the appropriate function.
        for raw_data_record in raw_data_records:
            url = raw_data_record.url
            resource_type = url.split("/")[-2]
            if resource_type == "projects":
                populate_projects(raw_data_record)
            elif resource_type == "organisations":
                populate_organisations(raw_data_record)
            elif resource_type == "persons":
                populate_persons(raw_data_record)


def ukri_web_link(ukri_id, resource_type):
    """Generate a URL for accessing resource information on the UKRI website."""

    return f"https://gtr.ukri.org/{resource_type}/{ukri_id}"


def coped_external_link(ukri_id, resource_type, description=None):
    """Generate an ExternalLink model instance for adding to CoPED resources."""

    if description is None:
        description = f"UKRI {resource_type} entry"

    external_link, _ = ExternalLink.objects.get_or_create(
        link=ukri_web_link(ukri_id, resource_type)
    )
    external_link.description = description
    external_link.save()
    return external_link


def coped_address(address_data_dict):
    """Extract address data for adding to CoPED resources."""

    addr = address_data_dict
    address_data = {
        "city": addr.get("city") or "",
        "country": addr.get("country") or "",
        "county": addr.get("county") or "",
        "line1": addr.get("line1") or "",
        "line2": addr.get("line2") or "",
        "line3": addr.get("line3") or "",
        "line4": addr.get("line4") or "",
        "line5": addr.get("line5") or "",
        "postcode": addr.get("postCode") or "",
        "region": addr.get("region") or "",
    }
    address_record, _ = Address.objects.get_or_create(**address_data)
    return address_record


def populate_projects(raw_data_record):

    # Set string to substitute when no field value found
    NO_VALUE = "-"

    # Set the project information.
    project, _ = Project.objects.get_or_create(raw_data=raw_data_record)

    if project.is_locked:
        logging.warn("Project %s is locked. Skipping update.", project.id)
        return None

    json = raw_data_record.json
    project.title = json.get("title", NO_VALUE)
    project.status = json.get("status", NO_VALUE)
    if json.get("start"):
        project.start = datetime.utcfromtimestamp(json.get("start")).date()
    if json.get("end"):
        project.end = datetime.utcfromtimestamp(json.get("end")).date()

    # Pull out text from various fields and collate it.
    description = render_to_string(
        "ukri_project_description.html",
        {
            "description": (json.get("abstractText") or "").strip(),
        },
    )

    extra_text = render_to_string(
        "urki_project_extra_text.html",
        {
            "technical_abstract": (json.get("techAbstractText") or "").strip(),
            "potential_impact": (json.get("potentialImpact") or "").strip(),
        },
    )

    project.description = description
    project.extra_text = extra_text

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), resource_type="project")
    project.external_links.add(external_link)

    # Send to the database.
    project.save()


def populate_organisations(raw_data):
    organisation, _ = Organisation.objects.get_or_create(raw_data=raw_data)

    if organisation.is_locked:
        logging.warn("Organisation %s is locked. Skipping update.", organisation.id)
        return None

    # Set the organisation information.
    json = raw_data.json
    organisation.name = json.get("name") or "No Name"

    # Add website link if it exists
    if json.get("website"):
        website_link, _ = ExternalLink.objects.get_or_create(link=json.get("website"))
        website_link.description = "Organisation website"
        website_link.save()
        organisation.external_links.add(website_link)

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), resource_type="organisation")
    organisation.external_links.add(external_link)

    # Add addresses
    addresses = json.get("addresses", {}).get("address", [])
    for organisation_address in addresses:
        coped_address_record = coped_address(organisation_address)
        organisation.addresses.add(coped_address_record)

    # Send to the database.
    organisation.save()


def populate_persons(raw_data):
    person, _ = Person.objects.get_or_create(raw_data=raw_data)

    if person.is_locked:
        logging.warn("Person %s is locked. Skipping update.", person.id)
        return None

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
