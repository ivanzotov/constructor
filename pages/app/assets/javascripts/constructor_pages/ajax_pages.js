$(document).ready(function() {
    $page = {};
    update_pages();
});

function update_pages(){
    $('.b-page-json').each(function(index, el){
        var _href = $(el).attr('href');

        $(el).unbind('click');

        $(el).click(function(event){
            event.preventDefault();
            history.pushState(null, null, _href);

            window.onpopstate = function(){
                update_page(window.location.href.toString().split(window.location.host)[1]);
            };

            update_page(_href, el);
        });
    });
}

function update_page(href, el) {
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

        eval(page.js);
    });
}