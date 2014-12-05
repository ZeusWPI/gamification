class CoderAccessor
  attr_accessor :commits

  def initialize coder
    @coder = coder
    @commits = coder.commits
  end

  def additions
    commits.additions
  end

  def deletions
    commits.deletions
  end

  # TODO: bounty score
  def total_score
    10 * commits.count + additions
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
