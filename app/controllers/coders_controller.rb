class CodersController < ApplicationController
  before_action :set_coder, only: [:show]

  def show
  end

  private
   def set_coder
     @coder = Coder.friendly.find_by_friendly_id params[:id]
   end
end
