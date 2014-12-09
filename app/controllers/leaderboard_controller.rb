class LeaderboardController < ApplicationController
  def index
    @coders = Coder.all.sort_by { |coder| -coder.total_score }
    render_leaderboard 'Scoreboard'
  end

  def by_year
    datestring = params[:year]
    year = DateTime.new(datestring.to_i).all_year
    render_leaderboard_by_date datestring, year
  end

  def by_month
    datestring = params.values_at(:month, :year).join(' ')
    month = DateTime.parse(datestring).all_month
    render_leaderboard_by_date datestring, month
  end

  private
  def render_leaderboard_by_date datestring, date
    @coders = Coder.all.map { |c| c.accessor.date date }
    @coders.sort_by { |coder| -coder.total_score }
    render_leaderboard "Scoreboard - #{datestring}"
  end

  def render_leaderboard title
    render 'leaderboard', locals: { title: title }
  end
end
