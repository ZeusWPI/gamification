class CodersController < ApplicationController
  before_action :set_coder, only: [:show]

  def show
    @repositories = Repository.only_with_stats(
      :score, :commit_count, :additions, :deletions
    ).where(coder_id: @coder).order(score: :desc).run
  end

  def history
    respond_to do |format|
      format.html
      format.json { render json: HistoryDatatable.new(view_context) }
    end
  end

  private

  def set_coder
    @coder = Coder.friendly.find params[:id]
  end
end
