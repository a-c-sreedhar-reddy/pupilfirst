$(document).on 'page:change', ->
  $('#karma_points_filter_after').datepicker({ dateFormat: 'dd-mm-yy' })
  $('#karma_points_filter_before').datepicker({ dateFormat: 'dd-mm-yy' })
