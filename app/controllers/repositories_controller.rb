class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  def index
  end

  def show
    @coders = @repository.coders.map { |c| c.accessor.repository @repository }
  end

  private
  def set_repository
    @repository = Repository.joins(:organisation)
      .find_by  organisations:  { name: params[:organisation] },
                repositories:   { name: params[:repository] }
  end
end
