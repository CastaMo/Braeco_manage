$(document).ready(function() {
    $(document).click(function(e) {
        var target = e.target;
        if (!$(target).is('#guide-content') && !$(target).parents().is('#guide-content')) {
            if (!$(target).is("#guide-description") && !$(target).parents().is("#guide-description")) {
                $('#guide-content').hide();
            }
        }
    });
    $("#guide-description").click(function() {
        $("#guide-content").toggle();
    });
    $(".step-content").hover(function() {
        var id = $(this).attr('id');
        var greyImage = id+'-grey-image-container';
        var yellowImage = id+'-yellow-image-container';
        $(this).find('.image-container').removeClass(greyImage).addClass(yellowImage);
    }, function() {
        var id = $(this).attr('id');
        var greyImage = id+'-grey-image-container';
        var yellowImage = id+'-yellow-image-container';
        $(this).find('.image-container').removeClass(yellowImage).addClass(greyImage);
    });
    $(".step-content").click(function() {
        var id = $(this).attr('id');
    });

    $("#extrabar-top").click(function() {
        $("html, body").animate({ scrollTop: 0 }, "fast");
    });
});