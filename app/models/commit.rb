# == Schema Information
#
# Table name: commits
#
#  id            :integer          not null, primary key
#  coder_id      :integer
#  repository_id :integer
#  sha           :string(255)
#  additions     :integer
#  deletions     :integer
#  date          :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Commit < ActiveRecord::Base
  belongs_to :coder
  belongs_to :repository

  require 'rugged'

  def reward! options = {}
    coder.reward loc: additions, options: options
    coder.save!
  end

  def self.register_from_sha repo, sha, options = {}
    r_commit = repo.rugged_repo.lookup sha
    register_rugged repo, r_commit, options
  end

  def self.register_rugged repo, r_commit, options = {}
    Commit.find_or_create_by  repository: repo,
                              sha: r_commit.oid do |commit|
      commit.coder = get_committer repo, r_commit
      commit.set_stats r_commit
      commit.reward! options if options.fetch(:reward, true)
    end
  end

  # should be private
  def set_stats r_commit
    if r_commit.parents.size < 2
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

  private
  def self.get_committer repo, r_commit
    identity = GitIdentity.find_or_create_by name:  r_commit.committer[:name],
                                  email: r_commit.committer[:email] do |id|
        id.coder = get_committer_from_github repo, r_commit
      end
    identity.coder
  end

  def self.get_committer_from_github repo, r_commit
    commit = $github.repos.commits.get repo.user, repo.name, r_commit.oid
    Coder.find_or_create_by_github_name commit.committer.login
  end
end
