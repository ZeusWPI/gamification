class Coder < ActiveRecord::Base
  extend FriendlyId
  friendly_id :github_name

  devise :omniauthable, omniauth_providers: [:github]

  has_many :created_issues, inverse_of: :coder
  has_many :assigned_issues, inverse_of: :assignee
  has_many :bounties

  def total_score
    10 * commits + additions + modifications + bounty_score + other_score
  end

  def self.from_omniauth(auth)
    find_by_github_name(auth.info.nickname)
  end

  def self.find_or_create_by_github_name(github_name)
    coder = find_by_github_name(github_name)
    if coder.nil?
      github = Github.new oauth_token: Rails.application.secrets.github_token
      github_info = github.users.get(user: github_name)
      coder = create(github_name: github_name,
                     full_name: github_info.has_key?(:name) ? github_info.name : '',
                     reward_residual: 0,
                     bounty_residual: 0,
                     avatar_url: github_info.avatar_url,
                     github_url: github_info.html_url,
                     commits: 0,
                     additions: 0,
                     modifications: 0,
                     deletions: 0,
                     bounty_score: 0,
                     other_score: 0)
    end
    coder
  end
end
