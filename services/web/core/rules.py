# Set up for object-level permissions
# The 'rules' app will autodiscover rules here when INSTALLED_APPS contains "rules.apps.AutodiscoverRulesConfig"
# See https://github.com/dfunckt/django-rules for more details

import rules

#######################
## Define predicates ##
#######################

# Note that superusers always pass these tests.


@rules.predicate
def is_owner(user, obj):
    return obj.owner == user


@rules.predicate
def is_contributor(user):
    return user.is_contributor


@rules.predicate
def owns_a_project(user):
    return user.project_set.exists()


@rules.predicate
def owns_a_person(user):
    return user.person_set.exists()


@rules.predicate
def owns_an_organisation(user):
    return user.organisation_set.exists()


@rules.predicate
def owns_something(user):
    return owns_a_project(user) or owns_an_organisation(user) or owns_a_person(user)


########################
## Define permissions ##
########################

rules.add_perm("core.add_project", is_contributor)
rules.add_perm("core.add_subject", is_contributor | owns_a_project)
rules.add_perm("core.add_keyword", is_contributor | owns_a_project)
rules.add_perm("core.add_link", is_contributor | owns_something)
rules.add_perm("core.add_organisation", is_contributor | owns_a_project | owns_a_person)
rules.add_perm("core.add_person", is_contributor | owns_a_project)
rules.add_perm(
    "core.add_address", is_contributor | owns_a_project | owns_an_organisation
)
rules.add_perm(
    "core.add_geo_data", is_contributor | owns_a_project | owns_an_organisation
)

rules.add_perm("core.change_project", is_owner)
rules.add_perm("core.change_organisation", is_owner)
rules.add_perm("core.change_person", is_owner)

rules.add_perm("core.delete_project", is_owner)
