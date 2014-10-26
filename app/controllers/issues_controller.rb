class IssuesController < ApplicationController
  def show
    @issue = Issue.find(params[:id])
  end

  def index
  end
end
