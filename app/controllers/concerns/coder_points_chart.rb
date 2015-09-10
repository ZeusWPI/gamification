class CoderPointsChart
  def initialize(coder)
    @coder = coder
  end

  def timeline
    option = {
      width: '900',
      height: 440,
      colors: %w(blue orange green),
      displayAnnotations: false,
    }

    GoogleVisualr::Interactive::AnnotationChart.new(data_table, option)
  end

  private

  def data_table
    data_table = GoogleVisualr::DataTable.new

    data_table.new_column('date', 'Date')
    data_table.new_column('number', 'Total points')
    data_table.new_column('number', 'Commit score')
    data_table.new_column('number', 'Bounty score')

    data_table.add_rows(data)

    data_table
  end

  def full_date_range
    start_date = @coder.commits.order(:date).first.try(:date) || Time.zone.now

    start_date.to_date..Time.zone.now.to_date
  end

  def data
    daily_claimed_bounty_score = @coder.claimed_bounties.group('DATE(claimed_at)').sum(:claimed_value)
    daily_commit_score = @coder.commits.group(:date).sum("FLOOR(LN(additions+1)*#{Rails.application.config.addition_score_factor})")

    data = []
    total = 0
    full_date_range.each do |d|
      total += (daily_commit_score[d] || 0)
      total += (daily_claimed_bounty_score[d] || 0)
      data << [d, total, daily_commit_score[d] || 0, daily_claimed_bounty_score[d] || 0]
    end

    data
  end
end
