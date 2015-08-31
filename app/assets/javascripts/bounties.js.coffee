# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body.bounties.index').ready ->

    # Added a parser for the my-bounty input fields
    $.fn.dataTable.ext.order['dom-input-numeric'] = (_settings, col) ->
        return this.api().column(col, {order: 'index'}).nodes().map (td, _i) ->
            return $('input#bounty_value', td).val() * 1

    $('#bounties-table').DataTable
        order: [[2, 'desc'], [0, 'asc'], [1, 'asc']]
        columnDefs: [
                targets: ['total-bounty', 'my-bounty']
                orderSequence: ['desc', 'asc']
            ,
                targets: ['my-bounty']
                orderDataType: 'dom-input-numeric'
                type: 'numeric'
        ]
        autoWidth: false
