class CodersController < ApplicationController
  before_action :set_coder, only: [:show]

  def index
    @coders = Coder.all.sort_by { |coder| - coder.total_score }
  end

  def show
    @coder = current_coder
  end

  private
   def set_coder
     @coder = Coder.friendly.find_by_friendly_id params[:id]
   end
end
