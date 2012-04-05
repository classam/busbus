$(function() {
    console.log("POOSH");

// Any images too large for the article get shifted left
$("article img").each(function(i, img) {
    $(img).load( function(){
        var parent_width = $(img).parent().width();
        var image_width =  $(img).width();
        if( image_width > parent_width )
        {
            $(img).css({
                position: "relative",
                left: ($(img).parent().width() - $(img).width()) / 2
            });
        }
    });
});

});

