@get_scoreboard = (url, filters) ->
  $.post(
    url
    { filters: filters }
  ).success (rows) ->
    $('#scoreboard tbody').html(rows)
    resort = true
    $('#scoreboard').trigger('update', [resort]);
