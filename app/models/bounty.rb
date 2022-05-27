# == Schema Information
#
# Table name: bounties
#
#  id             :integer          not null, primary key
#  absolute_value :integer          not null
#  issue_id       :integer          not null
#  issuer_id      :integer          not null
#  claimant_id    :integer
#  claimed_value  :integer
#  claimed_at     :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class Bounty < ApplicationRecord
  belongs_to :issue
  has_one :repository, through: :issue
  belongs_to :issuer, class_name: 'Coder', foreign_key: 'issuer_id'
  belongs_to :claimant, class_name: 'Coder', foreign_key: 'claimant_id'

  validates :issue, presence: true
  validates :issuer, presence: true
  validates :absolute_value, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  after_commit :clear_caches
  after_rollback :clear_caches
  after_save :destroy, if: ->(b){ b.absolute_value == 0 && b.claimed_value.nil? }

  delegate :to_s, to: :value

  def self.update_or_create(issue, coder, new_value)
    # Find the bounty for this issue if it already exists
    # We don't want to directly create it with value == 0 or else the
    # destroy callback will be called
    bounty = Bounty.find_or_initialize_by(issue: issue,
                                          issuer: coder,
                                          claimed_at: nil)

    if bounty.new_record? && new_value.zero?
      fail Error, "You can't create an empty bounty."
    end

    bounty.absolute_value = 0
    bounty.update_value!(new_value)
  end

  def update_value!(new_value)
    # Check whether the user has got enought points to spend
    delta = new_value - value
    if delta > issuer.bounty_residual
      fail Error, "You don\'t have enough bounty points to put a bounty of"\
                  ' this amount.'
    end

    self.value += delta

    issuer.bounty_residual -= delta

    # Try to save the bounty, update the remaining bounty points, and return
    # some possibly updated records
    # It is important that this happens at the same time, so
    # BountyPoints.total_bounty_points stays the same!
    transaction do
      unless save
        fail Error, 'There occured an error while trying to save your bounty'\
                    " (#{bounty.errors.full_messages})"
      end

      unless issuer.save
        fail Error, 'There occured an error while trying to adjust your'\
                    ' remaining bounty points'\
                    " (#{bounty.errors.full_messages})"
      end
    end

    PublishBounty.new(self).call
  end

  def claim!(time: Time.zone.now)
    return if claimed_at  # This bounty has already been claimed
    if issue.assignee && issue.assignee != issuer
      # Reward assignee
      pinpoint_value!(coder: issue.assignee, time: time)
      issue.assignee.reward_bounty!(self)
    else
      # Refund bounty points
      issuer.refund_bounty!(self)
      # This bounty is of no use; destroy it.
      destroy!
    end
  end

  def value
    claimed_value || BountyPoints.bounty_points_from_abs(absolute_value)
  end

  def value=(new_value)
    if claimed_at
      fail Error, 'Trying to set a new value to an already claimed bounty!'
    end
    self.absolute_value = BountyPoints.bounty_points_to_abs(new_value)
  end

  def pinpoint_value!(coder: nil, time: Time.current)
    self.claimant = coder
    self.claimed_at = time
    self.claimed_value = self.value
    self.absolute_value = 0
    save!
  end

  class Error < StandardError
  end

  private

  def clear_caches
    BountyPoints.expire_assigned_bounty_points
  end
end
