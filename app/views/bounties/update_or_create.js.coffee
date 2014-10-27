$('#flash-messages').append '<%= escape_javascript render 'flash', locals: { flash: flash } %>'

$hiddenField = $('input[type=hidden][name=bounty\\[issue_id\\]][value=<%= @issue.id %>]')
$textField = $hiddenField.nextAll('input[type=text]')
$formCell = $hiddenField.parent().parent()
$totalBountyCell = $formCell.prev()

# Remove previous styling
$formCell.removeClass('has-error has-success')
$formCell.find('.btn').removeClass('btn-danger btn-success btn-default')

<% if flash[:error] %>

# Scroll to error
$(document).scrollTop(0)
# Indicate the violating cell
$formCell.addClass('has-error')
$formCell.find('.btn').addClass('btn-danger')

<% else %>

# Update the total bounty value
$totalBountyCell.text <%= @issue.total_bounty_value %>
# Update the total bounty points that can be spend
$('#remaining-points').text <%= current_coder.abs_bounty_residual %>
$formCell.addClass('has-success')
$formCell.find('.btn').addClass('btn-success')

<% end %>
