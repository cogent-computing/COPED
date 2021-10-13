# URKI Crawler

Project crawler for project meta-data API described at https://gtr.ukri.org/resources/GtR-2-API-v1.7.5.pdf

## Running the Crawler

To manually run the crawler:

1. Go to the top level directory containing `scrapy.cfg`
2. Run `scrapy crawl ukri-projects-spider`

## Entrypoints

For each search term in some list, the following API endpoint is used to extract matching projects.

`https://gtr.ukri.org/gtr/api/projects?q={search_term}`

## Related Data

Given a project id from a returned search, related entities are parsed and saved when present.

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
