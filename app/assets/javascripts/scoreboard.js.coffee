@get_scoreboard = (url, filters) ->
  $.post(
    url
    { filters: filters }
  ).success (rows) ->
    $('#scoreboard tbody').html(rows)
