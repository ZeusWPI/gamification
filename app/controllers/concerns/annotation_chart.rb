module AnnotationChart
  def self.burndown_chart(issues)
    # Get open and closed issues
    open_issues = issues.group('DATE(opened_at)').count
    closed_issues = issues.closed.group('DATE(closed_at)').count

    # Get the full range
    start_date = Time.zone.now.to_date
    unless issues.order(:number).first.nil?
      start_date = issues.order(:number).first.opened_at.to_date
    end
    daterange =  start_date .. Time.zone.now.to_date

    data = []
    open = 0
    daterange.each do |d|
      open += (open_issues[d] || 0) - (closed_issues[d] || 0)
      data << [d, open_issues[d] || 0, closed_issues[d] || 0, open]
    end

    data_table = GoogleVisualr::DataTable.new

    # Add Column Headers
    data_table.new_column('date', 'Date' )
    data_table.new_column('number', 'New issues')
    data_table.new_column('number', 'Closed issues')
    data_table.new_column('number', 'Open issues')

    # Add Rows and Values
    data_table.add_rows(data)

    option = {
      width: 1000,
      height: 440,
      colors: ['orange', 'green', 'blue'],
    }

    GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, option)
  end
end
