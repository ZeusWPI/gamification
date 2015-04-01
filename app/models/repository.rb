# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Repository < ActiveRecord::Base
  has_many :issues
  has_many :commits
  has_many :bounties, through: :issues
  has_many :coders, -> { uniq }, through: :commits

  validates :name, presence: true

  require 'rugged'

  # Git operations
  def self.register name
    repo = Repository.find_or_create_by name: name do |r|
      r.clone
    end
    repo.pull
    repo.register_commits
    repo.fetch_issues
  end

  def clone
    `mkdir -p #{path} && git clone #{clone_url} #{path}`
  end

  def pull
    `cd #{path} && git pull`
  end

  def register_commits
    r_repo = rugged_repo
    walker = Rugged::Walker.new(r_repo)
    # Push all heads
    r_repo.branches.each { |b| walker.push b.target_id }
    walker.push(r_repo.last_commit)
    walker.each do |commit|
      Commit.register_rugged self, commit, reward: false
    end
  end

  def fetch_issues
    $github.issues.list(user: Rails.application.config.organisation,
                        repo: name, filter: 'all').each do |hash|
      Issue.find_or_create_from_hash hash, self
    end
  end

  require 'rugged'
  def rugged_repo
    Rugged::Repository.new(path)
  end

  def full_name
    "#{Rails.application.config.organisation}/#{name}"
  end

  private
  def path
    "#{Rails.root}/repos/#{name}"
  end

  def clone_url
    "https://#{Rails.application.secrets.github_token}@github.com/#{full_name}.git"
  end
end
