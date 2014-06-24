class ScoreboardController < ApplicationController
  def index
    @scores = Score.all
  end
end
