from django.views import generic


class FilteredListView(generic.ListView):
    filterset_class = None
    order_by = None

    def get_queryset(self):
        # Get the standard queryset, which will use the subclass "model" attribute.
        queryset = super().get_queryset()
        if self.order_by is not None:
            queryset = queryset.order_by(self.order_by)
        # Then use the query parameters and the queryset to
        # instantiate a filterset and save it as an attribute
        # on the view instance for use later when setting the context.
        self.filterset = self.filterset_class(self.request.GET, queryset=queryset)
        # Return the filtered queryset
        return self.filterset.qs.distinct()

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Pass the filterset to the template - it provides the form.
        context["filter"] = self.filterset
        return context
