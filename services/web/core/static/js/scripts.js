/*!
* Start Bootstrap - Landing Page v5.1.0 (https://startbootstrap.com/theme/landing-page)
* Copyright 2013-2021 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-landing-page/blob/master/LICENSE)
*/
// This file is intentionally blank
// Use this file to add JavaScript to your project

function autocompleteMatch(input) {
    if (input == '') {
        return [];
    }
    var reg = new RegExp(input)
    return search_terms.filter(function (term) {
        if (term.match(reg)) {
            return term;
        }
    });
}

function showResults(val) {
    res = document.getElementById("autocomplete-result");
    res.innerHTML = '';
    console.log(val);
    if (val == '') {
        return;
    }
    let list = '';
    fetch('/projects/autocomplete/?q=' + val).then(
        function (response) {
            return response.json();
        }).then(function (data) {
            suggestions = data.suggestions;
            for (i = 0; i < suggestions.length; i++) {
                list += '<li><a href="' + suggestions[i].data + '">' + suggestions[i].value + '</a></li>';
            }
            res.innerHTML = '<ul>' + list + '</ul>';
            return true;
        }).catch(function (err) {
            console.warn('Something went wrong.', err);
            return false;
        });
}
