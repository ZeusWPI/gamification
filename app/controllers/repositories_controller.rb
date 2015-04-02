class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.friendly.find params[:id]
    @coders = Coder.only_with_stats(:score, :commit_count, :additions, :deletions)
      .where(repository: @repository).order(score: :desc).run
  end
end
