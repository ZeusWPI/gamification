class CodersController < ApplicationController
  before_action :set_coder, only: [:show]

  def show
    @repositories = Datenfisch.query
      .select(Coder.score,
              Coder.commit_count,
              Coder.additions,
              Coder.deletions)
      .model(Repository, inner_join: true)
      .where(coder_id: @coder)
      .order(score: :desc).run
  end

  private
  def set_coder
    @coder = Coder.friendly.find params[:id]
  end
end
