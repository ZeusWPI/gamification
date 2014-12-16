class BountiesController < ApplicationController
  before_action :authenticate_coder!

  respond_to :html, :coffee

  def index
    @issues = Issue.where(closed_at: nil).sort_by do |issue|
      [issue.repository.name, issue.title]
    end
  end

  # Todo split this
  def update_or_create
    issue_id = bounty_params[:issue_id]
    new_abs_value = bounty_params[:absolute_value]

    @issue = Issue.find issue_id
    # Value must be a non-negative integer
    unless new_abs_value =~ /^\d+$/
      flash.now[:error] = 'This value is not an integer.'
      return
    end

    new_value = BountyPoints::bounty_points_from_abs new_abs_value.to_i

    # Find the bounty for this issue if it already exists
    @bounty = Bounty.find_or_create_by  issue_id: issue_id,
                                        issuer: current_coder do |b|
                                          b.value = 0
                                        end

    # Check whether the user has got enought points to spend
    delta = new_value - @bounty.value
    if delta > current_coder.bounty_residual
      flash.now[:error] = 'You don\'t have enough bounty points to put a'\
                          ' bounty of this amount.'
      return
    end

    # Increase value
    @bounty.value += delta

    # Try to save the bounty, update the remaining bounty points, and return
    # some possibly updated records
    if @bounty.save
      current_coder.bounty_residual -= delta
      current_coder.save!
    else
      flash.now[:error] = "There occured an error while trying to save your"\
                          " bounty (#{@bounty.errors.full_messages})"
    end
  end

  private
    def bounty_params
      params.require(:bounty).permit(:issue_id, :absolute_value)
    end
end
