class RepositoriesController < ApplicationController
  def index
    @repositories = Repository
      .with_stats(:score, :commit_count, :additions, :deletions)
      .order(score: :desc).run
  end

  def show
    @repository = Repository.friendly.find params[:id]
    @coders = Coder.only_with_stats(:score, :commit_count, :additions, :deletions)
      .where(repository: @repository).order(score: :desc).run

    # Get open issues
    open_issues = @repository.issues.group('DATE(opened_at)').count
    closed_issues = @repository.issues.closed.group('DATE(closed_at)').count

    # Get the full range
    start_date = Time.zone.now.to_date
    unless @repository.issues
      start_date = @repository.issues.first.opened_at.to_date
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
    @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, option)
  end
end
