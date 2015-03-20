class Top4Controller < ApplicationController
  include Schwarm
  def show
    @coders = Coder.with_stats(:score)
      .where(date: 1.week.ago..Time.current).order(:score).take(4)

    @repositories = Datenfisch.query.select(Coder.score)
      .where(date: 1.week.ago..Time.current).model(Repository)
      .order(score: :desc).take(4)

    @new_issues = Issue.order(opened_at: :desc).take(4)
    @closed_issues = Issue.order(closed_at: :desc).take(4)

    value = (BountyFisch.bounty_value * BountyPoints.bounty_factor).as 'value'
    @top_issues = Datenfisch.query.select(value).model(Issue).order(value: :desc).take(4)
  end
end
