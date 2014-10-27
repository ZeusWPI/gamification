# == Schema Information
#
# Table name: bounties
#
#  id         :integer          not null, primary key
#  value      :integer          not null
#  issue_id   :integer          not null
#  coder_id   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

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
  after_save :expire_caches

  def to_s
    value.to_s
  end

  def cash_in
    assignee = issue.assignee
    if assignee && assignee != coder
      assignee.reward bounty: absolute_value
      assignee.save!
    else
      # refund bounty points
      coder.bounty_residual += value
      coder.save!
    end
    destroy
  end

  def absolute_value
    BountyPoints::bounty_points_to_abs value
  end

  private
    def expire_caches
      BountyPoints::expire_assigned_bounty_points
    end
end
