class BountiesController < ApplicationController
  before_action :authenticate_coder!

  def index
    @issues = Issue.all.sort_by { |issue| [issue.repo, issue.title] }
  end

  def update_or_create
    # Value must be a non-negative integer
    unless params[:value] =~ /^\d+$/
      render json: {value: 'is not an integer'}, status: :bad_request
      return
    end

    # Find the bounty for this issue if it already exists
    @bounty = Bounty.find_by issue_id: params[:issue_id],
                             coder_id: current_coder.id

    # Check whether the user has got enought points to spend
    old_value = @bounty.value || 0
    delta = params[:value].to_i - old_value
    if delta > current_coder.bounty_residual
      render json: {value: 'is too big considering your remaining bounty points'},
             status: :unprocessable_entity
      return
    end

    # Set the new value for an existing bounty or create a new one
    if @bounty.present?
      @bounty.value += delta
    else
      @bounty = Bounty.new issue_id: params[:issue_id],
                           coder_id: current_coder.id,
                           value:    params[:value]
    end

    # Try to save the bounty, update the remaining bounty points, and return
    # some possibly updated records
    if @bounty.save
      current_coder.bounty_residual -= delta
      current_coder.save!
      render json: {
        new_bounty_value: @bounty.value,
        new_remaining_points: current_coder.bounty_residual
      }
    else
      render json: @bounty.errors, status: :unprocessable_entity
    end
  end
end
