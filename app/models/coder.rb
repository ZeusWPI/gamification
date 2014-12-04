# == Schema Information
#
# Table name: coders
#
#  id              :integer          not null, primary key
#  github_name     :string(255)      not null
#  full_name       :string(255)      not null
#  avatar_url      :string(255)      not null
#  github_url      :string(255)      not null
#  reward_residual :integer          default(0), not null
#  bounty_residual :integer          default(0), not null
#  bounty_score    :integer          default(0), not null
#  other_score     :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Coder < ActiveRecord::Base
  extend FriendlyId
  friendly_id :github_name

  devise :omniauthable, omniauth_providers: [:github]

  has_many :created_issues, inverse_of: :issuer
  has_many :assigned_issues, inverse_of: :assignee
  has_many :bounties
  has_many :commits
  after_save :clear_caches

  def reward loc: 0, bounty: 0, other: 0, options: {}
    self.other_score += other
    self.bounty_score += bounty
    self.reward_residual += loc + other + bounty
    if options.fetch(:reward_bounty_points, true)
      self.bounty_residual += loc + bounty 
    end
  end

  def additions
    commits.sum(:additions)
  end

  def deletions
    commits.sum(:deletions)
  end

  def total_score
    10 * commits.count + additions + bounty_score + other_score
  end

  def abs_bounty_residual
    BountyPoints::bounty_points_to_abs bounty_residual
  end

  def self.from_omniauth(auth)
    find_by_github_name(auth.info.nickname)
  end

  def self.find_or_create_by_github_name(name)
    Coder.find_or_create_by(github_name: name) do |coder|
      # Fetch data from github
      data = $github.users.get(user: name)
      coder.full_name = data.name || ''
      coder.avatar_url = data.avatar_url
      coder.github_url = data.html_url
    end
  end

  private
    def clear_caches
      BountyPoints::expire_coder_bounty_points
    end
end
