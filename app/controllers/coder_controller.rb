class CoderController < ApplicationController
  before_action :authenticate_coder!
  before_action :set_coder, only: [:show]

  def index
    redirect_to scoreboard_index_path
  end

  def show
  end

  private
   def set_coder
     @coder = Coder.friendly.find(params[:id])
   end
end
