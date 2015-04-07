class Top4Controller < ApplicationController
  include Schwarm
  def show
    @coders = Coder.with_stats(:score)
      .where(date: 1.week.ago..Time.current).order(score: :desc).take(4)

    @top_repos = Datenfisch.query.select(Coder.score)
      .where(date: 1.week.ago..Time.current).model(Repository)
      .order(score: :desc).take(4)

    @repo_contributors = @top_repos.map do |repo|
      Coder.only_with_stats(:score)
        .where(repository: repo, date: 1.week.ago..Time.current)
        .order(score: :desc).run
    end

    @new_issues = Issue.with_stats(:total_bounty_value).includes(:repository)
      .order(opened_at: :desc).take(4)

    @closed_issues = Issue.where.not(closed_at: nil)
      .includes(:repository, :assignee)
      .order(closed_at: :desc).take(4)

    @top_issues = Issue.with_stats(:total_bounty_value).includes(:repository)
      .order(total_bounty_value: :desc).take(4)
  end
end
