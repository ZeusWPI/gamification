class Coder < ActiveRecord::Base
  extend FriendlyId
  friendly_id :github_name

  devise :omniauthable, omniauth_providers: [:github]

  def total_score
    10 * commits + additions + modifications + bounty_score + other_score
  end

  def self.from_omniauth(auth)
    find_by_github_name(auth.info.nickname)
  end
end
