class ScoreboardController < ApplicationController
  def index
    @coders = Coder.all.sort_by { |coder| - coder.total_score }
  end
end
