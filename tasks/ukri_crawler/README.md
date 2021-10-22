# URKI Crawler

Crawler for project meta-data API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

## Running the Crawler

To manually run the crawler use:

`docker-compose run --rm -w /app/ukri/ukri crawlers scrapy crawl ukri-projects-crawler -a queries=<queries>`

Here `<queries>` should be a comma separated list of words and "phrases" to search for.

## Entrypoints

For each search term, the following API endpoint is used to find matching projects.

`https://gtr.ukri.org/gtr/api/projects?q={search_term}`

## Related Data

Given a project id from a returned search, related entities are also parsed and saved when present.

- Persons: `https://gtr.ukri.org/gtr/api/projects/{project_id}/persons`
- Organisations: `https://gtr.ukri.org/gtr/api/projects/{project_id}/organisations`
- Funds: `https://gtr.ukri.org/gtr/api/projects/{project_id}/funds`
- Outcomes:
    * Key Findings: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/keyfindings`
    * Impact Summaries: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/impactsummaries`
    * Publications: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/publications`
    * Collaborations: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/collaborations`
    * Intellectual Properties: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/intellectualproperties`
    * Further Fundings: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/furtherfundings`
    * Policy Influences: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/policyinfluences`
    * Products: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/products`
    * Research Materials: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/researchmaterials`
    * Spinouts: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/spinouts`
    * Disseminations: `https://gtr.ukri.org/gtr/api/projects/{project_id}/outcomes/disseminations`

## Related Data `rel` Descriptors

The relations documented for the UKRI API are:

### `rel` Values for Person Links

Linked person is:

- `PI_PER` Principal Investigator
- `COI_PER` Co-Investigator
- `PM_PER` Project Manager
- `FELLOW_PER` Fellow
- `EMPLOYEE` Employee

### `rel` Values for ORCID Links

Linked ORCID is:

- `ORCID_ID` Person's ORCID ID details

### `rel` Values for Organisation Links

Linked org is:

- `EMPLOYED` Employer
- `LEAD_ORG` Lead research organisation
- `COLLAB_ORG` Collaborating organisation
- `FELLOW_ORG` Fellow organisation
- `COFUND_ORG` Co-Funder
- `PP_ORG` Project partner
- `FUNDER` Funder

### `rel` Values for Fund Links

Linked fund is:

- `FUND` Fund

### `rel` Values for Project Links

Linked project is:

- `PROJECT` Project

### `rel` Values for Outcome Links

Linked outcome is:

- `ARTISTIC_AND_CREATIVE_PRODUCT` Artistic and creative product
- `COLLABORATION` Collaboration
- `DISSEMINATION` Dissemination
- `FURTHER_FUNDING` Further funding
- `IMPACT_SUMMARY` Impact summary
- `IP` Intellectual property
- `KEY_FINDING` Key finding
- `POLICY` Policy influence
- `PRODUCT` Product intervention
- `PUBLICATION` Publication
- `RESEARCH_DATABASE_AND_MODEL` Research DB and model
- `RESEARCH_MATERIAL` Research material
- `SOFTWARE_AND_TECHNICAL_PRODUCT` Software and technical product
- `SPIN_OUT` Spin out
