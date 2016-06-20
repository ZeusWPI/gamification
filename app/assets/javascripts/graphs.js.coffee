# Graph-stuff-code
# Generalised way to send an ajax request to load a chart when a
# link is clicked with data-load="graph"

$('body.coders-page.show, body.repositories-page.show').ready ->
    $('a[data-load="graph"]').on 'shown.bs.tab', (e) ->
        # Only initialise the chart the first time we click the tab
        # Google_visualr adds those classes when it is initialised so it's safe to
        # filter on those classes
        if !$("#chart").hasClass('google-visualization-atl container')
            $.ajax
                url: $(this).data('graphurl') + '.js'
                type: 'GET'
