# == Schema Information
#
# Table name: organisations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Organisation < ActiveRecord::Base
  has_many :repositories
  validates :name, presence: true

  def fetch_repositories
    repos = $github.repos.list :all, org: name
    repos.each do |json|
      Repository.register self, json.name
    end
  end
end
