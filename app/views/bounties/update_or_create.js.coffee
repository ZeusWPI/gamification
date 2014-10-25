$('#flash-messages').append '<%= escape_javascript render 'flash', locals: { flash: flash } %>'

console.log('no error occured')
$hiddenField = $('input[type=hidden][name=bounty\\[issue_id\\]][value=<%= @issue.id %>]')
console.log('no error occured')
$textField = $hiddenField.nextAll('input[type=text]')
console.log('no error occured')
$formCell = $hiddenField.parent().parent()
console.log('no error occured')
$totalBountyCell = $formCell.prev()
console.log('no error occured')


<% if flash[:error] %>

# Scroll to error
$(document).scrollTop(0)
# Indicate the violating cell
$formCell.addClass('danger')

<% else %>

# Update the total bounty value
$totalBountyCell.text <%= @issue.total_bounty_value %>
# Update the total bounty points that can be spend
$('#remaining-points').text <%= @new_bounty_residual %>

<% end %>
