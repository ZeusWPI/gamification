module BountiesHelper
  def find_bounty(issue, issuer)
    bounty = issue.unclaimed_bounties.find { |b| b.issuer == issuer }
    bounty = issue.bounties.build(value: 0) unless bounty
    bounty
  end
end
