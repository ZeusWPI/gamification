module Schwarm

  CommitFisch = Datenfisch.provider Commit do
    stat :additions, additions.sum
    stat :deletions, deletions.sum
    stat :count,     count
    stat :ln_additions, ln(additions+1).round.sum
  end

  BountyFisch = Datenfisch.provider Bounty do
    stat :claimed_value, claimed_value.sum
    stat :bounty_value,  value.sum

    attr :repository_id, :repository_id, through: :issue
    attr :coder_id, :claimant_id
    attr :date,     :claimed_at
  end
end
