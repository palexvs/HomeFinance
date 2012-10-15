#jQuery ->
# Show AjaxLoading Image when wait server's answer  
#  $("#ajax-req-processing").ajaxSend((event, xhr, options) -> $(this).show() )
#    .ajaxStop( () -> $(this).fadeOut("fast") )
jQuery ->
  $.datepicker.setDefaults
    dateFormat: "yy-mm-dd",
    firstDay: 1

@OpenModalWindow= (html) ->
  $('#myModal').modal('hide')
  $(html).appendTo('#modal').hide()
  $('#myModal').on('hidden', -> $('#modal').empty() )
  $('#myModal').modal
    backdrop: 'static',
    show: 'true'

@CloseModalWindow= () ->
  $('#myModal').modal('hide')

@HandleCommonErr= (errors) ->
  newAlert(msg, 'error') for msg in $.parseJSON(errors.responseText)

@newAlert= (message, type = 'success') ->
  $("#alert-area").html($("<div class='alert-message alert alert-" + type + " fade in' data-alert><p> " + message + " </p></div>"))
  $(".alert-message").delay(2000).fadeOut("slow", -> $(this).remove() )