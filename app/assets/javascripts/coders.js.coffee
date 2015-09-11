# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body.coders.show').ready ->
    $('#history-table').DataTable
        order: [[0, 'desc']]
        processing: true
        serverSide: true
        ajax: $('#history-table').data('source')
        pagingType: 'full_numbers'
        columnDefs: [
                targets: 3
                orderable: false
            ,
                targets: 1
                className: "text-right"
        ]
        language: window.default_pagination_language

    $('#bounty-table').DataTable
        order: [[0, 'desc']]
        processing: true
        serverSide: true
        ajax: $('#bounty-table').data('source')
        pagingType: 'full_numbers'
        columnDefs: [
            targets: 1
            className: "text-right"
        ]
        language: window.default_pagination_language


$('body.scoreboard.index').ready ->
    table = $('#scoreboard').DataTable
        order: [[3, 'desc']]
        columnDefs: [
                targets: ['rank', 'avatar']
                orderable: false
                searchable: false
            ,
                targets: ['score', 'commits', 'additions', 'deletions']
                orderSequence: ['desc', 'asc']
                render: (data, type, _row, _meta) ->
                    if type is 'display'
                        return data
                    else
                        return data.replace(/[^\d]/g, '')
        ]
        bFilter: false
        paging: false
        autoWidth: false
        info: false

    # Recalculate rank column when table changes, so it stays fixed
    table.on 'order.dt search.dt', ->
        table.column '.rank',
            search: 'applied'
            order: 'applied'
        .nodes().each (cell, i) ->
            cell.innerHTML = (i + 1) + '.'
