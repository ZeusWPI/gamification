# == Schema Information
#
# Table name: bounties
#
#  id            :integer          not null, primary key
#  value         :integer          not null
#  issue_id      :integer          not null
#  issuer_id     :integer          not null
#  claimant_id   :integer
#  claimed_value :integer
#  claimed_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Bounty < ActiveRecord::Base
  belongs_to :issue
  has_one :repository, through: :issue
  belongs_to :issuer, class_name: 'Coder', foreign_key: 'issuer_id'
  belongs_to :claimant, class_name: 'Coder', foreign_key: 'claimant_id'

  validates_presence_of :issue
  validates_presence_of :issuer
  validates_uniqueness_of :issue, scope: :issuer
  validates :value, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  after_save :expire_caches

  scope :claimed_value, -> { sum :claimed_value }

  def to_s
    value.to_s
  end

  def claim time: Time.now
    return if claimed_at # This bounty has already been claimed
    if issue.assignee && issue.assignee != issuer
      # Reward assignee
      issue.assignee.reward_bounty self, time: time
      issue.assignee.save!
    else
      # refund bounty points
      issuer.bounty_residual += value
      issuer.save!
      # This bounty is of no use; destroy it.
      destroy
    end
  end

  def absolute_value
    claimed_value || BountyPoints::bounty_points_to_abs(value)
  end

  def pinpoint_value coder: nil, time: Time.current
    self.claimant = coder
    self.claimed_at = time
    self.claimed_value = absolute_value
    self.value = 0
    save!
  end

  private
    def expire_caches
      BountyPoints::expire_assigned_bounty_points
    end
end
