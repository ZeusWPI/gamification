# == Schema Information
#
# Table name: coders
#
#  id              :integer          not null, primary key
#  github_name     :string(255)      not null
#  full_name       :string(255)      default(""), not null
#  avatar_url      :string(255)      not null
#  github_url      :string(255)      not null
#  reward_residual :integer          default(0), not null
#  bounty_residual :integer          default(0), not null
#  other_score     :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Coder < ActiveRecord::Base
  extend FriendlyId
  extend Datenfisch::Model
  friendly_id :github_name

  devise :omniauthable, omniauth_providers: [:github]

  has_many :created_issues, class_name: 'Issue', foreign_key: 'issuer_id'
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'
  has_many :claimed_bounties, class_name: 'Bounty', foreign_key: 'claimant_id'
  has_many :bounties
  has_many :commits
  after_save :clear_caches

  include Schwarm
  stat :additions, CommitFisch.additions
  stat :deletions, CommitFisch.deletions
  stat :commit_count, CommitFisch.count
  stat :changed_lines, additions + deletions
  stat :claimed_value, BountyFisch.claimed_value
  stat :addition_score, CommitFisch.addition_score
  stat :score, addition_score + claimed_value

  # Bounty points should not be rescaled yet.
  def reward_bounty(bounty, time: Time.current)
    self.bounty_residual += bounty.value
    bounty.pinpoint_value coder: self, time: time
    self.reward_residual += bounty.claimed_value
    save!
  end

  def reward_commit(commit)
    addition_score = (Math.log(commit.additions + 1) *
      Rails.application.config.addition_score_factor).round
    self.reward_residual += addition_score
    self.bounty_residual += addition_score
    save!
  end

  def abs_bounty_residual
    BountyPoints.bounty_points_to_abs bounty_residual
  end

  def self.from_omniauth(auth)
    find_by_github_name(auth.info.nickname)
  end

  def self.find_or_create_by_github_name(name)
    Coder.find_or_create_by(github_name: name) do |coder|
      # Fetch data from github
      data = $github.users.get(user: name)
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
