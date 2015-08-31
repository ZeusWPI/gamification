module Schwarm
  CommitFisch = Datenfisch.provider Commit do
    stat :additions, col(:additions).sum
    stat :deletions, col(:deletions).sum
    stat :count,     count
    stat :addition_score, (
      ln(col(:additions) + 1) *
      -> { Rails.application.config.addition_score_factor }
    ).round.sum
  end

  BountyFisch = Datenfisch.provider Bounty do
    stat :claimed_value, col(:claimed_value).sum
    stat :absolute_bounty_value, col(:absolute_value).sum

    # rubocop:disable Style/Attr
    attr :repository_id, :repository_id, through: :issue
    attr :coder_id, :claimant_id
    attr :date,     :claimed_at
    # rubocop:enable Style/Attr
  end
end
