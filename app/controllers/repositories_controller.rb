class RepositoriesController < ApplicationController
  def index
  end

  def show
    @repository = Repository.find_by user: params[:user], name: params[:repo]
    @coders = @repository.coders.map { |c| c.accessor.repository @repository }
  end
end
