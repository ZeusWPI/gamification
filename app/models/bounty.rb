class Bounty < ActiveRecord::Base
  belongs_to :issue
  belongs_to :coder

  validates_presence_of :issue_id
  validates_presence_of :coder_id
  validates_uniqueness_of :issue_id, scope: :coder_id
  validates :value, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def to_s
    value.to_s
  end
end
