class Organisation < ActiveRecord::Base
  has_many :repositories
end
