module BountyPoints
  def self.bounty_points_from_abs value
    value * total_bounty_points / [
      Rails.application.config.total_bounty_value,
      total_bounty_points ].min
  end

  def self.bounty_points_to_abs value
    value * [ Rails.application.config.total_bounty_value,
              total_bounty_points ].min / total_bounty_points
  end

  def self.total_bounty_points
    coder_bounty_points + assigned_bounty_points
  end

  def self.coder_bounty_points
    Rails.cache.fetch('stats_coder_bounty_points') { Coder.sum(:bounty_residual) }
  end

  def self.assigned_bounty_points
    Rails.cache.fetch('stats_assigned_bounty_points') { Bounty.sum(:value) }
  end

  def self.expire_assigned_bounty_points
    Rails.cache.delete('stats_assigned_bounty_points')
  end

  def self.expire_coder_bounty_points
    Rails.cache.delete('stats_coder_bounty_points')
  end
end
