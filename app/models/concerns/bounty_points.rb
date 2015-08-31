module BountyPoints
  def self.bounty_points_from_abs(value)
    (value * bounty_factor).round
  end

  def self.bounty_points_to_abs(value)
    (value / bounty_factor).round
  end

  def self.bounty_factor
    if total_bounty_points < Rails.application.config.total_bounty_value
      1
    else
      Rails.application.config.total_bounty_value.to_f / total_bounty_points
    end
  end

  def self.total_bounty_points
    coder_bounty_points + assigned_bounty_points
  end

  def self.coder_bounty_points
    Rails.cache.fetch('stats_coder_bounty_points') do
      Coder.sum(:absolute_bounty_residual)
    end
  end

  def self.assigned_bounty_points
    Rails.cache.fetch('stats_assigned_bounty_points') do
      Bounty.sum(:absolute_value)
    end
  end

  def self.expire_assigned_bounty_points
    Rails.cache.delete('stats_assigned_bounty_points')
  end

  def self.expire_coder_bounty_points
    Rails.cache.delete('stats_coder_bounty_points')
  end
end
