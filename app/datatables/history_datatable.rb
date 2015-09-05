class HistoryDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    @sortable_columns ||= [
      'Commit.date',
    ]
  end

  def searchable_columns
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [
        record.date,
      ]
    end
  end

  def get_raw_records
    Commit.all
  end
end
