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

@ShowErrMsg= (errors) ->
  errs = $.parseJSON(errors.responseText)
  newAlert('error', errs)

@HandleCommonErr= (errors) ->
  ShowErrMsg(errors)