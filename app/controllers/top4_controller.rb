class Top4Controller < ApplicationController
  def show
    @coders = Coder.with_stats(:score).order(:score).take(4)
    @repositories = Datenfisch.query.
      select(Coder.score).model(Repository).order(:score).take(4)
    @new_issues = Issue.order(opened_at: :desc).take(4)
  end
end
