from haystack.generic_views import FacetedSearchView as BaseFacetedSearchView

# from haystack.forms import FacetedSearchForm
from .forms import FacetedSearchForm

# Now create your own that subclasses the base view
class FacetedSearchView(BaseFacetedSearchView):
    template_name = "facets.html"
    form_class = FacetedSearchForm
    facet_fields = ["status"]
    context_object_name = "object_list"
