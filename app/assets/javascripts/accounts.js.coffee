# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@LoadBalanceWidget= () ->
  $.ajax
    type: 'GET'
    url: '/accounts'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      HandleCommonErr(textStatus)
    success: (data, textStatus, jqXHR) ->
        $('#balance_widget table').html BalanceWidgetTemplate(data)

BalanceWidgetTemplate = (accounts) ->
	html = ""
	for account in accounts
		html += "<tr><td class='key'>#{account.name}:</td><td class='value'>#{account.balance.money.to_s}</td></tr>" 
	html
