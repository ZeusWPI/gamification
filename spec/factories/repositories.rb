# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

require 'faker'

FactoryGirl.define do
  factory :repository do
    name { Faker::Lorem.word }
  end
end

