class RepositoriesController < ApplicationController
  def index
    @repositories = Repository
                    .with_stats(:score, :commit_count, :additions, :deletions)
                    .order(score: :desc).run
  end

  def show
    @repository = Repository.friendly.find params[:id]
    @coders = Coder.only_with_stats(:score, :commit_count, :additions, :deletions)
              .where(repository: @repository).order(score: :desc).run
    @chart = AnnotationChart.burndown_chart(@repository.issues)
  end
end
