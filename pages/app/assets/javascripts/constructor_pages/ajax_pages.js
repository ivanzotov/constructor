//= require constructor_pages/jquery.history.js

$(document).ready(function() {
    $page = {};

    var History = window.History;

    if ( !History.enabled ) { return false }

    History.Adapter.bind(window,'statechange',function(){
        update_page(History.getState().url);
    });


    update_pages();
});

function update_pages(){
    $('.b-page-json').each(function(index, el){
        var _href = $(el).attr('href');

        $(el).unbind('click');

        $(el).click(function(event){
            event.preventDefault();
            History.pushState(null, null, _href);
        });
    });
}

function update_page(href) {

    $.get(href+'.json', function(page){
        $page = page;

        $('title').html(page.title || page.name);

        var partials = JSON.parse(page.template);
        var names = Object.keys(partials);

        for (i in names) {
            var name = names[i];

            $('.b-page-part__'+name).html(partials[name]);
        }

        $("[class*='b-page-json__id-']").removeClass('active');

        for (var i in $page.self_and_ancestors) {
            $('.b-page-json__id-'+$page.self_and_ancestors[i]).addClass('active');
        }

        update_pages();

        if (typeof Retina != 'undefined') {
            Retina.update();
        }

        eval(page.js);
    });
}