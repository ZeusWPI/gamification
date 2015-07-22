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
  extend FriendlyId
  extend Datenfisch::Model
  friendly_id :name

  has_many :issues
  has_many :commits
  has_many :bounties, through: :issues
  has_many :coders, -> { uniq }, through: :commits

  validates :name, presence: true

  include Schwarm
  stat :additions, CommitFisch.additions
  stat :deletions, CommitFisch.deletions
  stat :commit_count, CommitFisch.count
  stat :changed_lines, additions + deletions
  stat :score, CommitFisch.addition_score

  require 'rugged'

  def pull_or_clone
    if Dir.exists? path
      `cd #{path} && git fetch && git reset --hard origin/master`
    else
      `mkdir -p #{path} && git clone #{authenticated_clone_url} #{path}`
    end
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
                        repo: name, state: 'all', filter: 'all').each do |hash|
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

  def self.create_or_update repo_hash
    repo = Repository.find_or_create_by name: repo_hash['name'] do |r|
      r.github_url = repo_hash['html_url']
      r.clone_url = repo_hash['clone_url']
    end
    repo.pull_or_clone
    repo.register_commits
    repo.fetch_issues
  end

  private
  def path
    "#{Rails.root}/repos/#{name}"
  end

  def authenticated_clone_url
    clone_url.sub('https://') { $& + Rails.application.secrets.github_token + '@' }
  end
end
