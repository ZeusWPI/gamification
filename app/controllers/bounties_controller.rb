class BountiesController < ApplicationController
  before_action :authenticate_coder!

  def index
    @issues = Issue.all.sort_by { |issue| [issue.repo, issue.title] }
  end

  def update_or_create
    @bounty = Bounty.find_by issue_id: params[:issue_id],
                             coder_id: current_coder.id

    if @bounty.present?
      @bounty.value = params[:value]
    else
      @bounty = Bounty.new issue_id: params[:issue_id],
                           coder_id: current_coder.id,
                           value:    params[:value]
    end

    if @bounty.save
      head :no_content
    else
      render json: @bounty.errors, status: :unprocessable_entity
    end
  end
end
