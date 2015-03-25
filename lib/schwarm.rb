module Schwarm

  CommitFisch = Datenfisch.provider Commit do
    stat :additions, sum(:additions)
    stat :deletions, sum(:deletions)
    stat :count, count

    stat :ln_additions,
      Arel::Nodes::SqlLiteral.new("CAST(SUM(LN(additions+1)) AS INT)")
  end

  BountyFisch = Datenfisch.provider Bounty do
    stat :claimed_value, sum(:claimed_value)
    stat :bounty_value, sum(:value)

    attr :repository_id, :repository_id, through: :issue
    attr :coder_id, :claimant_id
    attr :date,     :claimed_at
  end
end
