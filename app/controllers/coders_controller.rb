class CodersController < ApplicationController
  before_action :set_coder, only: [:show]

  def show
    @coder = current_coder
  end

  private
   def set_coder
     @coder = Coder.friendly.find_by_friendly_id params[:id]
   end
end
