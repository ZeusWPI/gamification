# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body.bounties-page.index').ready ->

    # Added a parser for the my-bounty input fields
    $.fn.dataTable.ext.order['dom-input-numeric'] = (_settings, col) ->
        return this.api().column(col, {order: 'index'}).nodes().map (td, _i) ->
            return $('input#bounty_value', td).val() * 1

    $('#bounties-table').DataTable
        order: [[2, 'desc'], [0, 'asc'], [1, 'asc']]
        columnDefs: [
                targets: ['total-bounty', 'my-bounty']
                orderSequence: ['desc', 'asc']
                render: (data, type, _row, _meta) ->
                    if type is 'display'
                        return data
                    else
                        return data.replace(/[^\d]/g, '')
            ,
                targets: ['my-bounty']
                orderDataType: 'dom-input-numeric'
                type: 'numeric'
        ]
        dom: "<'row'<'col-sm-12'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12'p>>",
        autoWidth: false
        pagingType: 'full_numbers'
        language: default_pagination_language
