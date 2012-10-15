# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $(".best_in_place").best_in_place()

  $('#main')
    .on('ajax:error', 'a.transaction-new', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-new', (xhr, data) -> ShowTransEditForm(data, "create"))
    .on('ajax:error', 'a.transaction-edit', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-edit', (xhr, data) -> ShowTransEditForm(data, "update"))
    .on('ajax:success', 'a.transaction-delete', (xhr, data) -> RemoveTransaction(data))   
    .on("ajax:success", '.best_in_place', -> UpdateTransViaBIP())
    .on('best_in_place:error', (xhr, err) -> HandleCommonErr(err))


UpdateTransViaBIP = () ->
  LoadBalanceWidget()
  newAlert('Transaction updated successfully')

RemoveTransaction= (data) ->
  $('tr#transaction_' + data['id']).fadeOut('fast', () -> $(this).remove() )
  LoadBalanceWidget()
  newAlert('Transaction removed successfully')

# Show Outlay Edit Form
ShowTransEditForm= (html, action) ->
  OpenModalWindow(html)
  $('#myModal form input.datepicker[type="text"]').datepicker()
  $('#myModal form.trans-edit')
    .on('ajax:error', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', (xhr, data) -> UpdateTransList(action))

# Update Transaction List
UpdateTransList= (action) ->
  CloseModalWindow()
  LoadProjectList()
  LoadBalanceWidget()
  newAlert('Transaction '+action+'d successfully')

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