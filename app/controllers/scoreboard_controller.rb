class ScoreboardController < ApplicationController
  def index
    @coders = Datavis.get_stats target: 'coder',
      stats: ['commits', 'additions', 'deletions', 'claimed']
    @coders.sort_by! {|c| Coder::score(c)}.reverse!
  end
end
