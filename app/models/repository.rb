# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  user       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Repository < ActiveRecord::Base
  has_many :bounties
  has_many :commits
  validates :user, presence: true
  validates :name, presence: true

  require 'rugged'

  def clone
    # get url from github
    repo = $github.repos.get(user: user, repo: name)
    `cd #{Rails.root}/repos && git clone #{repo.clone_url}`
  end

  def pull
    `cd #{path} && git pull`
  end

  def register_commits
    r_repo = rugged_repo
    walker = Rugged::Walker.new(r_repo)
    walker.push(r_repo.last_commit)
    walker.each do |commit|
      Commit.register_rugged self, commit
    end
  end

  require 'rugged'
  def rugged_repo
    Rugged::Repository.new(path)
  end

  private
  def path
    "#{Rails.root}/repos/#{name}"
  end

end
