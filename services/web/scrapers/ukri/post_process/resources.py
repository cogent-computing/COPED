"""Script to parse the RawData model and extract CoPED-managed resources from it.

The set of functions below parse raw JSON data from crawler dumps
and use the extracted values to update or create new records of
the appropriate resource type in the CoPED database.

TODO: compare RawData content with existing record to determine whether/what to update."""


from datetime import datetime
from django.db import transaction
from core.models.raw_data import RawData
from core.models.project import Project
from core.models.organisation import Organisation
from core.models.person import Person
from core.models.external_link import ExternalLink
from core.models.address import Address


def populate(bot_name="ukri-projects-spider"):
    """Parse all UKRI raw data records and populate CoPED resource tables from them."""

    # Only populate resources corresponding to a specific bot/scraper name.
    raw_data_records = RawData.objects.filter(bot=bot_name)

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
    json = raw_data_record.json
    project.title = json.get("title", NO_VALUE)
    project.status = json.get("status", NO_VALUE)
    if json.get("start"):
        project.start = datetime.utcfromtimestamp(json.get("start")).date()
    if json.get("end"):
        project.end = datetime.utcfromtimestamp(json.get("end")).date()

    # Pull out text from various fields and collate it.
    # Add markdown for section formatting in the UI.
    text = []
    text.append("## Lead Funder")
    text.append(json.get("leadFunder") or NO_VALUE)
    text.append("## Lead Department")
    text.append(json.get("leadOrganisationDepartment") or NO_VALUE)
    text.append("## Abstract")
    text.append(json.get("abstractText") or NO_VALUE)
    text.append("## Technical Abstract")
    text.append(json.get("techAbstractText") or NO_VALUE)
    text.append("## Grant Category")
    text.append(json.get("grantCategory") or NO_VALUE)
    text.append("## Potential Impact")
    text.append(json.get("potentialImpact") or NO_VALUE)
    # Use the combined text to populate the project information
    # print(text)
    project.description = "\n\n".join(text)

    # Add the external UKRI link
    external_link = coped_external_link(json.get("id"), resource_type="project")
    project.external_links.add(external_link)

    # Send to the database.
    project.save()


def populate_organisations(raw_data):
    organisation, _ = Organisation.objects.get_or_create(raw_data=raw_data)

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
