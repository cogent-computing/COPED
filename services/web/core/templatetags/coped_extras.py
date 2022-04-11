from django import template

register = template.Library()


@register.simple_tag
def favourite_count(user):
    if not user.is_authenticated:
        return None
    else:
        count = user.projectsubscription_set.count()
        count += user.personsubscription_set.count()
        count += user.organisationsubscription_set.count()
        return count
