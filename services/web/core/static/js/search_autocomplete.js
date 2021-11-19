$(function () {
    'use strict';

    $('#q').autoComplete({
        source: function (term, response) {
            $.getJSON('/search/autocomplete/', { q: term }, function (data) { response(data); });
        }
    });

});
