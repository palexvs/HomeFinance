# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $(".best_in_place").best_in_place()

  $('#main')
    .on('ajax:error', 'a.transaction-new', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-new', (xhr, data) -> ShowTransEditForm(data))
    .on('ajax:error', 'a.transaction-edit', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-edit', (xhr, data) -> ShowTransEditForm(data))    
    .on("ajax:error", '.best_in_place', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-delete', (xhr, data) -> RemoveTransaction(data))        
#    .on("ajax:success", '.best_in_place', -> alert('Name updated for '+$(this).data('userName')) )


RemoveTransaction= (data) ->
  newAlert('success', 'Transaction was successfully delete.')
  $('tr#transaction_' + data['id']).fadeOut(500, () -> $(this).remove() )


# Show Outlay Edit Form
ShowTransEditForm= (html) ->
  OpenModalWindow(html)
  $('#myModal form input.datepicker[type="text"]').datepicker()
  $('#myModal form.trans-edit')
    .on('ajax:error', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', (xhr, data) -> UpdateTrans())    

# Update Transaction List
UpdateTrans= () ->
  CloseModalWindow()
  LoadProjectList()
  LoadBalanceWidget()

LoadProjectList= () ->
  $.ajax
    type: 'GET'
    url: '/transactions'
    data: {partial: true}
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
      HandleCommonErr(textStatus)
    success: (data, textStatus, jqXHR) ->
        $('#transactions').html "#{data}"