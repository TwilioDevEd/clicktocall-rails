// Execute JavaScript on page load
$(function() {
 
    var $form = $('#contactform'),
        $submit = $('#contactform input[type=submit]');

    // Intercept form submission
    $form.on('submit', function(e) {
        // Prevent form submission and repeat clicks
        e.preventDefault();
        $submit.attr('disabled', 'disabled');

        // Submit the form via ajax
        $("#userPhone").val(userPhone.getNumber());
        $("#salesPhone").val(salesPhone.getNumber());
        
        $.ajax({
            url:'/call',
            method:'POST',
            data: $form.serialize()
        }).done(function(data) {
            alert(data.message);
        }).fail(function() {
            alert('There was a problem calling you - please try again later.');
        }).always(function() {
            $submit.removeAttr('disabled');
        });

    });
});
