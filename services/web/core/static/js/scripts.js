/*!
* Start Bootstrap - Landing Page v5.1.0 (https://startbootstrap.com/theme/landing-page)
* Copyright 2013-2021 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-landing-page/blob/master/LICENSE)
*/
// This file is intentionally blank
// Use this file to add JavaScript to your project

(function () {
    const endpoint = '/subjects/suggest/?term=';

    // add results to HTML li
    function displayMatches(event) {
        let value = ""
        value = event.target.value;
        if (value.length < 3) return;
        fetch(`${endpoint}${value}`)
            .then(blob => blob.json())
            .then(data => data['results'])
            .then(results => {
                console.log(results);
                return results;
            })
            .then(results => {
                list_items = results.map(result => `<li>${result}</li>`);
                return list_items.join('');
            })
            .then(html => {
                suggestions.innerHTML = html;
            });
    }

    const searchInput = document.querySelector('.search-input');
    const suggestions = document.querySelector('.suggestions');

    searchInput.addEventListener('change', displayMatches);
    searchInput.addEventListener('keyup', displayMatches);
})();


