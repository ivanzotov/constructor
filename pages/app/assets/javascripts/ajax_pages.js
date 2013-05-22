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

            update_page(_href);
        });
    });
}

function update_page(href) {
    var _b_page_json = $('.b-page-json');

    close_blocks();

    $.get(href+'.json', function(page){
        $page = page;

        $('title').html(page.title || page.name);

        var partials = JSON.parse(page.template);
        var names = Object.keys(partials);

        for (i in names) {
            var name = names[i];

            $('.b-page-part__'+name).html(partials[name]);
        }

        _b_page_json.parent().removeClass('active');

        for (var i in $page.ancestors) {
            var ancestor = $page.ancestors[i];
            $('.b-page-json__id-'+ancestor).addClass('active');
        }

        el.parent().addClass('active');

        update_pages();

        eval(page.js);
    });

    var el = $('a[href="'+ href +'"]');
}