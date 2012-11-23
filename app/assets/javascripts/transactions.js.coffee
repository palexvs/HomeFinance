# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  $('#main')
    .on('ajax:error', 'a.transaction-new', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-new', (xhr, data) -> ShowTransEditForm(data, "create"))
    .on('ajax:error', 'a.transaction-edit', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', 'a.transaction-edit', (xhr, data) -> ShowTransEditForm(data, "update"))
    .on('ajax:success', 'a.transaction-delete', (xhr, data) -> RemoveTransaction( $(this)  ))   


RemoveTransaction= (el) ->
  oTable = $("#transactions-list").dataTable()
  oTable.fnDeleteRow( el.closest("tr")[0] )
  LoadBalanceWidget()
  newAlert('Transaction removed successfully')

# Show Outlay Edit Form
ShowTransEditForm= (html, action) ->
  OpenModalWindow(html)
  $('#myModal form input.datepicker[type="text"]').datepicker()
  $('#myModal form.trans-edit')
    .on('ajax:error', (xhr, err) -> HandleCommonErr(err))
    .on('ajax:success', (xhr, data) -> UpdateTransRow(action, data))

# Update Transaction List
UpdateTransRow= (action, data) ->
  CloseModalWindow()

  if action == "create"
    $("#transactions-list").dataTable().fnAddData(data)
  else if action == "update"
    $("#transactions-list").dataTable().fnUpdate(data, $("tr##{data.DT_RowId}")[0])

  LoadBalanceWidget()
  newAlert('Transaction '+action+'d successfully')

# LoadProjectList= () ->
#   $.ajax
#     type: 'GET'
#     url: '/transactions'
#     data: {partial: true}
#     dataType: 'html'
#     error: (jqXHR, textStatus, errorThrown) ->
#       HandleCommonErr(textStatus)
#     success: (data, textStatus, jqXHR) ->
#         $('#transactions').html "#{data}"