from django.db import transaction
from core.models.raw_data import RawData
from core.models.project import Project
from core.models.fund import Fund
from core.models.organisation import Organisation
from core.models.person import Person


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


def populate_projects(raw_data):
    item, _ = Project.objects.get_or_create(raw_data=raw_data)

    # Set the item information.
    json = raw_data.json
    item.title = json.get("title", "No Title")
    item.description = json.get("abstractText", "No Description")

    # Send to the database.
    item.save()


def populate_funds(raw_data):
    item, _ = Fund.objects.get_or_create(raw_data=raw_data)

    # Set the item information.
    json = raw_data.json
    item.title = json.get("start", "No Title")
    item.about = json.get("created", "No Description")

    # Send to the database.
    item.save()


def populate_organisations(raw_data):
    item, _ = Organisation.objects.get_or_create(raw_data=raw_data)

    # Set the item information.
    json = raw_data.json
    item.name = json.get("name", "No Name")
    item.about = json.get("id", "No Information")

    # Send to the database.
    item.save()


def populate_persons(raw_data):
    item, _ = Person.objects.get_or_create(raw_data=raw_data)

    # Set the item information.
    json = raw_data.json
    item.first_name = json.get("firstName", "(No First Name)")
    item.last_name = json.get("surname", "(No Surname)")
    item.about = json.get("orcidId", "")

    # Send to the database.
    item.save()
