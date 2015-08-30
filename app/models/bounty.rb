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

  validates :issue, presence: true
  validates :issuer, presence: true
  validates :value, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  after_save :expire_caches

  delegate :to_s, to: :value

  def self.update_or_create(issue, coder, new_abs_value)
    # Find the bounty for this issue if it already exists, or make a new one
    bounty = Bounty.find_or_create_by issue: issue,
                                      issuer: coder,
                                      claimed_at: nil do |b|
      b.value = 0
    end

    bounty.update!(coder, new_abs_value)
  end

  def update!(coder, new_abs_value)
    new_value = BountyPoints.bounty_points_from_abs new_abs_value

    # Check whether the user has got enought points to spend
    delta = new_value - value
    if delta > coder.bounty_residual
      raise Error.new("You don\'t have enough bounty points to put a"\
                          " bounty of this amount.")
    end

    # Increase value
    value += delta

    # Try to save the bounty, update the remaining bounty points, and return
    # some possibly updated records
    unless save
      raise Error.new("There occured an error while trying to save your"\
                          " bounty (#{bounty.errors.full_messages})")
    end

    coder.bounty_residual -= delta
    coder.save!

    SlackWebhook.publish_bounty(bounty)
  end

  def claim(time: Time.zone.now)
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
    claimed_value || BountyPoints.bounty_points_to_abs(value)
  end

  def pinpoint_value(coder: nil, time: Time.current)
    self.claimant = coder
    self.claimed_at = time
    self.claimed_value = absolute_value
    self.value = 0
    save!
  end

  class Error < StandardError
  end

  private

  def expire_caches
    BountyPoints.expire_assigned_bounty_points
  end
end
