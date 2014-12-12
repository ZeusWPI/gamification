class Organisation < ActiveRecord::Base
  has_many :repositories
  validates :name, presence: true

  def fetch_repositories
    repos = $github.repos.list user: name
    repos.each do |json|
      repo = Repository.find_or_create_by organisation: self, name: json.name do |r|
        # Only clone a new repo
        r.clone
      end
      repo.pull
      repo.register_commits
      repo.fetch_issues
    end
  end
end
