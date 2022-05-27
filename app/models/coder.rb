# == Schema Information
#
# Table name: coders
#
#  id                       :integer          not null, primary key
#  github_name              :string(255)      not null
#  full_name                :string(255)      default(""), not null
#  avatar_url               :string(255)      not null
#  github_url               :string(255)      not null
#  reward_residual          :integer          default(0), not null
#  absolute_bounty_residual :integer          default(0), not null
#  other_score              :integer          default(0), not null
#  created_at               :datetime
#  updated_at               :datetime
#

class Coder < ApplicationRecord
  extend FriendlyId
  extend Datenfisch::Model
  friendly_id :github_name

  devise :omniauthable, omniauth_providers: [:github]

  has_many :created_issues, class_name: 'Issue', foreign_key: 'issuer_id'
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'
  has_many :claimed_bounties, class_name: 'Bounty', foreign_key: 'claimant_id'
  has_many :bounties
  has_many :commits

  after_commit :clear_caches
  after_rollback :clear_caches

  include Schwarm
  stat :additions, CommitFisch.additions
  stat :deletions, CommitFisch.deletions
  stat :commit_count, CommitFisch.count
  stat :changed_lines, additions + deletions
  stat :claimed_value, BountyFisch.claimed_value
  stat :addition_score, CommitFisch.addition_score
  stat :score, addition_score + claimed_value

  def reward_bounty!(bounty)
    self.bounty_residual += bounty.value
    self.reward_residual += bounty.value
    save!
  end

  def refund_bounty!(bounty)
    self.bounty_residual += bounty.value
    save!
  end

  def reward_commit!(commit)
    addition_score = commit.addition_score
    self.reward_residual += addition_score
    self.bounty_residual += addition_score
    save!
  end

  def bounty_residual
    BountyPoints.bounty_points_from_abs(absolute_bounty_residual)
  end

  def bounty_residual=(new_value)
    self.absolute_bounty_residual =
      BountyPoints.bounty_points_to_abs(new_value)
  end

  def self.from_omniauth(auth)
    find_by_github_name(auth.info.nickname)
  end

  def self.find_or_create_by_github_name(name)
    name.gsub!(/\[bot\]$/,'')
    Coder.find_or_create_by(github_name: name) do |coder|
      # Fetch data from github
      data = Rails.configuration.x.github.users.get(user: name)
      coder.full_name = data.try(:name) || ''
      coder.avatar_url = data.avatar_url
      coder.github_url = data.html_url
    end
  end

  private

  def clear_caches
    BountyPoints.expire_coder_bounty_points
  end
end
