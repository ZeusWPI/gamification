class Organisation < ActiveRecord::Base
  has_many :repositories
  validates :name, presence: true

  def fetch_repositories
    repos = $github.repos.list user: name
    repos.each do |json|
      Repository.register self, json.name
    end
  end
end
