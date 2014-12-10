class ScoreboardController < ApplicationController
  def index
    @coders = Coder.all
    render_scoreboard 'scoreboard'
  end

  def by_year
    datestring = params[:year]
    year = DateTime.new(datestring.to_i).all_year
    render_scoreboard_by_date datestring, year
  end

  def by_month
    datestring = params.values_at(:month, :year).join(' ')
    month = DateTime.parse(datestring).all_month
    render_scoreboard_by_date datestring, month
  end

  private
  def render_scoreboard_by_date datestring, date
    @coders = Coder.all.map { |c| c.accessor.date date }
    render_scoreboard "Scoreboard - #{datestring}"
  end

  def render_scoreboard title
    render 'scoreboard', locals: { title: title }
  end
end
