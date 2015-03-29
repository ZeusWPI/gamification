class ScoreboardController < ApplicationController
  def index
    @coders = Coder.with_stats(:additions, :deletions, :commit_count, :score)
      .order(:score => :desc).to_a
  end
end
