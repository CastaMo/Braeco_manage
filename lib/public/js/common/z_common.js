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
    $("#extrabar-top").click(function() {
        $("html, body").animate({ scrollTop: 0 }, "fast");
    });
});