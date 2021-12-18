/*!
* Start Bootstrap - Landing Page v5.1.0 (https://startbootstrap.com/theme/landing-page)
* Copyright 2013-2021 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-landing-page/blob/master/LICENSE)
*/
// This file is intentionally blank
// Use this file to add JavaScript to your project

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

})();
