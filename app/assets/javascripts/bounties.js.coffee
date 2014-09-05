# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    $('.my-bounty').editable(saveBounty, {
        submit: 'Put',
        event:  'mouseover'
    }).mouseover ->
        $(this).parent().removeClass('danger')

$(document).ready ready
$(document).on 'page:load', ready

# Add a click handler for the save buttons that makes an Ajax POST that
# either updates or creates a bounty with the given value.
# - On a successful request, update the total bounty value.
# - On a failed request, show an appropriate flash message.
saveBounty = (value, settings) ->
    url = $(this).attr('data-url')
    issueId = $(this).attr('data-issue')
    $inputDiv = $(this)
    $parentCell = $(this).parent()
    $statusCell = $parentCell.next()

    $statusCell.html('<span style="color: grey">Saving...</span>')

    $.ajax url,
        type: 'POST',
        dataType: 'json',
        accepts: 'json',
        data: {
            issue_id: issueId,
            value: value
        },
        success: (data, textStatus, jqXHR) ->
            # Show a status update
            $statusCell.empty()
            $('<span style="color: green">Saved</span>')
                .appendTo $statusCell
                .fadeIn()
                .fadeOut 1000, ->
                    $(this).remove()
            # Update the total bounty value for this issue
            # TODO
            # Update the total bounty points that can be spend
            # TODO
        error: (jqXHR, textStatus, errorThrown) ->
            $statusCell.empty()
            # Show the error in a flash message
            if errorThrown.search 'Unprocessable Entity' >= 0 \
                    and jqXHR.responseJSON.hasOwnProperty 'value'
                error_message = 'Value ' + jqXHR.responseJSON['value']
            else
                error_message = errorThrown + ': ' + jqXHR.responseText
            addInHtml = '<div class="alert alert-danger fade in">
                <button class="close" data-dismiss="alert">×</button>
                ' + error_message + '</div>'
            $('#flash-messages').prepend(addInHtml)
            $(document).scrollTop(0)
            # Indicate the violating cell
            $parentCell.addClass('danger')
        complete: ->
            # Force convert the input field back to normal text
            $inputDiv.blur()

    return value
