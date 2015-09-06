class HistoryDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :repository_path
  def_delegator :@view, :format_score

  def sortable_columns
    @sortable_columns ||= [
      'Commit.date',
      'Commit.additions',
      'Repository.name',
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
      'Repository.name',
      'Commit.sha',
    ]
  end

  private

  def data
    records.map do |record|
      [
        record.date.to_formatted_s(:long),
        format_score(record.addition_score),
        link_to(record.repository.name, repository_path(record.repository)),
        link_to(record.sha, record.github_url),
      ]
    end
  end

  def get_raw_records
    options[:coder].commits.eager_load(:repository)
  end
end
