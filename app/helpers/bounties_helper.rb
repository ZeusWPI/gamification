module BountiesHelper
  def find_bounty issue, issuer
    bounty = issue.bounties.find_by issuer: issuer
    bounty = issue.bounties.build(value: 0) if not bounty
    bounty
  end

end
