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
#    .on("ajax:success", '.best_in_place', -> alert('Name updated for '+$(this).data('userName')) )

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
#  LoadProjectList()