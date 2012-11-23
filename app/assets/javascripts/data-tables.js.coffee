jQuery ->
  $.extend( $.fn.dataTableExt.oStdClasses, {
      "sSortAsc": "header headerSortDown",
      "sSortDesc": "header headerSortUp",
      "sSortable": "header",
      "sSortableNone": "header"
  } )

  $.extend( $.fn.dataTableExt.oJUIClasses, {
      "sSortAsc": "header headerSortDown",
      "sSortDesc": "header headerSortUp",
      "sSortable": "header",
      "sSortableNone": "header"
  } )  

  $('#transactions-list').dataTable
    sDom: "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    bJQueryUI: true
    bPaginate: false
    # bLengthChange: false
    bFilter: true
    bSort: true
    bInfo: false
    bAutoWidth: false    
    aaSorting: [[ 0, "desc" ]]
    aoColumns: [
      { "sClass": "date", "mData": "date" }
      { "sClass": "description", "mData": "desc" }
      { "sClass": "type", "mData": "type" }
      { "sClass": "amount", "mData": "amount" }
      { "sClass": "account", "mData": "account" }
      { "sClass": "category", "mData": "category" }
      { "sClass": "control", "bSortable": false, "mData": "control" }
    ]