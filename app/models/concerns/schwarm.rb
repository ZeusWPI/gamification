module Schwarm

  CommitFisch = Datenfisch.provider Commit do
    stat :additions, col(:additions).sum
    stat :deletions, col(:deletions).sum
    stat :count,     count
    stat :ln_additions, ln(col(:additions)+1).round.sum
  end

  BountyFisch = Datenfisch.provider Bounty do
    stat :claimed_value, col(:claimed_value).sum
    stat :bounty_value,  col(:value).sum

    attr :repository_id, :repository_id, through: :issue
    attr :coder_id, :claimant_id
    attr :date,     :claimed_at
  end
end
