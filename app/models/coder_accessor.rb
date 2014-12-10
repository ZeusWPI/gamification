class CoderAccessor
  attr_accessor :commits, :claimed_bounties

  def initialize coder
    @coder = coder
    @commits = coder.commits
    @claimed_bounties = coder.claimed_bounties
  end

  def additions
    commits.additions
  end

  def deletions
    commits.deletions
  end

  def total_score
    10 * commits.count + additions + claimed_bounties.claimed_value
  end

  # limit date scope
  def date date
    @commits = commits.where date: date
    @claimed_bounties = claimed_bounties.where claimed_at: date
    self
  end

  # limit repository scope
  def repository repo
    @commits = commits.where repository: repo
    @claimed_bounties = claimed_bounties.joins(:issue).where issues: { repository_id: repo }
    self
  end

  # Delegate other methods to coder object
  def method_missing(m, *args, &block)
    @coder.send(m, *args, &block)
  end

  def respond_to?(method, include_private = false)
    super || @coder.respond_to?(method, include_private)
  end

  def self.method_missing(m, *args, &block)
    Coder.send(m, *args, &block)
  end

  def self.respond_to?(method, include_private = false)
    super || Coder.respond_to?(method, include_private)
  end
end
