jQuery ->
  $(".best_in_place").best_in_place()

  $('#main')
    .on("ajax:success", '.best_in_place', -> UpdateTransViaBIP( $(this) ))
    .on('best_in_place:error', (xhr, err) -> HandleCommonErr(err))

UpdateTransViaBIP = ( el ) ->
  oTable = $("#transactions-list").dataTable()
  td = el.closest("td")
  p = oTable.fnGetPosition( td[0] )
  oTable.fnUpdate(td.html(), p[0], p[1])


  LoadBalanceWidget()
  newAlert('Transaction updated successfully')