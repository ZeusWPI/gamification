class CodersController < ApplicationController
  before_action :set_coder, only: [:show]

  def index
    @coders = Coder.all.sort_by { |coder| - coder.total_score }
  end

  def show
  end

  private
   def set_coder
     @coder = Coder.friendly.find(params[:id])
   end
end
