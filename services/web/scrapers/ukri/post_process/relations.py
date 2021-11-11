from core.models.project import Project
from core.models.fund import Fund
from core.models.organisation import Organisation
from core.models.person import Person


def populate(bot_name):
    """Parse all resources with a UKRI raw data source to get their relations.

    Extract links from the associated raw data, and use these to link to other CoPED resources.
    NB: this function assumes that resources have already been populated from the raw data."""

    ukri_projects = Project.objects.filter(raw_data__bot=bot_name)

    link_models = {
        "projects": Project,
        "funds": Fund,
        "organisations": Organisation,
        "persons": Person,
    }

    known_resource_types = ["organisations", "persons"]  # TODO: get these from DB

    for project in ukri_projects:
        raw_data = project.raw_data
        links = raw_data.json.get("links", {}).get("link", [])
        for link in links:
            href = link.get("href", "")
            rel = link.get("rel", "")
            if not href or not rel:
                continue
            resource_type = href.split("/")[-2]
            if not resource_type or resource_type not in known_resource_types:
                continue
            resource_model = link_models[resource_type]
            try:
                resource = resource_model.objects.get(raw_data__url=href)
                link_field = getattr(project, resource_type)
                link_field.add(resource, through_defaults={"role": rel})
            except resource_model.DoesNotExist:
                continue
