class Stats

  def self.total_bounty_points
    coder_bounty_points + issue_bounty_points
  end

  def self.coder_bounty_points
    Rails.cache.fetch('stats_coder_bounty_points') { Coder.sum(:bounty_residual) }
  end

  def self.issue_bounty_points
    Rails.cache.fetch('stats_issue_bounty_points') { Issue.sum(:value) }
  end

  def self.expire_issue_bounty_points
    Rails.cache.delete('stats_issue_bointy_points')
  end

  def self.expire_coder_bounty_points
    Rails.cache.delete('stats_coder_bounty_points')
  end

end
