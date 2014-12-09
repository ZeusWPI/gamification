module BountiesHelper
  def find_bounty issue, issuer
    bounty = issue.bounties.find_by issuer: issuer
    issue.bounties.build(value: 0) if not bounty
  end

end
