# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Repository < ActiveRecord::Base
  has_many :bounties
  validates :name, presence: true
end
