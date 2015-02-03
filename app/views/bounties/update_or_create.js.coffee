$('#flash-messages').append '<%= escape_javascript render 'flash', locals: { flash: flash } %>'

$tr = $('tr#issue-<%= @issue.id %>')
$totalBountyCell = $tr.find('.total-bounty')

# Remove previous styling
$tr.removeClass('has-error has-success')
$tr.find('.btn').removeClass('btn-danger btn-success btn-default')

<% if flash[:error] %>

# Scroll to error
$(document).scrollTop(0)
# Indicate the violating cell
$tr.addClass('has-error')
$tr.find('.btn').addClass('btn-danger')

<% else %>

# Update the total bounty value
$totalBountyCell.text <%= @issue.total_bounty_value %>
# Update the total bounty points that can be spend
$('#remaining-points').text <%= current_coder.abs_bounty_residual %>
$tr.addClass('has-success')
$tr.find('.btn').addClass('btn-success')

<% end %>
