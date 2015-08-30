# == Schema Information
#
# Table name: commits
#
#  id            :integer          not null, primary key
#  coder_id      :integer
#  repository_id :integer
#  sha           :string(255)      not null
#  additions     :integer          default(0), not null
#  deletions     :integer          default(0), not null
#  date          :datetime         not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Commit < ActiveRecord::Base
  belongs_to :coder
  belongs_to :repository

  require 'rugged'

  scope :additions, -> { sum :additions }
  scope :deletions, -> { sum :deletions }

  def reward!
    coder.reward_commit! self
  end

  def self.register_from_sha(repo, sha, **opts)
    r_commit = repo.rugged_repo.lookup sha
    register_rugged repo, r_commit, **opts
  end

  def self.register_rugged(repo, r_commit, reward: true)
    # if committer can't be determined, fuck this shit
    committer = get_committer repo, r_commit
    return nil unless committer
    Commit.find_or_create_by repository: repo,
                             sha: r_commit.oid,
                             coder: committer do |commit|
      commit.date = r_commit.time
      commit.set_stats r_commit
      commit.reward! if reward
    end
  end

  # should be private
  def set_stats(r_commit)
    if r_commit.parents.size >= 2
      # Do not reward merges
      self.additions = self.deletions = 0
    else
      if r_commit.parents.empty?
        # First commit
        diff = r_commit.diff
      else
        diff = r_commit.diff r_commit.parents.first
      end
      self.additions = diff.stat[2]
      self.deletions = diff.stat[1]
    end
  end

  def self.get_committer(repo, r_commit)
    identity = GitIdentity.find_by name: r_commit.committer[:name],
                                   email: r_commit.committer[:email]
    unless identity
      coder = get_committer_from_github repo, r_commit
      return nil unless coder
      identity = GitIdentity.create name:  r_commit.committer[:name],
                                    email: r_commit.committer[:email],
                                    coder: coder
    end
    identity.coder
  end

  def self.get_committer_from_github(repo, r_commit)
    commit = $github.repos.commits.get Rails.application.config.organisation,
                                       repo.name, r_commit.oid
    if commit.committer
      Coder.find_or_create_by_github_name commit.committer.login
    end
  end
end
