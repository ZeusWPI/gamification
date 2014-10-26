$('#flash-messages').append '<%= escape_javascript render 'flash', locals: { flash: flash } %>'

$hiddenField = $('input[type=hidden][name=bounty\\[issue_id\\]][value=<%= @issue.id %>]')
$textField = $hiddenField.nextAll('input[type=text]')
$formCell = $hiddenField.parent().parent()
$totalBountyCell = $formCell.prev()


<% if flash[:error] %>

# Scroll to error
$(document).scrollTop(0)
# Indicate the violating cell
$formCell.addClass('danger')

<% else %>

# Update the total bounty value
$totalBountyCell.text <%= @issue.total_bounty_value %>
# Update the total bounty points that can be spend
$('#remaining-points').text <%= current_coder.abs_bounty_residual %>
$formCell.addClass('success')

<% end %>
