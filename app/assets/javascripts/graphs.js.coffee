# Graph-stuff-code
# Generalised way to send an ajax request to load a chart when a
# link is clicked with data-load="graph"

$('body.coders.show, body.repositories.show').ready ->
    $('a[data-load="graph"]').on 'shown.bs.tab', (e) ->
        if !$("#chart").hasClass('google-visualization-atl container')
            $.ajax
                url: $(this).data('graphurl') + '.js'
                type: 'GET'
