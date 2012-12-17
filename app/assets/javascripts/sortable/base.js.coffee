class @TheSortableTree
  max_levels  = 3
  rebuild_url = '/'

  init: ->
    $('ol.sortable').nestedSortable
      disableNesting: 'no-nest'
      forcePlaceholderSize: true
      handle: 'i.icon-move'
      helper: 'clone'
      items:  'li.entity'
      maxLevels: @max_levels
      opacity: .6
      placeholder: 'placeholder'
      revert: 250
      tabSize: 25
      tolerance: 'pointer'
      toleranceElement: '> div'

    $('ol.sortable').sortable
      update: (event, ui) =>
        parent_id = ui.item.parent().parent().attr('id')
        item_id   = ui.item.attr('id')
        prev_id   = ui.item.prev().attr('id')
        next_id   = ui.item.next().attr('id')

        @rebuild item_id, parent_id, prev_id, next_id

  rebuild: (item_id, parent_id, prev_id, next_id) =>
    $.ajax
      type:       'POST'
      dataType:   'script'
      url:        @rebuild_url
      data:
        id:        item_id
        parent_id: parent_id
        prev_id:   prev_id
        next_id:   next_id

      beforeSend: (xhr) ->
        $('.nested_set i.icon-move').hide()

      success: (data, status, xhr) -> 
        $('.nested_set i.icon-move').show()

      error: (xhr, status, error) ->
        alert error