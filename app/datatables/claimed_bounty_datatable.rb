class ClaimedBountyDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    @sortable_columns ||= [
      'Bounty.claimed_at',
      'Bounty.claimed_value',
    ]
  end

  def searchable_columns
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [
        record.claimed_at,
        record.claimed_value,
      ]
    end
  end

  def get_raw_records
    options[:coder].claimed_bounties
  end

end
