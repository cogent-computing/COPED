/*!
* Start Bootstrap - Landing Page v5.1.0 (https://startbootstrap.com/theme/landing-page)
* Copyright 2013-2021 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-landing-page/blob/master/LICENSE)
*/
// This file is intentionally blank
// Use this file to add JavaScript to your project

// TODO: abstract the following completions using a factory
(function () {

    $('.advancedAutoCompleteProject').autoComplete({
        resolver: 'custom',
        events: {
            search: function (qry, callback) {
                // let's do a custom ajax call
                $.ajax(
                    `/subjects/suggest/?term=${qry}`
                ).done(function (res) {
                    console.log(res)
                    callback(res.results)
                });
            }
        }
    });
    $('.advancedAutoCompleteTitle').autoComplete({
        resolver: 'custom',
        minLength: 4,
        events: {
            search: function (qry, callback) {
                // let's do a custom ajax call
                $.ajax(
                    `/projects/suggest/?q=${qry}`
                ).done(function (res) {
                    console.log(res)
                    callback(res.results)
                });
            },
            searchPost: function (resultsFromServer, origJQElement) {
                return resultsFromServer.map(r => `"${r}"`).slice(0, 24);
            }
        }
    });
    $('.advancedAutoCompleteOrganisation').autoComplete({
        resolver: 'custom',
        events: {
            search: function (qry, callback) {
                // let's do a custom ajax call
                $.ajax(
                    `/organisations/suggest/?term=${qry}`
                ).done(function (res) {
                    console.log(res)
                    callback(res.results)
                });
            }
        }
    });
    $('.advancedAutoCompletePerson').autoComplete({
        resolver: 'custom',
        events: {
            search: function (qry, callback) {
                // let's do a custom ajax call
                $.ajax(
                    `/people/suggest/?term=${qry}`
                ).done(function (res) {
                    console.log(res)
                    callback(res.results)
                });
            }
        }
    });

})();

$(function () {
    $('[data-toggle="tooltip"]').tooltip()
});


$(document).ready(function () {
    $('#sortTable').DataTable({
        "order": [[1, "desc"]]
    });
});