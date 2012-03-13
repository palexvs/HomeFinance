function newAlert (type, message) {
    $("#alert-area").html($("<div class='alert-message alert alert-" + type + " fade in' data-alert><p> " + message + " </p></div>"));
    $(".alert-message").delay(2000).fadeOut("slow", function () { $(this).remove(); });
}