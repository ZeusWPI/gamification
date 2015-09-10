class BurndownChart
  def initialize(issues)
    @issues = issues
  end

  def timeline
    option = {
      width: 900,
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
    data_table.new_column('number', 'Open issues')
    data_table.new_column('number', 'New issues')
    data_table.new_column('number', 'Closed issues')

    data_table.add_rows(data)

    data_table
  end

  def full_date_range
    start_date = @issues.order(:number).first.try(:opened_at) || Time.zone.now

    start_date.to_date..Time.zone.now.to_date
  end

  def data
    open_issues = @issues.group('DATE(opened_at)').count
    closed_issues = @issues.closed.group('DATE(closed_at)').count

    data = []
    open = 0
    full_date_range.each do |d|
      open += (open_issues[d] || 0) - (closed_issues[d] || 0)
      data << [d, open, open_issues[d] || 0, closed_issues[d] || 0]
    end

    data
  end
end
