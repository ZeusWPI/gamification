@test = (url, filters) ->
  $.post(
    url
    { filters: filters }
  ).success (rows) -> 
    $('#scoreboard tbody').html(rows)
