class ClaimedBountyDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :repository_path
  def_delegator :@view, :format_score

  def sortable_columns
    @sortable_columns ||= [
      'Bounty.claimed_at',
      'Bounty.claimed_value',
      'Repository.name',
      'Issue.title',
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
      'Issue.title',
      'Issue.number',
      'Repository.name',
    ]
  end

  private

  def data
    records.map do |record|
      [
        record.claimed_at.to_formatted_s(:long),
        format_score(record.claimed_value),
        link_to(record.repository.name, repository_path(record.repository)),
        link_to("#{record.issue.title} (##{record.issue.number})", record.issue.github_url),
      ]
    end
  end

  def get_raw_records
    options[:coder].claimed_bounties.eager_load(:issue).eager_load(:repository)
  end

end
