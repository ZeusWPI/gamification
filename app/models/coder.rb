# == Schema Information
#
# Table name: coders
#
#  id              :integer          not null, primary key
#  github_name     :string(255)      not null
#  full_name       :string(255)
#  avatar_url      :string(255)
#  reward_residual :integer          default(0), not null
#  bounty_residual :integer          default(0), not null
#  commits         :integer          default(0), not null
#  additions       :integer          default(0), not null
#  modifications   :integer          default(0), not null
#  deletions       :integer          default(0), not null
#  bounty_score    :integer          default(0), not null
#  other_score     :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#  github_url      :string(255)
#

class Coder < ActiveRecord::Base
  extend FriendlyId
  friendly_id :github_name

  devise :omniauthable, omniauth_providers: [:github]

  has_many :created_issues, inverse_of: :coder
  has_many :assigned_issues, inverse_of: :assignee
  has_many :bounties
  after_save :clear_caches

  # parameters:
  #   loc
  #   bounty
  #   other
  #   reward_bounty_points -> boolean
  def reward hash
    hash.default = 0
    # calculate bounty value
    if hash.key? :bounty  # Do not calculate sum when not needed
      delta_bounty_score = hash[:bounty] / Stats.total_bounty_points *
        [ Application.config.total_bounty_value, Stats.total_bounty_points ].min
    else 
      delta_bounty_score = 0
    end

    other_score += hash[:other]
    bounty_score += delta_bounty_score
    reward_residual += hash[:loc] + hash[:other] + bounty_score
    bounty_residual += hash[:loc] + bounty_score if hash[:reward_bounty_points]
    save!
  end

  def total_score
    10 * commits + additions + bounty_score + other_score
  end

  def self.from_omniauth(auth)
    find_by_github_name(auth.info.nickname)
  end

  def self.find_or_create_by_github_name(github_name)
    coder = find_by_github_name(github_name)
    if coder.nil?
      github = Github.new oauth_token: Rails.application.secrets.github_token
      github_info = github.users.get(user: github_name)
      coder = create github_name: github_name,
                     full_name: github_info.has_key?(:name) ? github_info.name : '',
                     avatar_url: github_info.avatar_url,
                     github_url: github_info.html_url
    end
    coder
  end

  private
    def clear_caches
      Stats.expire_coder_bounty_points
    end
end
