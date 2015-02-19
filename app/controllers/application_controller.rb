class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  Datavis = Datenfisch::collector do
    target 'coder'
    target 'repository'
    target 'month' do
      group_by { |a| a.date.try(&:month) }
    end

    provider Commit do
      attribute 'repo_name', 'name', through: :repository
      stat 'commits'    do |cs| cs.count end
      #stat 'comimts', count
      #stat 'deletions', sum(:deletions)
      stat 'additions'  do |cs| cs.map(&:additions).sum end
      stat 'deletions'  do |cs| cs.map(&:deletions).sum end
    end

    provider Bounty do
      attribute 'repo_name', 'name', through: :repository

      attribute :date, :claimed_at
      attribute :coder_id, :claimant_id
      attribute :repository_id, through: :issue

      stat 'claimed' do |bs| bs.map(&:claimed_value).sum end
    end
    stat 'changed', ['additions', 'deletions'] do additions + deletions end

    stat 'score', ['changed', 'commits'] do changed + 10 * commits end
  end

end
