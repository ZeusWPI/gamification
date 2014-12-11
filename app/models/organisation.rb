class Organisation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  has_many :repositories
end
