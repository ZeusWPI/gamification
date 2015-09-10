class CodersController < ApplicationController
  before_action :set_coder, only: [:show, :commit_history, :claimed_bounties]

  respond_to :json, only: [:commit_history, :claimed_bounties]

  def show
    @repositories = Repository.only_with_stats(
      :score, :commit_count, :additions, :deletions
    ).where(coder_id: @coder).order(score: :desc).run

    @chart = CoderPointsChart.new(@coder).timeline
  end

  def commit_history
    respond_with build_table(HistoryDatatable)
  end

  def claimed_bounties
    respond_with build_table(ClaimedBountyDatatable)
  end

  private

  def set_coder
    @coder = Coder.friendly.find(params[:id])
  end

  def build_table(table)
    table.new( view_context, { coder: @coder } )
  end
end
